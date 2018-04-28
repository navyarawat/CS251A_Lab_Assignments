#!/bin/bash

read filename
content=($(cat $filename))
count=0
for i in ${content[@]}; do
	if [[ $i =~ .+[\.\\?\\!]$ ]]; then
		echo $i
		count=$((count+1))
	fi
done
echo $count