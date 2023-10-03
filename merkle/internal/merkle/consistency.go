package merkle

type ConsistencyParam struct {
	OldSize uint64 `json:"old_size"`
	NewSize uint64 `json:"new_size"`
	OldRoot Hash   `json:"old_root"`
	NewRoot Hash   `json:"new_root"`
	Path    []Hash `json:"consistency_path"`

	Comment string `json:"comment,omitempty"`
}

func (p *ConsistencyParam) Copy() ConsistencyParam {
	path := make([]Hash, len(p.Path))
	copy(path, p.Path)
	return ConsistencyParam{p.OldSize, p.NewSize, p.OldRoot, p.NewRoot, path, p.Comment}
}

func ConsistencyValid() []ConsistencyParam {
	return consistencyParams
}

func ConsistencyInvalid() []ConsistencyParam {
	return mutateConsistencyParams(consistencyParams)
}

var consistencyParams = []ConsistencyParam{
	// Size 0
	{OldSize: 0, NewSize: 0, OldRoot: rootHash(nil), NewRoot: rootHash(nil), Path: []Hash{}},
	// Size 1
	{OldSize: 0, NewSize: 1, OldRoot: rootHash(nil), NewRoot: th('a', 'a'), Path: []Hash{}},
	{OldSize: 1, NewSize: 1, OldRoot: th('a', 'a'), NewRoot: th('a', 'a'), Path: []Hash{}},
	// Size 10
	{OldSize: 1, NewSize: 10, OldRoot: th('a', 'a'), NewRoot: th('a', 'j'), Path: []Hash{th('b', 'b'), th('c', 'd'), th('e', 'h'), th('i', 'j')}},
	// TODO: port all test vectors from rgdd/ct
}

func mutateConsistencyParams(valid []ConsistencyParam) (params []ConsistencyParam) {
	for _, v := range valid {
		var p ConsistencyParam

		//
		// Changing the size of the old tree is similiar to changing the
		// index in an inclusion proof.  (One way to view a consistency
		// proof is as an inclusion proof to a particular subtree.)  So,
		// all i in [0, new_size+1] are invalid unless i == old_size.
		//
		for oldSize := uint64(0); oldSize <= v.NewSize+1; oldSize++ {
			if oldSize == v.OldSize {
				continue
			}

			p = v.Copy()
			p.OldSize = oldSize
			p.Comment = "mutated \"old_size\""
			params = append(params, p)
		}

		// TODO: port all mutations from rgdd/ct
	}
	return
}
