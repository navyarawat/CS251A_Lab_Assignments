#!/bin/bash
read dirr
files=($dirr/'*')
for file in ${files[@]}; do
	if [[ -d $file ]]; then
		echo $file is a directory
	elif [[ -f $file ]]; then
		echo $file is a 'file'
		content=($(cat $file))
		count=0
		for i in ${content[@]}; do
			if [[ $i =~ [0123456789]+ ]]; then
				if [[ $i =~ [.][0-9]+.*$ || $i =~ ^-{2,} ]]; then
					continue
				fi
				count=$((count+1))
			fi
		done
		echo There are $count integers 'in' $file

		count=0
		for i in ${content[@]}; do
			if [[ $i =~ .+[\.\\?\\!]$ ]]; then
				count=$((count+1))
			fi
		done
		echo There are $count sentences 'in' $file
	fi
done