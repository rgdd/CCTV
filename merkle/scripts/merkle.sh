#!/bin/bash

#
# merkle.sh
# Outputs Merkle tree root hashes "by hand" as data items "0", "1", "2", ...,
# "f" are added.  In other words, the following Merkle trees are computed:
#
#     
#                           o              o
#             o          o              o     o
#     o      o o        o o   o        o o   o o
#     |  ->  | |   ->   | |   |   ->   | |   | |   ->
#     a      a b        a b   c        a b   c d
#
#                           .
#                  ->       .     ->
#                           .
#
#                           o
#                o                      o
#         o           o           o           o
#      o     o     o     o     o     o     o     o
#     o o   o o   o o   o o   o o   o o   o o   o o
#     | |   | |   | |   | |   | |   | |   | |   | |
#     a b   c d   e f   g h   i j   k l   m n   o p
#
# The used hash function is SHA256. Leaf hashes are computed as H(0x00 | data).
# Interior hashes are computed as H(0x01 | left_hash | right_hash).  
#

set -eu

function main() {
	start_json_list

	# o
	# |
	# a
	th_aTa=$(leaf_hash "a")
	write_json_object "a" $th_aTa $th_aTa ","

	#  o 
	# o o
	# | |
	# a b
	th_bTb=$(leaf_hash "b");
	th_aTb=$(interior_hash $th_aTa $th_bTb)
	write_json_object "b" $th_bTb $th_aTb ","

	#     o 
	#  o
	# o o   o
	# | |   |
	# a b   c
	th_cTc=$(leaf_hash "c");
	th_aTc=$(interior_hash $th_aTb $th_cTc)
	write_json_object "c" $th_cTc $th_aTc ","

	#     o 
	#  o     o
	# o o   o o
	# | |   | |
	# a b   c d
	th_dTd=$(leaf_hash "d");
	th_cTd=$(interior_hash $th_cTc $th_dTd)
	th_aTd=$(interior_hash $th_aTb $th_cTd)
	write_json_object "d" $th_dTd $th_aTd ","

	#           o
	#     o
	#  o     o
	# o o   o o   o
	# | |   | |   |
	# a b   c d   e
	th_eTe=$(leaf_hash "e");
	th_aTe=$(interior_hash $th_aTd $th_eTe)
	write_json_object "e" $th_eTe $th_aTe ","

	#           o
	#     o
	#  o     o     o
	# o o   o o   o o
	# | |   | |   | |
	# a b   c d   e f
	th_fTf=$(leaf_hash "f");
	th_eTf=$(interior_hash $th_eTe $th_fTf)
	th_aTf=$(interior_hash $th_aTd $th_eTf)
	write_json_object "f" $th_fTf $th_aTf ","

	#           o
	#     o           o
	#  o     o     o
	# o o   o o   o o   o
	# | |   | |   | |   |
	# a b   c d   e f   g
	th_gTg=$(leaf_hash "g");
	th_eTg=$(interior_hash $th_eTf $th_gTg)
	th_aTg=$(interior_hash $th_aTd $th_eTg)
	write_json_object "g" $th_gTg $th_aTg ","

	#           o
	#     o           o
	#  o     o     o     o
	# o o   o o   o o   o o
	# | |   | |   | |   | |
	# a b   c d   e f   g h
	th_hTh=$(leaf_hash "h");
	th_gTh=$(interior_hash $th_gTg $th_hTh)
	th_eTh=$(interior_hash $th_eTf $th_gTh)
	th_aTh=$(interior_hash $th_aTd $th_eTh)
	write_json_object "h" $th_hTh $th_aTh ","

	#                       o
	#           o
	#     o           o
	#  o     o     o     o
	# o o   o o   o o   o o   o
	# | |   | |   | |   | |   |
	# a b   c d   e f   g h   i
	th_iTi=$(leaf_hash "i");
	th_aTi=$(interior_hash $th_aTh $th_iTi)
	write_json_object "i" $th_iTi $th_aTi ","

	#                       o
	#           o
	#     o           o
	#  o     o     o     o     o
	# o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |
	# a b   c d   e f   g h   i j
	th_jTj=$(leaf_hash "j");
	th_iTj=$(interior_hash $th_iTi $th_jTj)
	th_aTj=$(interior_hash $th_aTh $th_iTj)
	write_json_object "j" $th_jTj $th_aTj ","

	#                       o
	#           o
	#     o           o           o
	#  o     o     o     o     o
	# o o   o o   o o   o o   o o   o
	# | |   | |   | |   | |   | |   |
	# a b   c d   e f   g h   i j   k
	th_kTk=$(leaf_hash "k");
	th_iTk=$(interior_hash $th_iTj $th_kTk)
	th_aTk=$(interior_hash $th_aTh $th_iTk)
	write_json_object "k" $th_kTk $th_aTk ","

	#                       o
	#           o
	#     o           o           o
	#  o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |   | |
	# a b   c d   e f   g h   i j   k l
	th_lTl=$(leaf_hash "l");
	th_kTl=$(interior_hash $th_kTk $th_lTl)
	th_iTl=$(interior_hash $th_iTj $th_kTl)
	th_aTl=$(interior_hash $th_aTh $th_iTl)
	write_json_object "l" $th_lTl $th_aTl ","

	#                       o
	#           o                       o
	#     o           o           o
	#  o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o
	# | |   | |   | |   | |   | |   | |   |
	# a b   c d   e f   g h   i j   k l   m
	th_mTm=$(leaf_hash "m");
	th_iTm=$(interior_hash $th_iTl $th_mTm)
	th_aTm=$(interior_hash $th_aTh $th_iTm)
	write_json_object "m" $th_mTm $th_aTm ","

	#                       o
	#           o                       o
	#     o           o           o
	#  o     o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |   | |   | |
	# a b   c d   e f   g h   i j   k l   m n
	th_nTn=$(leaf_hash "n");
	th_mTn=$(interior_hash $th_mTm $th_nTn)
	th_iTn=$(interior_hash $th_iTl $th_mTn)
	th_aTn=$(interior_hash $th_aTh $th_iTn)
	write_json_object "n" $th_nTn $th_aTn ","

	#                       o
	#           o                       o
	#     o           o           o           o
	#  o     o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o o   o
	# | |   | |   | |   | |   | |   | |   | |   |
	# a b   c d   e f   g h   i j   k l   m n   o
	th_oTo=$(leaf_hash "o");
	th_mTo=$(interior_hash $th_mTn $th_oTo)
	th_iTo=$(interior_hash $th_iTl $th_mTo)
	th_aTo=$(interior_hash $th_aTh $th_iTo)
	write_json_object "o" $th_oTo $th_aTo ","

	#                       o
	#           o                       o
	#     o           o           o           o
	#  o     o     o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |   | |   | |   | |
	# a b   c d   e f   g h   i j   k l   m n   o p
	th_pTp=$(leaf_hash "p");
	th_oTp=$(interior_hash $th_oTo $th_pTp)
	th_mTp=$(interior_hash $th_mTn $th_oTp)
	th_iTp=$(interior_hash $th_iTl $th_mTp)
	th_aTp=$(interior_hash $th_aTh $th_iTp)
	write_json_object "p" $th_pTp $th_aTp ""
	
	end_json_list
}

function leaf_hash() {
	printf "00$(printf $1 | base16)" | base16 -d | sha256sum | cut -d' ' -f1
}

function interior_hash() {
	printf "01$1$2" | base16 -d | sha256sum | cut -d' ' -f1
}

function write_json_object() {
	cat << EOF
  {
    "leaf_data": "$1",
    "leaf_hash": "$(printf $2 | base16 -d | base64)",
    "root_hash": "$(printf $3 | base16 -d | base64)"
  }$4
EOF
}

function start_json_list() { printf "[\n"; }
function end_json_list()   { printf "]"; }

main $@
