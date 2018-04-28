from sys import argv

filename = argv[1]
handle = open(filename)
lines = handle.read().split('\n')
n = len(lines) #no of lines

data = [[] for i in xrange(17)]


threads = 0
elements = ''
for line in lines:
    if len(line.split()) == 2:
        temp = line.split()
        elements = temp[0]
        threads = int(temp[1])
    elif len(line.split()) == 5:
        coordinate = elements + " " + line.split()[3]
        data[threads].append(coordinate)

handle1 = open("Thread1.txt",'w+')
handle1.write( '\n'.join(data[1]) )
handle1.close()

handle2 = open("Thread2.txt",'w+')
handle2.write( '\n'.join(data[2]) )
handle2.close()

handle4 = open("Thread4.txt",'w+')
handle4.write( '\n'.join(data[4]) )
handle4.close()

handle8 = open("Thread8.txt",'w+')
handle8.write( '\n'.join(data[8]) )
handle8.close()

handle16 = open("Thread16.txt",'w+')
handle16.write( '\n'.join(data[16]) )
handle16.close()
