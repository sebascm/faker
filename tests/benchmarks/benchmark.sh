!/usr/bin/env bash

echo "Benchmark report"
echo "--------------------" 
i="0"
total=0
while [ $i -lt 5 ]
do
    start=`date +%s`
    python setup.py test
    end=`date +%s`
    runtime=$((end-start))
    total=$((total+runtime))
    i=$[$i+1]
    echo " - Time spent job $i: $runtime second(s)"
done

mean=$((total/5))
echo "--------------------"
echo "Total time spent ($i jobs): $total second(s)"
echo "Time spent per job: $mean second(s)"
echo "--------------------"