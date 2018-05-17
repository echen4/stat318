"""
STAT 318 Final Project
Team Rocket Is Blasting Off Again!
Evelyn Chen & Alexandria Guo
"""

import sys
import json
import csv

def parser(filename):
	data = {}
	with open(filename, 'r') as f:
		total_battles = next(f).split(": ")[1]
		next(f) #ignore avg. team weight
		headers = next(f)[2:-3].split("|")
		headers = [x.strip() for x in headers]
		for line in f:
			if "|" in line:
				# rank, PKMN, usage %, raw, %, real, %
				newline = line[2:-3].split("|")
				newline = [x.strip() for x in newline]

				data[newline[1]] = newline
	return total_battles, headers, data


def load_csv2(csv_file):
    """
    really dumb script to fix formatting of type names and find total values
    """
    reader = csv.reader(open(csv_file, 'r'))
    pkmn_directory = {}
    headers = next(reader)
    print(headers)
    with open("Pokemon_new.csv", 'w') as csvfile:
    	spamwriter = csv.writer(csvfile, delimiter=',')
    	spamwriter.writerow(headers)
    	for line in reader:
    		newline = line
    		if(line[3][0] in "abcdefghijklmnopqrstuvwxyz"):
    			line[3] = line[3][0].upper() + line[3][1:]

    		if(len(line[4]) > 0 and line[4][0] in "abcdefghijklmnopqrstuvwxyz"):
    			line[4] = line[4][0].upper() + line[4][1:]

    		if(len(line[5]) == 0):
    			line[5] = int(line[6]) + int(line[7]) + int(line[8]) + int(line[9]) + int(line[10]) + int(line[11])
    		spamwriter.writerow(newline)

    

def load_csv(csv_file):
    """given a CSV file where each row is a data point,
    with the first column being user/item id, the second column being the
    item/user id, and the third column being the rating, return a dictonary
    with the first column of user/item as keys to dictionaries with the second
    column item/user as keys for their rating values
    """
    reader = csv.reader(open(csv_file, 'r'))
    pkmn_directory = {}
    headers = next(reader)
    print(headers)
    for dp in reader:
        if (dp[1] in pkmn_directory):
            print("Adding " + dp[1] + "again")
        else: pkmn_directory[dp[1]] = [dp[0]] + list(dp[2:len(dp)])
    return headers, pkmn_directory

def writeJSON(filename, data):
	with open(filename, 'w') as f:
		json.dump(data, f)

def writeCSV(filename, dict, headers):
	with open(filename, 'w') as csvfile:
		spamwriter = csv.writer(csvfile, delimiter=',')
		spamwriter.writerow(headers)
		for key in dict:
			spamwriter.writerow([key] + dict[key])

def main(txt_data, csv_data, output_file):
	total_battles, headers2, smogon_dict = parser(txt_data)
	headers1, pokedex = load_csv(csv_data)
	final_dict = {}
	for key in pokedex:
		if key not in smogon_dict: print(key + " not found in smogon_dict")
		else: final_dict[key] = pokedex[key] + [smogon_dict[key][0]] + smogon_dict[key][2:]
	headers = [headers1[1]] + [headers1[0]] + headers1[2:] + [headers2[0]] + headers2[2:]
	print("Saving final_dict as .csv file " + output_file + "...")
	writeCSV(output_file, final_dict, headers)

if __name__=='__main__':
    if len(sys.argv)!=4:
        print('Usage: python data_loading.py txt_data csv_data output_file')
    else:
        main(sys.argv[1], sys.argv[2], sys.argv[3])
