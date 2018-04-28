IFS=$'\n' read -d '' -r -a lines < $1
executable=$2
touch answers.txt
> answers.txt
for element in "${lines[@]}"
do
    ./$executable $element >> "answers.txt"
done
