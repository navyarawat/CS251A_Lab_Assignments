from sys import argv

datafiles = argv[1:]
basetime = {}
input = []
noOfParams = 0
for file in datafiles:
    handle = open(file)
    lines = handle.read().split('\n')
    if file == 'AverageThread1.txt':
        for line in lines:
            temp = line.split()
            basetime[temp[0]] = temp[1]
            noOfParams += 1
    for line in lines:
        input.append(line)

output = []
i = 0
while i < noOfParams:
    j = i
    string = ''
    while j < len(input):
        temp = input[j].split()
        param = temp[0]
        threads = str(2**((j-i)/noOfParams))
        speedup = str(float(basetime[param])/float(temp[1]))
        variance = temp[2]
        string += param + " " + threads + " " + speedup + " " + variance + " "
        j += noOfParams
    output.append(string)
    i += 1

outputHandle = open("Speedup_Data.txt",'w+')
outputHandle.write('\n'.join(output))
