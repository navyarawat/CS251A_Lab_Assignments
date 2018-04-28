from sys import argv

def parse(line):
    newline = line.split(',')
    n = len(newline)
    for i in xrange(n):
        newline[i] = newline[i].strip()
    return ','.join(newline)

filename = argv[1]
handle = open(filename)
content = handle.read().split('\n')
output = []
for line in content:
    output.append(parse(line))

handle1 = open("Lines.txt",'w+')
handle1.write( '\n'.join(output) )
handle1.close()
