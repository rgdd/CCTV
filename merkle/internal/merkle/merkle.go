package merkle

import (
	"math"
	"math/big"
)

func leafHash(data []byte) Hash {
	node := []byte{0x00}
	node = append(node, data...)
	return HashFn(node)
}

func interiorHash(left, right Hash) Hash {
	node := []byte{0x01}
	node = append(node, left[:]...)
	node = append(node, right[:]...)
	return HashFn(node)
}

func rootHash(leafHashes []Hash) Hash {
	switch len(leafHashes) {
	case 0:
		return HashFn(nil)
	case 1:
		return leafHashes[0]
	default:
		left, right := split(leafHashes)
		return interiorHash(rootHash(left), rootHash(right))
	}
}

func split(leafHashes []Hash) ([]Hash, []Hash) {
	k := int(math.Pow(2, float64(big.NewInt(int64(len(leafHashes)-1)).BitLen()-1)))
	return leafHashes[:k], leafHashes[k:]
}

func th(from, to byte) Hash {
	var leaves []Hash
	for ch := from; ch <= to; ch++ {
		leaves = append(leaves, leafHash([]byte{ch}))
	}
	return rootHash(leaves)
}
