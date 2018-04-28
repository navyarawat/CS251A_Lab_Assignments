#!/bin/bash
str=$(wc -w *)
for file in * ; do
	words=($(wc -w < "$file"))
	x=$(bc <<< "sqrt($words)")
	if [ $words -le 1 ]; then
		x=1
		continue
	elif [ $words -eq 2 ]; then
		echo 2
	elif [ $(($words%2)) -eq 0 ]; then
		x=1
		continue
	else
		i=3
		while [[ $i -le $x && $words%$i -ne 0 ]]; do
			i=$((i + 2))
		done
		if [ $i -gt $x ]; then
			echo $file
		fi
	fi
done

#wc -w * : TO PRINT WORD COUNT OF EVERY FILE IN PWD