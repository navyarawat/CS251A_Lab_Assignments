from sys import argv
import re
script, file = argv

with open(file, 'rb') as inp_file, open('output', 'w') as out_file:
    for line in inp_file:
        arr = line.split()
        out = []
        for i in arr:
            out.append(i.strip())
        print >> out_file, ''.join(out)
