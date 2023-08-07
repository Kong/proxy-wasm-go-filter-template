GO=go
GOFMT=gofmt
TINYGO=tinygo
FILTER_NAME=my-go-filter
GOPATH_BIN := $(shell echo $${GOPATH:-$$HOME/go}/bin)

build: main.go config/config.go config/config_ffjson.go go.mod
	$(GO) get
	$(TINYGO) build -o $(FILTER_NAME).wasm -scheduler=none -target=wasi -tags timetzdata

$(GOPATH_BIN)/ffjson:
	$(GO) install github.com/pquerna/ffjson@latest

config/config_ffjson.go: $(GOPATH_BIN)/ffjson config/config.go
	PATH=$$PATH:$(GOPATH_BIN) $(GO) generate ./...

fmt:
	$(GOFMT) -w .

clean:
	rm $(FILTER_NAME).wasm
