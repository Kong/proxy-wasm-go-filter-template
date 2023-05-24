FFJSON=ffjson
TINYGO=tinygo
GOFMT=gofmt
FILTER_NAME=my-go-filter

build: main.go config/config.go config/config_ffjson.go go.mod
	$(TINYGO) build -o $(FILTER_NAME).wasm -scheduler=none -target=wasi -tags timetzdata

config/config_ffjson.go: config/config.go
	rm -f config/config_ffjson.go
	$(FFJSON) -noencoder config/config.go

fmt:
	$(GOFMT) -w .

clean:
	rm $(FILTER_NAME).wasm
