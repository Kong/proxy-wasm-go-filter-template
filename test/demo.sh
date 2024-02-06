#!/usr/bin/env bash
set -x

DEMO_KONG_CONTAINER="${DEMO_KONG_CONTAINER:-kong-wasm}"
DEMO_KONG_IMAGE="${DEMO_KONG_IMAGE:-kong/kong:nightly}"

function message() {
    set +x
    echo "----------------------------------------------------------------------"
    echo $1
    echo "----------------------------------------------------------------------"
    set -x
}

################################################################################

if [[ "$1" == "stop" ]]
then
    docker stop $DEMO_KONG_CONTAINER
    docker rm $DEMO_KONG_CONTAINER
    exit 0
fi

### Build filter ###############################################################

message "Building the filter using tinygo..."

(
    cd ..
    make || exit 1
) || exit 1

### Copy filter to wasm/ #######################################################

mkdir -p wasm

cp -a ../*.wasm ../*.meta.json wasm/

script_dir=$(dirname $(realpath $0))

### Start container ############################################################

message "Setting up the Kong Gateway container..."

docker stop $DEMO_KONG_CONTAINER
docker rm $DEMO_KONG_CONTAINER

# Config trick to access localhost in a local Docker test,
# in case you want to edit your config/demo.yml to target
# a localhost server rather than httpbin.org:
#
# access_localhost="--add-host=host.docker.internal:$(ip -j address | jq -r '[ .[] | select(.ifname | test("^[ew]")) | .addr_info[] | select(.family == "inet") | .local ][0]')"
access_localhost=""

docker run -d --name "$DEMO_KONG_CONTAINER" \
    $access_localhost \
    -v "$script_dir/config:/kong/config/" \
    -v "$script_dir/wasm:/wasm" \
    -e "KONG_LOG_LEVEL=info" \
    -e "KONG_DATABASE=off" \
    -e "KONG_DECLARATIVE_CONFIG=/kong/config/demo.yml" \
    -e "KONG_NGINX_WASM_SHM_KV_KONG_WASM_RATE_LIMITING_COUNTERS=12m" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_WASM=on" \
    -e "KONG_WASM_FILTERS_PATH=/wasm" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
     "$DEMO_KONG_IMAGE"

### Show configuration #########################################################

message "This is the configuration loaded into Kong:"

cat config/demo.yml

sleep 5

### Issue requests #############################################################

message "Now let's send a request to see the filter in effect:"

http :8000/anything

message "Finishing up!"

docker stop $DEMO_KONG_CONTAINER
#docker rm $DEMO_KONG_CONTAINER

