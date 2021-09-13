
import rng

def would_get_encounter(encounter_threshold, mRNG):
    return encounter_threshold > (mRNG % 0x20)
#def

def check_frame(mRNG, constraints):
	for constraint in constraints:
		# TODO check possible wiggles
		mRNG_test = rng.iterate_RNG(mRNG, constraint["offset"])
		if would_get_encounter(constraint["threshold"], mRNG_test) != constraint["got_encounter"]:
			return False
		#if
	#for
	return True
#def

def find_windows(index_start, index_end, constraints, pressA_offset=0):
	print(f"Searching for windows from {index_start:d} to {index_end:d}...")
	
	mRNG = rng.iterate_RNG(0xA338244F, index_start-1) # lRNG Seed 0x873CA9E4
	
	for RNG_index in range(index_start, index_end+1):
		print(f"{RNG_index-pressA_offset:03d}: {check_frame(mRNG, constraints)}")
		mRNG = rng.simulate_RNG(mRNG)
	#for
#def

""" Example Encounter Curves (BN 3):
#: 00 01 02 03 04 05 06 07 - step
---------------------------------
0: 00 00 00 00 00 00 00 00 -    0
1: 00 00 00 00 00 00 00 00 -   64
2: 01 00 00 00 00 00 00 00 -  128
3: 02 01 00 00 00 00 00 00 -  192
4: 03 02 01 00 00 00 00 00 -  256
5: 04 03 02 01 00 00 00 00 -  320
6: 05 04 03 02 01 00 00 00 -  384
7: 06 05 04 03 02 00 00 00 -  448
8: 08 06 05 04 03 01 00 00 -  512
9: 0A 08 06 05 04 02 00 00 -  576
A: 0C 0A 08 06 05 03 00 00 -  640
B: 0E 0C 0A 08 06 04 00 00 -  704
C: 10 0E 0C 0A 08 05 00 00 -  768
D: 12 10 0E 0C 0A 06 00 00 -  832
E: 14 12 10 0E 0C 08 02 00 -  896
F: 1A 14 12 10 0E 0A 06 00 -  960
G: 1C 1A 14 12 10 0C 0C 00 - 1024
BugRun uses Curve 00

-- ram.would_get_encounter(0x439E54F2); -- true
-- 0x439E54F2 01000011100111100101010011110010 input
-- 0x873CA9E4 10000111001111001010100111100100 lshift
-- 0x873CA9E5 10000111001111001010100111100101 add+1
-- 0x873CA9E5 10000111001111001010100111100101 xor
-- 0x00000000 00000000000000000000000000000000 yes encounter

-- ram.would_get_encounter(0xBC61AB0C); -- false
-- 0xBC61AB0C 10111100011000011010101100001100 input
-- 0x78C35619 01111000110000110101011000011001 lshift
-- 0x78C3561A 01111000110000110101011000011010 add+1
-- 0x873CA9E5 10000111001111001010100111100101 xor
-- 0xFFFFFFFF 11111111111111111111111111111111 no encounter
"""

print("")

# IceBall M[anip]
#  896 0x02  2  6% 190 313  664  691
#  960 0x06  6 18% 478 601  952  979
# 1024 0x0C 12 38% 766 889 1240 1267
# A on 131, 1 on 264, 2 on 553, 3 on 842
#     -133,        0,      289,      578
index_start = 200
index_end   = 999
constraints = [
    {
        "offset"       :     0,
        "threshold"    :  0x02,
        "got_encounter": False,
    },
    {
        "offset"       :   289,
        "threshold"    :  0x06,
        "got_encounter": False,
    },
    {
        "offset"       :   578,
        "threshold"    :  0x0C,
        "got_encounter":  True,
    },
]
pressA_offset = 132 # verified on actual HUD
find_windows(index_start, index_end, constraints, pressA_offset)



constraints = [{
    "offset"       :    0,
    "threshold"    : 0x0C,
    "got_encounter": True,
}]
find_windows(1, 1000, constraints)



#print(f"{rng.reverse_RNG(0x02-1):08x}")
#print(f"{rng.reverse_RNG(0x06-1):08x}")
#print(f"{rng.reverse_RNG(0x0C-1):08x}")

