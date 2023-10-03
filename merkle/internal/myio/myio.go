package myio

import (
	"encoding/json"
	"os"
)

func Save(filePath string, v interface{}) error {
	b, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return err
	}
	if err := os.WriteFile(filePath, b, 0644); err != nil {
		return err
	}
	return nil
}
