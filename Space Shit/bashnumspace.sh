filename=$1
# touch outputbash.txt
# > outputbash.txt (Empties the file)
flag=1
if [ -e $filename ]
then
    flag=0
else
    echo "Wrong file name"
    exit -1
fi
#contents=$(cat "$filename")
#echo $contents

# xargs is used for stripping
#concatanate $string1$string2
IFS=$'\n' read -d '' -r -a lines < $1
# echo ${line[@]}
# for each in "${line[@]}"
# do
#   echo "$each"
# done
# printf '%s\n' "${line[@]}"
for line in "${lines[@]}"
do
    echo $line | tr -d ' ' >> outputbash.txt # | tee oitputbash.txt if we wnat to see on console too
done
