#Question 1
grep -rl text .		|	#-r means recursive, -l means only filename, . means the current directory.

#Question 2
mkdir -p A/B/C		|	#makes each of the three directories
mkdir -pv D/E/F		|	#makes the directories and displays what all is being executed #ok it does not
rm -r A 			|	#removes a non empty directory
rm -r A D 			|	# both the directories will be removed

#Question 3
wc filename.txt		|	#prints no. of lines, words, characters, and the file name
wc -l filename.txt	|	#prints just the number of lines and the file name
wc -lw filename.txt	|	#prints the no. of lines, words and the file name

#Question 5
ls *Naman*			|	#here, * refers to any character any number of times. 
					|	#Searches in current directory
find . -name *Naman*|	#here, . tells to search the current directory and its subdirectories,
					|	#-name tells to find file name,
					|	#and *Naman* tells to find files containing Naman in their file name.

#Question 6
tar -cvf Dir.tar ./Dir| #c for create normally, v to show the file progress, f to indicate that a filename
					|	#follows.
tar -cfz Dir.tar.gz ./Dir| #z to indicate compression, .gz is the extension for compression type.
tar -cfj Dir.tar.bz2 ./Dir| #j to indicate compression, .bz2 is the extension for compression type.
					|	# j compresses more than z. Also, bz2 takes more time to (de)compress.
du -a .				|	# du checks file size of stuff. -a tells it to check size of everything in the dir.

#Question 8
head -5 flname.txt	|	#simple af

#Question 9
tail -5 flname.txt	|	#yet again