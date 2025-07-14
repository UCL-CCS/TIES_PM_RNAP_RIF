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
for v in 0.00 0.05 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 0.95 1.00; do
    for ((i=rep_start; i<=rep_end; i++)); do
    cd $dwork/LAMBDA_$v/rep$i/simulation
      l1=`grep "PARTITION 1 SCALING:" sim1.alch | awk '{print $(NF-2)}'`
      l2=`grep "PARTITION 2 SCALING:" sim1.alch | awk '{print $(NF-2)}'`
      if [[ $l1 == 0 && $l2 == 0 ]]; then
        awk '($1=="TI:") {print 0.0}' sim*.alch > $dir_out/rep$i-vdw-$v.dat
      elif [[ $l1 == 0 ]]; then
        awk '($1=="TI:") {print -$13}' sim*.alch > $dir_out/rep$i-vdw-$v.dat
      elif [[ $l2 == 0 ]]; then
        awk '($1=="TI:") {print $7}' sim*.alch > $dir_out/rep$i-vdw-$v.dat
      else
        awk '($1=="TI:") {print $7-$13}' sim*.alch > $dir_out/rep$i-vdw-$v.dat
      fi
    done
done

