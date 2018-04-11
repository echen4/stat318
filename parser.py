"""
STAT 318 Final Project
Team Rocket Is Blasting Off Again!
Evelyn Chen & Alexandria Guo
SPECIAL CASES:
MEGA / PRIMAL / SMALLsizes / X / Origin
(find index of first incidence of 'Mega ' replace end of string with '-Mega')
MEGAS X & Y (Charizard, Mewtwo)
ALOLA (not in .csv)
DEOXYS FORMS
ARCEUS (Others & Normal)
HOOPA (not in .csv)
"""

import sys
import json
import csv

def parser(filename):
	data = {}
	with open(filename, 'r') as f:
		for line in f:
			if "|" in line and "Usage %" not in line:
				# rank, usage %, raw, %, real, %
				newline = line[2:-3].split("|")
				newline = [x.strip() for x in newline]

				data[newline[1]] = newline
	return data

def writeJSON(filename, data):
	with open(filename, 'w') as f:
		json.dump(data, f)

def load_csv(csv_file):
    """given a CSV file where each row is a data point,
    with the first column being user/item id, the second column being the
    item/user id, and the third column being the rating, return a dictonary
    with the first column of user/item as keys to dictionaries with the second
    column item/user as keys for their rating values
    """
    reader = csv.reader(open(csv_file, 'r'))
    pkmn_directory = {}
    headers = next(reader);
    print(headers);
    # PKMN#, Name, Type1, Type2, Total, HP, Attack, Defense, Sp.Atk, Sp.Def, Speed, Generation, Legendary
    for dp in reader:
        if (dp[1] in pkmn_directory):
            print("Adding " + dp[1] + "again")
        else:
			if dp[1][:]
            pkmn_directory[dp[1]] = [dp[0]] + list(dp[2:len(dp)])
    return pkmn_directory

def main(txt_data, csv_data, json_out):
	writeJSON(json_out, parser(txt_data))
    pkmn_directory1 = load_csv(csv_file)

if __name__=='__main__':
    if len(sys.argv)!=2:
        print('Usage: python data_loading.py txt_data csv_data json_out')
    else:
        main(sys.argv[1], sys.argv[2], sys.argv[3])