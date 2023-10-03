# Merkle tree test vectors

Test vectors for working with Merkle trees as defined in [RFC 6962][].

[RFC 6962]: https://datatracker.ietf.org/doc/html/rfc6962

## Overview

Test vectors for the following are provided:

  - Merkle tree head generation
  - Merkle tree inclusion proof generation
  - Merkle tree inclusion proof verification
  - Merkle tree consistency proof generation
  - Merkle tree consistency proof verification

Valid test cases are mostly created "by hand".  Invalid test cases are obtained
by mutating valid input parameters into edge cases.

## Test vectors

Generate:

    $ make
    mkdir -p testdata
    ./scripts/merkle.sh >testdata/merkle_tree.json
    go test ./internal/merkle
    ok      c2sp.org/CCTV/merkle/internal/merkle    0.001s
    go run ./cmd/inclusion/ -valid-file testdata/inclusion-valid.json -invalid-file testdata/inclusion-invalid.json
    go run ./cmd/consistency/ -valid-file testdata/consistency-valid.json -invalid-file testdata/consistency-invalid.json

The generated files are checked-in for convenience, see [testdata/](./testdata).

### Merkle tree heads

The [entire test vector](./testdata/merkle_tree.json) is a list of JSON objects:

    ...
    {
      "leaf_data": "1",
      "leaf_hash": "IhXorE4rhxwqSBieeXOMlWwIHiOsLyQVv3faGZ39kgw=",
      "root_hash": "ywCYnZSlacCmeK4EK2Pc1GJduWRAUX83put5duok7Us="
    },
    ...


**Usage:**
append each leaf hash in-order, starting with the JSON object that is listed
first.  This results in `n` Merkle tree head test cases with leaf data `[a]`
(one leaf), `[a, b]` (two leaves), `[a, b, c]` (three leaves), etc.  Note that
it is not necessary to know `"leaf_data"` when `"leaf_hash"` is provided.  Both
are included here to also facilitate testing of leaf hash computations.

### Merkle proofs

Valid inclusion and consistency proof test vectors are listed below.

**Usage (generation):**
generate your own inclusion/consistency proofs based on the provided input
parameters that are valid.  Compare your results to the expected proofs.  The
Merkle tree of size `k` must be populated as above for Merkle tree heads, i.e.,
`[a]` (one leaf), `[a, b]` (two leaves), `[a, b, c]` (three leaves), etc.

Invalid inclusion and consistency proof test vectors are also listed below.

**Usage (verification):**
run your verifier against the valid and invalid input parameters.  Check that
all valid input is accepted, and that all invalid input is rejected.

#### Inclusion

Each test file is a list of JSON objects:

    ...
    {
      "leaf_hash": "2zQm6HgGjSjSabbIcXIyLOU3K2V1bQeJAB00g19gHAM=",
      "leaf_index": 0,
      "tree_size": 2,
      "root_hash": "ywCYnZSlacCmeK4EK2Pc1GJduWRAUX83put5duok7Us=",
      "inclusion_path": [
        "IhXorE4rhxwqSBieeXOMlWwIHiOsLyQVv3faGZ39kgw="
      ]
    },
    ...

Valid test cases are enumerated in
[inclusion-valid.json](./testdata/inclusion-valid.json).

Invalid test cases are enumerated in
[inclusion-invalid.json](./testdata/inclusion-invalid.json).  A comment (key
`"comment"`) is included to specify how the valid proof became invalid.

#### Consistency

Each test file is a list of JSON objects:

    ...
    {
      "old_size": 1,
      "new_size": 2,
      "old_root": "2zQm6HgGjSjSabbIcXIyLOU3K2V1bQeJAB00g19gHAM=",
      "new_root": "ywCYnZSlacCmeK4EK2Pc1GJduWRAUX83put5duok7Us="	,
      "consistency_path": [
        "IhXorE4rhxwqSBieeXOMlWwIHiOsLyQVv3faGZ39kgw="
      ]
    },
    ...

Valid test cases are enumerated in
[consistency-valid.json](./testdata/sect-2.1.4.2-valid.json).

Invalid test cases are enumerated in
[consistency-invalid.json](./testdata/consistency-invalid.json).  A comment (key
`"comment"`) is included to specify how the valid proof became invalid.

## Contact

  - GitHub: [issue tracker][] (please tag @rgdd)
  - IRC: #certificate-transparency @ OFTC.net
  - Matrix: #certificate-transparency @ matrix.org
  - Email: rasmus (at) rgdd (dot) se

[issue tracker]: https://github.com/C2SP/CCTV/issues

## License

BSD 2-Clause License
