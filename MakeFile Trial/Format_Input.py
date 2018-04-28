from sys import argv

def addcomma(line):
    numbers = line.split()
    newstr = ','.join(numbers)
    return newstr

filename = argv[1]
handle = open(filename)
contents = handle.read().split('\n')

mod3 = 0
newformat = []
newline = ''
for line in contents:
    if mod3 == 0:
        newline += line + ' '
        mod3 += 1
    elif mod3 == 1:
        newline += addcomma(line) + ' '
        mod3 += 1
    else:
        newline += line + ' '
        mod3 = 0
        newformat.append(newline)
        newline = ''

handle1 = open("Input.txt",'w+')
handle1.write( '\n'.join(newformat) )
handle1.close()
