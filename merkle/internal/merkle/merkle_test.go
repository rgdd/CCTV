package merkle

import (
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"os"
	"testing"
)

const (
	testdataFile = "../../testdata/merkle_tree.json"
)

type testCase struct {
	LeafData string `json:"leaf_data"`
	LeafHash Hash   `json:"leaf_hash"`
	RootHash Hash   `json:"root_hash"`
}

func testCases(t *testing.T) (testCases []testCase) {
	b, err := os.ReadFile("../../testdata/merkle_tree.json")
	if err != nil {
		t.Fatal(err)
	}
	if err := json.Unmarshal(b, &testCases); err != nil {
		t.Fatal(err)
	}
	return
}

func emptyHash(t *testing.T) (h Hash) {
	b, err := base64.StdEncoding.DecodeString("47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=")
	if err != nil {
		t.Fatal(err)
	}
	if got, want := len(b), sha256.Size; got != want {
		t.Fatalf("wrong hash size: %d", got)
	}
	copy(h[:], b)
	return
}

func TestRootHash(t *testing.T) {
	leafHashes := make([]Hash, 0)
	if got, want := rootHash(leafHashes), emptyHash(t); got != want {
		t.Errorf("invalid empty tree Hash\ngot:  %x\nwant %x\n", got, want)
	}
	for i, tc := range testCases(t) {
		leafHashes = append(leafHashes, tc.LeafHash)
		if got, want := rootHash(leafHashes), tc.RootHash; got != want {
			t.Errorf("test-case %d: invalid root hash\ngot:  %x\nwant: %x\n", i, got, want)
		}
	}
}

func TestTH(t *testing.T) {
	for i, tc := range testCases(t) {
		if len(tc.LeafData) != 1 || int(tc.LeafData[0]-'a') != i {
			t.Errorf("unexpected leaf data in test case %d: %s (aborting)", i, tc.LeafData)
			return
		}

		from := byte('a')
		to := tc.LeafData[0]
		if got, want := th(from, to), tc.RootHash; got != want {
			t.Errorf("test-case %d: invalid root hash\ngot:  %x\nwant: %x\n", i, got, want)
		}
	}
}
