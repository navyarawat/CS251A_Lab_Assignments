params=($(cat $1))
thread=($(cat $2))
opfile="op.txt"

touch $opfile

for noOfParam in ${params[@]}; do
    for noOfThreads in ${thread[@]}; do
        echo $noOfParam $noOfThreads >> $opfile
        for (( i=0; i<100; i++)); do
            ./app.ex1 $noOfParam $noOfThreads >> $opfile
        done
    done
done
