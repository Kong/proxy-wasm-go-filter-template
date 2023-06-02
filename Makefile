GO=go
GOFMT=gofmt
TINYGO=tinygo
FILTER_NAME=my-go-filter

build: main.go config/config.go config/config_ffjson.go go.mod
	$(TINYGO) build -o $(FILTER_NAME).wasm -scheduler=none -target=wasi -tags timetzdata

config/config_ffjson.go: config/config.go
	$(GO) generate ./...

fmt:
	$(GOFMT) -w .

clean:
	rm $(FILTER_NAME).wasm
