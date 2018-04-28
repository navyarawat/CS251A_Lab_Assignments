#!/bin/bash
read filename
content=($(cat $filename))
count=0
for i in ${content[@]}; do
	if [[ $i =~ [0123456789]+ ]]; then
		if [[ $i =~ [.][0-9]+.*$ || $i =~ ^-{2,} ]]; then
			continue
		fi
		echo $i
		count=$((count+1))
	fi
done
echo $count