# Proxy-Wasm Go Filter Template

This repository contains a [Proxy-Wasm](https://github.com/proxy-wasm/spec)
filter that can be used as a reference to quickly start implementing new
filters in Go.

This is a "hello-world" type filter performing a minimal operation and showing
the basics of filter configuration: it simply adds a new header `X-Greeting`
to a proxied response. You can pass the filter a JSON configuration in the
format `{ "my_greeting": "Howdy!" }` to change the value of the injected
header.

Please refer to [WasmX
docs](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md#supported-entrypoints)
for the list of supported functions and entrypoints.

## Requirements

* [tinygo](https://tinygo.org) - a Go compiler that can produce WebAssembly code.

## Build

Once the Go environment is set up and tinygo is in the PATH, build the filter running
`make`.

This will produce a .wasm file in the root of the project.
