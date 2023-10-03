package main

import (
	"flag"
	"log"

	"c2sp.org/CCTV/merkle/internal/merkle"
	"c2sp.org/CCTV/merkle/internal/myio"
)

func main() {
	var (
		validFile   = flag.String("valid-file", "", "file name to store valid JSON test vectors")
		invalidFile = flag.String("invalid-file", "", "file name to store invalid JSON test vectors")
	)

	flag.Parse()
	if err := myio.Save(*validFile, merkle.ConsistencyValid()); err != nil {
		log.Fatal(err)
	}
	if err := myio.Save(*invalidFile, merkle.ConsistencyInvalid()); err != nil {
		log.Fatal(err)
	}
}
