import json

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

def main():
	writeJSON("gen7anythinggoes-1760.json", parser("gen7anythinggoes-1760.txt"))

main()