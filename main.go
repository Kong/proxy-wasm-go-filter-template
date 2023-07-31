package main

import (
	"fmt"

	"github.com/kong/proxy-wasm-go-filter-template/config"

	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

func main() {
	proxywasm.SetVMContext(&myPluginVMContext{})
}

type (
	myPluginVMContext struct {
		types.DefaultVMContext
	}

	myPluginContext struct {
		conf config.Config

		types.DefaultPluginContext
	}

	myPluginHTTPContext struct {
		conf *config.Config

		types.DefaultHttpContext
	}
)

// -----------------------------------------------------------------------------
// VM Context
// -----------------------------------------------------------------------------
//
// func (*myPluginVMContext) OnVMStart(vmConfigurationSize int) types.OnVMStartStatus {
// 	return types.OnVMStartStatusOK
// }

func (*myPluginVMContext) NewPluginContext(vmID uint32) types.PluginContext {
	return &myPluginContext{}
}

// -----------------------------------------------------------------------------
// Plugin Context
// -----------------------------------------------------------------------------

func (ctx *myPluginContext) OnPluginStart(confSize int) types.OnPluginStartStatus {
	data, err := proxywasm.GetPluginConfiguration()
	if err != nil && err != types.ErrorStatusNotFound {
		proxywasm.LogCriticalf("error reading plugin configuration: %v", err)
		return types.OnPluginStartStatusFailed
	}

	err = config.Load(data, &ctx.conf)
	if err != nil {
		proxywasm.LogCriticalf("error parsing plugin configuration: %v", err)
		return types.OnPluginStartStatusFailed
	}

	return types.OnPluginStartStatusOK
}

func (ctx *myPluginContext) NewHttpContext(pluginID uint32) types.HttpContext {
	return &myPluginHTTPContext{
		conf: &ctx.conf,
	}
}

// func (ctx *myPluginContext) OnTick() {
// 	proxywasm.LogInfo("[plugin] OnTick")
// }
//
// func (*myPluginContext) OnPluginDone() bool {
// 	return true
// }
//
// -----------------------------------------------------------------------------
// HTTP Context
// -----------------------------------------------------------------------------

// func (*myPluginHTTPContext) OnHttpRequestHeaders(int, bool) types.Action {
// 	return types.ActionContinue
// }
//
// func (*myPluginHTTPContext) OnHttpRequestBody(int, bool) types.Action {
// 	return types.ActionContinue
// }

func (ctx *myPluginHTTPContext) OnHttpResponseHeaders(int, bool) types.Action {
	if ctx.conf.MyGreeting != "" {
		greeting := fmt.Sprintf("%v", ctx.conf.MyGreeting)
		proxywasm.AddHttpResponseHeader("X-Greeting", greeting)
	}
	return types.ActionContinue
}

// func (*myPluginHTTPContext) OnHttpResponseBody(int, bool) types.Action {
// 	return types.ActionContinue
// }
//
// func (*myPluginHTTPContext) OnHttpStreamDone() {
// }
