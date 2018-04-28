#!/bin/bash
echo Enter a number
digits=('zero' 'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine')
read number
if [[ $number =~ ^[0-9]+$ ]]; then
	n=${#number}
	for (( i = 0; i < ${#number}; ++i )); do
    	echo ${digits[${number:$i:1}]}
	done
else
	echo Enter a correct number
fi