package merkle

type InclusionParam struct {
	LeafHash  Hash   `json:"leaf_hash"`
	LeafIndex uint64 `json:"leaf_index"`
	TreeSize  uint64 `json:"tree_size"`
	RootHash  Hash   `json:"root_hash"`
	Path      []Hash `json:"inclusion_path"`

	Comment string `json:"comment,omitempty"`
}

func (p *InclusionParam) Copy() InclusionParam {
	path := make([]Hash, len(p.Path))
	copy(path, p.Path)
	return InclusionParam{p.LeafHash, p.LeafIndex, p.TreeSize, p.RootHash, path, p.Comment}
}

func InclusionValid() []InclusionParam {
	return inclusionParams
}

func InclusionInvalid() []InclusionParam {
	return mutateInclusionParams(inclusionParams)
}

var inclusionParams = []InclusionParam{
	// Size 1
	{LeafHash: leafHash([]byte{'a'}), LeafIndex: 0, TreeSize: 1, RootHash: th('a', 'a'), Path: []Hash{}},
	// Size 2
	{LeafHash: leafHash([]byte{'a'}), LeafIndex: 0, TreeSize: 2, RootHash: th('a', 'b'), Path: []Hash{th('b', 'b')}},
	{LeafHash: leafHash([]byte{'b'}), LeafIndex: 1, TreeSize: 2, RootHash: th('a', 'b'), Path: []Hash{th('a', 'a')}},
	// Size 10
	{LeafHash: leafHash([]byte{'a'}), LeafIndex: 0, TreeSize: 10, RootHash: th('a', 'j'), Path: []Hash{th('a', 'a'), th('b', 'c'), th('d', 'g'), th('h', 'i')}},
	// TODO: port all test vectors from rgdd/ct
}

func mutateInclusionParams(valid []InclusionParam) (params []InclusionParam) {
	for _, v := range valid {
		var p InclusionParam

		// Changing leaf hash is always invalid
		p = v.Copy()
		p.LeafHash[0] += 1
		p.Comment = "mutated \"leaf_hash\""
		params = append(params, p)

		// TODO: port all mutations from rgdd/ct
	}
	return
}
