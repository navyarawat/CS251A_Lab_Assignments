#!/bin/bash

digits=(zero one two three four five six seven eight nine)
teens=(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
tens=(noword ten twenty thirty forty fifty sixty seventy eighty ninety)
words=(hundred thousand lakh crore)

function twodigit {
	a=$1
	b=$2
	flag=$3
	if [[ $a = 0 && $b = 0 ]]; then
		if [[ flag -eq 1 ]]; then
			echo -n zero
		fi
		return
	elif [[ $a = 0 ]]; then
		echo -n ${digits[$b]} ''
	elif [[ $a = 1 ]]; then
		echo -n ${teens[$b]} ''
		return
	elif [[ $b = 0 ]]; then
		echo -n ${tens[$a]} ''
	else
		echo -n ${tens[$a]} ${digits[$b]} ''
	fi
}

function threedigit {
	a=$1
	b=$2
	c=$3
	flag=$4
	if [[ $a = 0 ]]; then
		twodigit $b $c $flag
	else
		echo -n ${digits[$a]} ${words[0]} ''
		twodigit $b $c 0
	fi
}

function fourdigit {
	a=$1
	b=$2
	c=$3
	d=$4
	flag=$5
	if [[ $a = 0 ]]; then
		threedigit $b $c $d $flag
	else
		echo -n ${digits[$a]} ${words[1]} ''
		threedigit $b $c $d 0
	fi
}

echo Enter a number
read number

if [[ $number =~ ^[0-9]+$ ]]; then
	number=$(echo $number| sed 's/^0*//')
	n=${#number}
	if [[ n -gt 11 ]]; then
		echo invalid input
		exit
	fi
	num=$((11-n))
	zeros=''
	zero='0'
	while [[ num -gt 0 ]]; do
		zeros=$zeros$zero
		num=$((num-1))
	done
	number=$zeros$number

	fourdigit ${number:0:1} ${number:1:1} ${number:2:1} ${number:3:1} 0
	if [[ ${number:0:1} != 0 || ${number:1:1} != 0 || ${number:2:1} != 0 || ${number:3:1} != 0 ]]; then
		echo -n ${words[3]} ''
	fi
	twodigit ${number:4:1} ${number:5:1} 0
	if [[ ${number:4:1} != 0 || ${number:5:1} != 0 ]]; then
		echo -n ${words[2]} ''
	fi
	twodigit ${number:6:1} ${number:7:1} 0
	if [[ ${number:6:1} != 0 || ${number:7:1} != 0 ]]; then
		echo -n ${words[1]} ''
	fi
	threedigit ${number:8:1} ${number:9:1} ${number:10:1} 1
	echo 
else
	echo invalid input
fi