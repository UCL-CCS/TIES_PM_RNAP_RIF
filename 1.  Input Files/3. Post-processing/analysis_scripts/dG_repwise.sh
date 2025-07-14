#!/bin/bash
# $1 is the first command line argument which is the replica ID.
if [ $# -ne 1 ];then
    echo "Incorrect no of arguments"
    exit
else
    i=$1
fi

rm -f dg-tot-scaled-lmbw.dat lambda_list.dat dlambda_list.dat

dir=$SCRIPTS_PATH
lscale="0.45"
for v in 0.00 0.05 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 0.95 1.00;
do
	echo $v >> lambda_list.dat
	if [[ -s rep$i-ele-$v.dat && -s rep$i-vdw-$v.dat ]]; then
		paste $PWD/rep$i-ele-$v.dat $PWD/rep$i-vdw-$v.dat | awk -v lscale=$lscale '{print ($1/(1-lscale) + $2)}' | awk -f $dir/ave.awk | awk -v l=$v '{print l"\t"$1}' >> $PWD/dg-tot-scaled-lmbw.dat
	else
		echo "Files for rep-$i lambda-$v are empty. Ignoring them."
	fi	
done

### create a list of delta lambda values for integration
python $SCRIPTS_PATH/ties_dlambda.py $lscale

if [[ -s dlambda_list.dat ]]; then
	IFS=$'\n'
	dlambda=(`cat dlambda_list.dat`)
#	echo ${dlambda[*]}
#	len_dlambda=(${#dlambda[@]})
else
	echo "ERROR: File dlambda_list.dat (containing delta lambda values for integration) does not exist or is empty."
	exit
fi

num=$(awk 'END {print NR}' dg-tot-scaled-lmbw.dat)
intgr="0.00"
((num--))
i=0
while [ $i -le $num ];
do
	j=$((i+1))
	dg=$(sed -n "$j"p dg-tot-scaled-lmbw.dat | awk '{print $2}')
	dl=${dlambda[$i]}
	intgr=$(awk -v intgr=$intgr -v dg=$dg -v dl=$dl 'BEGIN { print intgr+(dg*dl)}')
	((i++))
done
echo "rep$1	$intgr" >> final_dg_alch.dat
