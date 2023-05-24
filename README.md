# Proxy-Wasm Go Filter Template

This repository contains a [Proxy-Wasm](https://github.com/proxy-wasm/spec)
filter that can be used as a reference to quickly start implementing new
filters in Go. The filter implements only a minimum set of the entrypoints
supported by WasmX -- not implemented entrypoints can be found in comments.

Please refer to [WasmX docs](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md#supported-entrypoints)
for the list of supported entrypoints.

## Requirements

* [tinygo](https://tinygo.org)
* [proxy-wasm-go-sdk](github.com/tetratelabs/proxy-wasm-go-sdk)
* [ffjson](https://github.com/pquerna/ffjson)


## Build

Once the environment is set up with the requirements, build the filter running
`make`.

This will produce a .wasm file in the root of the project.
