from sys import argv

threadData = argv[1:]

i = 1
for threadFile in threadData:
    handle = open(threadFile)
    data = handle.read().split('\n')
    averages = {}
    variances = {}
    count = {}
    outputlines = []
    for line in data:
        temp = line.split()
        param = int(temp[0])
        time = int(temp[1])
        if param in averages:
            averages[param] += time
            variances[param] += time**2
            count[param] += 1
        else:
            averages[param] = time
            variances[param] = time**2
            count[param] = 1
    for key in averages:
        averages[key] = (averages[key]*1.0)/count[key]
        variances[key] = (variances[key]*1.0)/count[key] - averages[key]**2
        string = str(key) + " " + str(averages[key]) + " " + str(variances[key])
        outputlines.append(string)
    filename = "AverageThread" + str(i) + ".txt"
    outputHandle = open(filename,'w+')
    outputHandle.write('\n'.join(outputlines))
    handle.close()
    outputHandle.close()
    i *= 2
