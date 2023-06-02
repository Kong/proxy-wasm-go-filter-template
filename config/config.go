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
	MyStatusCode uint32 `json:"my_status_code"`
}

// Load json config from data into conf
func Load(data []byte, conf *Config) error {
	conf.MyStatusCode = 0

	err := ffjson.Unmarshal(data, conf)
	if err != nil {
		return err
	}

	return nil
}
