#!/bin/bash

# TODO: [a], [a,b], [a,b,c], ... rather than [0], [0,1], [0,1,2], ...

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
#     0      0 1        0 1   2        0 1   2 3
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
#     0 1   2 3   4 5   6 7   8 9   a b   c d   e f
#
# The used hash function is SHA256. Leaf hashes are computed as H(0x00 | data).
# Interior hashes are computed as H(0x01 | left_hash | right_hash).  
#

set -eu

function main() {
	start_json_list

	# o
	# |
	# 0
	th_0T0=$(leaf_hash "0")
	write_json_object "0" $th_0T0 $th_0T0 ","

	#  o 
	# o o
	# | |
	# 0 1
	th_1T1=$(leaf_hash "1");
	th_0T1=$(interior_hash $th_0T0 $th_1T1)
	write_json_object "1" $th_1T1 $th_0T1 ","

	#     o 
	#  o
	# o o   o
	# | |   |
	# 0 1   2
	th_2T2=$(leaf_hash "2");
	th_0T2=$(interior_hash $th_0T1 $th_2T2)
	write_json_object "2" $th_2T2 $th_0T2 ","

	#     o 
	#  o     o
	# o o   o o
	# | |   | |
	# 0 1   2 3
	th_3T3=$(leaf_hash "3");
	th_2T3=$(interior_hash $th_2T2 $th_3T3)
	th_0T3=$(interior_hash $th_0T1 $th_2T3)
	write_json_object "3" $th_3T3 $th_0T3 ","

	#           o
	#     o
	#  o     o
	# o o   o o   o
	# | |   | |   |
	# 0 1   2 3   4
	th_4T4=$(leaf_hash "4");
	th_0T4=$(interior_hash $th_0T3 $th_4T4)
	write_json_object "4" $th_4T4 $th_0T4 ","

	#           o
	#     o
	#  o     o     o
	# o o   o o   o o
	# | |   | |   | |
	# 0 1   2 3   4 5
	th_5T5=$(leaf_hash "5");
	th_4T5=$(interior_hash $th_4T4 $th_5T5)
	th_0T5=$(interior_hash $th_0T3 $th_4T5)
	write_json_object "5" $th_5T5 $th_0T5 ","

	#           o
	#     o           o
	#  o     o     o
	# o o   o o   o o   o
	# | |   | |   | |   |
	# 0 1   2 3   4 5   6
	th_6T6=$(leaf_hash "6");
	th_4T6=$(interior_hash $th_4T5 $th_6T6)
	th_0T6=$(interior_hash $th_0T3 $th_4T6)
	write_json_object "6" $th_6T6 $th_0T6 ","

	#           o
	#     o           o
	#  o     o     o     o
	# o o   o o   o o   o o
	# | |   | |   | |   | |
	# 0 1   2 3   4 5   6 7
	th_7T7=$(leaf_hash "7");
	th_6T7=$(interior_hash $th_6T6 $th_7T7)
	th_4T7=$(interior_hash $th_4T5 $th_6T7)
	th_0T7=$(interior_hash $th_0T3 $th_4T7)
	write_json_object "7" $th_7T7 $th_0T7 ","

	#                       o
	#           o
	#     o           o
	#  o     o     o     o
	# o o   o o   o o   o o   o
	# | |   | |   | |   | |   |
	# 0 1   2 3   4 5   6 7   8
	th_8T8=$(leaf_hash "8");
	th_0T8=$(interior_hash $th_0T7 $th_8T8)
	write_json_object "8" $th_8T8 $th_0T8 ","

	#                       o
	#           o
	#     o           o
	#  o     o     o     o     o
	# o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |
	# 0 1   2 3   4 5   6 7   8 9
	th_9T9=$(leaf_hash "9");
	th_8T9=$(interior_hash $th_8T8 $th_9T9)
	th_0T9=$(interior_hash $th_0T7 $th_8T9)
	write_json_object "9" $th_9T9 $th_0T9 ","

	#                       o
	#           o
	#     o           o           o
	#  o     o     o     o     o
	# o o   o o   o o   o o   o o   o
	# | |   | |   | |   | |   | |   |
	# 0 1   2 3   4 5   6 7   8 9   a
	th_aTa=$(leaf_hash "a");
	th_8Ta=$(interior_hash $th_8T9 $th_aTa)
	th_0Ta=$(interior_hash $th_0T7 $th_8Ta)
	write_json_object "a" $th_aTa $th_0Ta ","

	#                       o
	#           o
	#     o           o           o
	#  o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |   | |
	# 0 1   2 3   4 5   6 7   8 9   a b
	th_bTb=$(leaf_hash "b");
	th_aTb=$(interior_hash $th_aTa $th_bTb)
	th_8Tb=$(interior_hash $th_8T9 $th_aTb)
	th_0Tb=$(interior_hash $th_0T7 $th_8Tb)
	write_json_object "b" $th_bTb $th_0Tb ","

	#                       o
	#           o                       o
	#     o           o           o
	#  o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o
	# | |   | |   | |   | |   | |   | |   |
	# 0 1   2 3   4 5   6 7   8 9   a b   c
	th_cTc=$(leaf_hash "c");
	th_8Tc=$(interior_hash $th_8Tb $th_cTc)
	th_0Tc=$(interior_hash $th_0T7 $th_8Tc)
	write_json_object "c" $th_cTc $th_0Tc ","

	#                       o
	#           o                       o
	#     o           o           o
	#  o     o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |   | |   | |
	# 0 1   2 3   4 5   6 7   8 9   a b   c d
	th_dTd=$(leaf_hash "d");
	th_cTd=$(interior_hash $th_cTc $th_dTd)
	th_8Td=$(interior_hash $th_8Tb $th_cTd)
	th_0Td=$(interior_hash $th_0T7 $th_8Td)
	write_json_object "d" $th_dTd $th_0Td ","

	#                       o
	#           o                       o
	#     o           o           o           o
	#  o     o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o o   o
	# | |   | |   | |   | |   | |   | |   | |   |
	# 0 1   2 3   4 5   6 7   8 9   a b   c d   e
	th_eTe=$(leaf_hash "e");
	th_cTe=$(interior_hash $th_cTd $th_eTe)
	th_8Te=$(interior_hash $th_8Tb $th_cTe)
	th_0Te=$(interior_hash $th_0T7 $th_8Te)
	write_json_object "e" $th_eTe $th_0Te ","

	#                       o
	#           o                       o
	#     o           o           o           o
	#  o     o     o     o     o     o     o     o
	# o o   o o   o o   o o   o o   o o   o o   o o
	# | |   | |   | |   | |   | |   | |   | |   | |
	# 0 1   2 3   4 5   6 7   8 9   a b   c d   e f
	th_fTf=$(leaf_hash "f");
	th_eTf=$(interior_hash $th_eTe $th_fTf)
	th_cTf=$(interior_hash $th_cTd $th_eTf)
	th_8Tf=$(interior_hash $th_8Tb $th_cTf)
	th_0Tf=$(interior_hash $th_0T7 $th_8Tf)
	write_json_object "f" $th_fTf $th_0Tf ""
	
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
