package merkle

import (
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
)

func HashFn(b []byte) Hash {
	return sha256.Sum256(b)
}

type Hash [sha256.Size]byte

func (h *Hash) UnmarshalJSON(b []byte) error {
	var s string

	if err := json.Unmarshal(b, &s); err != nil {
		return err
	}
	b, err := base64.StdEncoding.DecodeString(s)
	if err != nil {
		return err
	}
	if n := len(b); n != sha256.Size {
		return fmt.Errorf("invalid hash size: %d", n)
	}

	copy(h[:], b)
	return nil
}

func (h *Hash) MarshalJSON() ([]byte, error) {
	return json.Marshal(h[:])
}
