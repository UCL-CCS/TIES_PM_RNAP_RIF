#!/bin/bash
# $1 is the first command line argument which is the number of replicas.
# $2 is the line number from where to start reading the rep$i-ele/vdw-$v.dat; that is the first ($2-1) lines will be ignored (useful for ignoring equilibration) 
if [ $# -ne 2 ];then
    echo "Incorrect no of arguments"
    exit
else
    num_reps=$1
    equil=$2
fi

rm -f dg-ele-lmbw.dat dg-vdw-lmbw.dat dg-tot-lmbw.dat dg-final.dat dg-tot-scaled-lmbw.dat dg-tot-scaled-boot-lmbw.dat lambda_list.dat dlambda_list.dat

SCRIPTS_PATH=/net/bac/shunzhou/trypsin/analysis_scripts
dir=$SCRIPTS_PATH
lscale="0.45"
for v in 0.0 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 1.0;
do
	rm -f ele-$v-repw.dat vdw-$v-repw.dat tot-$v-repw.dat tot-scaled-$v-repw.dat dg-tot-scaled-boot-$v.dat
	echo $v >> lambda_list.dat
	for ((i=1; i<=num_reps; i++)); 
	do
		if [[ -s rep$i-ele-$v.dat && -s rep$i-vdw-$v.dat ]]; then
			tail -n +$equil $PWD/rep$i-ele-$v.dat | awk -f $dir/ave.awk >> $PWD/ele-$v-repw.dat
			tail -n +$equil $PWD/rep$i-vdw-$v.dat | awk -f $dir/ave.awk >> $PWD/vdw-$v-repw.dat
			paste $PWD/rep$i-ele-$v.dat $PWD/rep$i-vdw-$v.dat | tail -n +$equil | awk '{print $1+$2}' | awk -f $dir/ave.awk >> $PWD/tot-$v-repw.dat
			paste $PWD/rep$i-ele-$v.dat $PWD/rep$i-vdw-$v.dat | tail -n +$equil | awk -v lscale=$lscale '{print ($1/(1-lscale) + $2)}' | awk -f $dir/ave.awk >> $PWD/tot-scaled-$v-repw.dat
		else
			echo "Files for rep-$i lambda-$v are empty. Ignoring them."
		fi	
	done
	Rscript $SCRIPTS_PATH/ties_bootstrap.R $v $num_reps
	awk '{print $1}' $PWD/dg-tot-scaled-boot-$v.dat | awk -f $dir/ave.awk | awk -v l=$v '{print l"\t"$0}' >> $PWD/dg-tot-scaled-boot-lmbw.dat
	awk '{print $1}' $PWD/ele-$v-repw.dat | awk -f $dir/ave.awk | awk -v l=$v '{print l"\t"$0}' >> $PWD/dg-ele-lmbw.dat
	awk '{print $1}' $PWD/vdw-$v-repw.dat | awk -f $dir/ave.awk | awk -v l=$v '{print l"\t"$0}' >> $PWD/dg-vdw-lmbw.dat
	awk '{print $1}' $PWD/tot-$v-repw.dat | awk -f $dir/ave.awk | awk -v l=$v '{print l"\t"$0}' >> $PWD/dg-tot-lmbw.dat
	awk '{print $1}' $PWD/tot-scaled-$v-repw.dat | awk -f $dir/ave.awk | awk -v l=$v '{print l"\t"$0}' >> $PWD/dg-tot-scaled-lmbw.dat
done

### create a list of delta lambda values for integration
python3 $SCRIPTS_PATH/ties_dlambda.py $lscale

if [[ -s dlambda_list.dat ]]; then
	IFS=$'\n'
	dlambda=(`cat dlambda_list.dat`)
#	echo ${dlambda[*]}
#	len_dlambda=(${#dlambda[@]})
else
	echo "ERROR: File dlambda_list.dat (containing delta lambda values for integration) does not exist or is empty."
	exit
fi

rm -f final_dg_alch.dat
num=$(awk 'END {print NR}' dg-tot-scaled-boot-lmbw.dat)
intgr="0.00"
sd="0.00"
((num--))
i=0
while [ $i -le $num ];
do
	j=$((i+1))
	dg=$(sed -n "$j"p dg-tot-scaled-boot-lmbw.dat | awk '{print $2}')
	dsig=$(sed -n "$j"p dg-tot-scaled-boot-lmbw.dat | awk '{print $3*$3}')
	dl=${dlambda[$i]}
	intgr=$(awk -v intgr=$intgr -v dg=$dg -v dl=$dl 'BEGIN { print intgr+(dg*dl)}')
	sd=$(awk -v sd=$sd -v dsig=$dsig -v dl=$dl 'BEGIN { print sd+(dsig*dl*dl)}')
	((i++))
done
boot_sd=$(awk -v sd=$sd 'BEGIN {print sqrt(sd)}')
echo "Integral is $intgr with bootstrapped standard error of the mean $boot_sd"
echo "$intgr	$boot_sd ## bootstrapped data set" >> final_dg_alch.dat

num=$(awk 'END {print NR}' dg-tot-scaled-lmbw.dat)
intgr="0.00"
sd="0.00"
((num--))
i=0
while [ $i -le $num ];
do
	j=$((i+1))
	dg=$(sed -n "$j"p dg-tot-scaled-lmbw.dat | awk '{print $2}')
	dsig=$(sed -n "$j"p dg-tot-scaled-lmbw.dat | awk '{print $3*$3}')
	dl=${dlambda[$i]}
	intgr=$(awk -v intgr=$intgr -v dg=$dg -v dl=$dl 'BEGIN { print intgr+(dg*dl)}')
	sd=$(awk -v sd=$sd -v dsig=$dsig -v dl=$dl 'BEGIN { print sd+(dsig*dl*dl)}')
	((i++))
done
sd=$(awk -v sd=$sd 'BEGIN {print sqrt(sd)}')
SE=$(awk -v num_reps=$num_reps -v sd=$sd 'BEGIN { print sd/sqrt(num_reps)}')
echo "Integral is $intgr with standard deviation $sd. The standard error is $SE"
echo "$intgr	$sd  ## original data set" >> final_dg_alch.dat
echo "$intgr	$SE  ## SE with original data set" >> final_dg_alch.dat
#rm dg-tot-scaled*
