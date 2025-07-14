#!/bin/bash
## $1 and $2 are the first and second command line arguments which are starting and ending replica index.

if [ $# -ne 2 ];then
    echo "Incorrect no of arguments"
    exit
else
    rep_start=$1
    rep_end=$2
##    num_reps=$1
fi

dwork="$PWD"
mkdir -p $PWD/analysis
dir_out="$PWD/analysis"
for v in 0.0 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 1.0; do
    for ((i=rep_start; i<=rep_end; i++)); do
    cd $dwork/LAMBDA_$v/rep$i/simulation
      l1=`grep "PARTITION 1 SCALING:" sim1.alch | awk '{print $NF}'`
      l2=`grep "PARTITION 2 SCALING:" sim1.alch | awk '{print $NF}'`
      if [[ $l1 == 0 && $l2 == 0 ]]; then
        awk '($1=="TI:") {print 0.0}' sim*.alch > $dir_out/rep$i-ele-$v.dat
      elif [[ $l1 == 0 ]]; then
        awk '($1=="TI:") {print -$11}' sim*.alch > $dir_out/rep$i-ele-$v.dat
      elif [[ $l2 == 0 ]]; then
        awk '($1=="TI:") {print $5}' sim*.alch > $dir_out/rep$i-ele-$v.dat
      else
        awk '($1=="TI:") {print $5-$11}' sim*.alch > $dir_out/rep$i-ele-$v.dat
      fi
    done
done

