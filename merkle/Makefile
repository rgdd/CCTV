DIR = testdata

all:
	mkdir -p $(DIR)
	./scripts/merkle.sh >$(DIR)/merkle_tree.json
	go test ./internal/merkle
	go run ./cmd/inclusion/ -valid-file $(DIR)/inclusion-valid.json -invalid-file $(DIR)/inclusion-invalid.json
	go run ./cmd/consistency/ -valid-file $(DIR)/consistency-valid.json -invalid-file $(DIR)/consistency-invalid.json
