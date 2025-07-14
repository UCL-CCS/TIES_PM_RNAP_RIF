#!/bin/bash
#PBS -l xxx
#PBS -l xxx
#PBS -q xxx
#PBS -A xxx
#PBS -l walltime=xxx
#PBS -N xxx
#PBS -l filesystems=xxx

module swap PrgEnv-nvhpc/8.3.3 PrgEnv-gnu/8.3.3

export namd3="/path/namd3"

WRK=$PBS_O_WORKDIR

cd $WRK

for cf in eq0.conf eq1.conf sim1.conf; do
	n=0
	nd=0
	for s in com prot; do
		for lam in 0.0 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 1.0; do
			for i in `seq 1 5`; do
				n=$((n+1))
				node_i=$(awk -v n=$n '(NR==int((n+3)/4))' $PBS_NODEFILE)
				cd $s/replica-confs
				mpiexec -host $node_i -n 1 --ppn 1 --depth=8 --cpu-bind depth $namd3 +devices $nd --tclmain $cf $lam $i &
				nd=$((nd+1))
				if test $nd -gt 3; then
					nd=0
				fi
				cd $WRK
			done
		done
	done
	wait
done


