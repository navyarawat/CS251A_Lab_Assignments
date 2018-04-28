from sys import argv
from sys import stdout
import re

def spacednum(num, length):
	l = len(list(str(num)))
	string = ' '*(length-l)
	string += str(num)
	return string

array = argv[1]
regex = r"\[[0-9,-]+\]$"
regint = r"-?[0-9]+$"
if not re.match(regex,array):
	print "invalid input"
	exit()
arr = list(array)
arr = arr[1:-1]
array = ''.join(arr)
arr = array.split(',')
numbers = []
for i in arr:
	if not re.match(regint,i):
		print "invalid input"
		exit()
	numbers.append(int(i))
numbers.sort()
print numbers
x = max(len(list(str(numbers[-1]))),len(list(str(numbers[0]))))
spaces = ' '*x
n = len(numbers)
numleft = n
idx = 0
previdx = 0

while numleft > 0:
	start = idx
	while idx < n and type(numbers[idx]) == int:
		idx += 1
	end = idx - 1
	if end < start:
		for i in xrange(idx-previdx+1):
			stdout.write(spaces)
		previdx = idx + 1
		idx += 1
		continue
	mid = (start + end)/2
	for i in xrange(mid-previdx):
		stdout.write(spaces)
	stdout.write(spacednum(numbers[mid],x))
	numbers[mid] = True
	previdx = mid + 1
	numleft -= 1
	if idx == n:
		idx = 0
		previdx = 0
		stdout.write('\n')
	else:
		idx += 1