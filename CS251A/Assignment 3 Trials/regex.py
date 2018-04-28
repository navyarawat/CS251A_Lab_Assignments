import re

string = raw_input()
regex1 = r"-?[0-9A-Z]+\.[0-9A-Z]+$"
regex2 = r"-?[0-9A-Z]+$"

if re.match(regex1,string) or re.match(regex2,string):
	print True
else:
	print False