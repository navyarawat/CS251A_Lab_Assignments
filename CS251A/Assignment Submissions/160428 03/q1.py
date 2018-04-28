from sys import argv
import re

def regex_match(string):
	regex1 = r"-?[0-9A-Z]*\.[0-9A-Z]+$"
	regex2 = r"-?[0-9A-Z]+\.?$"

	if re.match(regex1,string) or re.match(regex2,string):
		return True
	else:
		return False
#basic format match using regex

def check_base(b):
	regex = r"[0-9]+$"
	if re.match(regex,b) == False:
		return False
	dgts = list(b)
	dgts.reverse()
	base = 0
	pwr = 1
	for dgt in dgts:
		base += (ord(dgt)-ord('0'))*pwr
		pwr *= 10
	if base<2 or base>36:
		return False
	return base
#checks if the base is valid or not

Digits=['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G',
		'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']

script,num,b = argv					#take input and convert it into relevant format
if check_base(b) == False:
	print "Invalid Input"
	exit()
else:
	b = check_base(b)
number = list(num)
n = len(number)

if regex_match(num) == False:		#check the format of the input string
	print "Invalid Input"
	exit()

flag = 0							#check if the number is negative or not
if number[0] == '-':
	flag = 1
	number.pop(0) #remove the negative sign
	n -= 1		  #decreasing it to accomodate the removal of '-'

digits = Digits[:b]					#check if the digits of the input are in range.
for i in number:
	if i in digits or i == '.':
		continue
	else:
		print "Invalid Input"
		exit()

idx = 0
while idx<n and number[idx]!='.':	#idx will be the index of the '.' if its there,...
	idx += 1						#...otherwise it signifies end of list

answer = 0
leftidx = idx-1
rghtidx = idx+1
power = 1
while leftidx >- 1:
	answer += digits.index(number[leftidx])*power
	power *= b
	leftidx -= 1
power = 1.0/b
while rghtidx < n:
	answer += digits.index(number[rghtidx])*power
	power /= b
	rghtidx += 1

if flag ==1 and answer != int(answer):
	print '-%.6f' %answer
elif flag== 1 and answer == int(answer):
	print '-%d' %answer
elif answer != int(answer):
	print '%.6f' %answer
else:
	print int(answer)				#still using int() to print 2.0 as 2