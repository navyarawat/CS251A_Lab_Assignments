#!/bin/bash
function count_int {
	content1=($(cat $1))
	count1=0
	for i in ${content1[@]}; do
		if [[ $i =~ [0123456789]+ ]]; then
			if [[ $i =~ [.][0-9]+.*$ || $i =~ ^-{2,} ]]; then
				continue
			fi
			count1=$((count1+1))
		fi
	done
	echo $count1
}

function count_sent {
	content2=($(cat $1))
	count2=0
	for i in ${content2[@]}; do
		if [[ $i =~ .+[\.\\?\\!]$ ]]; then
			count=$((count+1))
		fi
	done
	echo $count2
}

function count_int_dir {
	files=($1/'*')
	count_1=0
	for file in ${files[@]}; do
		if [[ -f $file ]]; then
			content=($(cat '$file'))
			count_1=$(count_int '$file')
		elif [[ -d $file ]]; then
			content=$(cat '$file'))
			x=$(count_sent_int '$file')
			count_1=$((count_1+x))
		fi
	done
	echo $count_1
}
function count_sent_dir {
	files=($1/'*')
	count_2=0
	for file in ${files[@]}; do
		if [[ -f $file ]]; then
			content=$(cat '$file'))
			x=$(count_sent '$file')
			count_2=$((count_2+x))
		elif [[ -d $file ]]; then
			content=$(cat '$file'))
			x=$(count_sent_dir '$file')
			count_2=$((count_2+x))
		fi
	done
	echo $count_2
}

function foo {
	files=($1/'*')
	c_1=0
	c_2=0
	for file in ${files[@]}; do
		if [[ -f $file ]]; then
			content=$(cat '$file'))
			x=$(count_sent '$file')
			count_2=$((count_2+x))
		elif [[ -d $file ]]; then
			content=$(cat '$file'))
			x=$(count_sent_dir '$file')
			count_2=$((count_2+x))
		fi
	done
}
