#!/bin/bash

WRK=`pwd`
cd $WRK/model_sub  # where output files of the models are

lj=0
for li in `ls -1`
do
        list1[lj]=$li
        lj=`expr $lj + 1`
done

lenl=${#list1[@]}
len2=`expr $lenl - 1`

for i in `seq 0 $len2`;
do
	for j in com prot;
	do
		cd $WRK/model_sub/${list1[$i]}/$j
		echo "${list1[$i]}/$j" >> $WRK/results.txt
		../../../../analysis_scripts/vdw.com 1 5
		../../../../analysis_scripts/ele.com 1 5
		cd analysis/
	        ../../../../../analysis_scripts/ties_avg.sh 5 0 >> $WRK/results.txt
		cd ../../
	done
done







