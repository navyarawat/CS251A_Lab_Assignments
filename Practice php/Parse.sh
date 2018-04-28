if [[ -e "$1" ]]; then
    continue
else
    echo "file does not exist"
    exit -1
fi
IFS=$'\n' read -d '' -r -a lines < $1
touch answers.txt
> answers.txt
comma=","
for element in "${lines[@]}"
do
    IFS=',' read -r -a array <<< "$element"
    string=""
    start=1
    for num in "${array[@]}"
    do
        num1=$(echo $num | xargs)
        if [[ $start = 1 ]]; then
            string=$string$num1
            start=0
        else
            string=$string$comma$num1
        fi
    done
    echo $string
    echo $string >> answers.txt
done
