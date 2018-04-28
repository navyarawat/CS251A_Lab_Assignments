xmlfile=$1
if [[ $xmlfile =~ .+\.xml$ ]]; then
	flag=0
	cmnd=''
	dirflag=0
	fileflag=0
	nameflag=0
	sizeflag=0
	word=''
	name=''
	size=0
	while IFS= read -r -n1 char; do
		if [[ $char = '<' ]]; then
			flag=1
		elif [[ $flag = 1 ]]; then
			if [[ $char = '>' ]]; then
				flag=0
				if [[ $cmnd = 'dir' ]]; then
					dirflag=1
				elif [[ $cmnd = 'file' ]]; then
					fileflag=1
				elif [[ $cmnd = 'name' ]]; then
					nameflag=1
				elif [[ $cmnd = 'size' ]]; then
					sizeflag=1
				elif [[ $cmnd = '/dir' ]]; then
					dirflag=0
					cd ..
				elif [[ $cmnd = '/file' ]]; then
					fileflag=0
					dd if=/dev/zero of="$name" bs=$size count=1
					name=''
					size=0
				elif [[ $cmnd = '/name' ]]; then
					nameflag=0
					name=`printf "$word"| xargs`
					word=''
					if [[ $fileflag = 0 ]]; then
						mkdir "$name"
						cd "$name"
						name=''
					fi
				elif [[ $cmnd = '/size' ]]; then
					sizeflag=0
					size="$word"
					word=''
				fi
				cmnd=''
				continue
			fi
			cmnd="$cmnd""$char"
		elif [[ $flag = 0 ]]; then
			word="$word""$char"
			if [[ $word = ' ' || $word = '	' || $word = '\n' ]]; then
				word=''
			fi
		fi

	done < "$xmlfile"
else
	echo Enter correct "file name"
fi