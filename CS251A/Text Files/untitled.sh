#!/bin/bash

for file in * ; do
	words=($(wc -w < "$file"))
	echo $words
done

#wc -w * : TO PRINT WORD COUNT OF EVERY FILE IN PWD