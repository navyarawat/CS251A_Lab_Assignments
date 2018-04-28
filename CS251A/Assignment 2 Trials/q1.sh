#!/bin/bash

if [ ! -d "$1" ]; then
	exit -1
fi

directory="$1"
count1=0
count2=0

while read file; do	
	if [[ "$file" =~ .*\.c ]]; then
		answers=($(./q1.awk "$file"))
		count1=$((answers[0]+count1))
		count2=$((answers[1]+count2))
	fi
done< <(find "$directory" -type f)

echo "$count1 $count2"