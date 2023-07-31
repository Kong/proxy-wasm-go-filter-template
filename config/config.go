package config

import (
	"github.com/pquerna/ffjson/ffjson"
)

// -----------------------------------------------------------------------------
// Instance Config
// -----------------------------------------------------------------------------
//go:generate ffjson -noencoder $GOFILE

// Config represents the filter configuration
type Config struct {
	MyGreeting string `json:"my_greeting"`
}

// Load json config from data into conf
func Load(data []byte, conf *Config) error {
	conf.MyGreeting = "Hello, Wasm!"

	err := ffjson.Unmarshal(data, conf)
	if err != nil {
		return err
	}

	return nil
}
