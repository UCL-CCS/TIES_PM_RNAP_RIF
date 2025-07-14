#!/bin/bash

xbox=`grep "O   WAT" complex.pdb | cut -c31-54 | awk '{print $1}' | awk -f /lus/grand/projects/CompBioAffin/swan/template/max-min.awk | awk '{print $NF}'`
ybox=`grep "O   WAT" complex.pdb | cut -c31-54 | awk '{print $2}' | awk -f /lus/grand/projects/CompBioAffin/swan/template/max-min.awk | awk '{print $NF}'`
zbox=`grep "O   WAT" complex.pdb | cut -c31-54 | awk '{print $3}' | awk -f /lus/grand/projects/CompBioAffin/swan/template/max-min.awk | awk '{print $NF}'`
x0=`grep "O   WAT" complex.pdb | cut -c31-54 | awk '{print $1}' | awk -f /lus/grand/projects/CompBioAffin/swan/template/max-min.awk | awk '{print ($1+$2)/2}'`
y0=`grep "O   WAT" complex.pdb | cut -c31-54 | awk '{print $2}' | awk -f /lus/grand/projects/CompBioAffin/swan/template/max-min.awk | awk '{print ($1+$2)/2}'`
z0=`grep "O   WAT" complex.pdb | cut -c31-54 | awk '{print $3}' | awk -f /lus/grand/projects/CompBioAffin/swan/template/max-min.awk | awk '{print ($1+$2)/2}'`

printf "cellBasisVector1\t"; printf "%6.3f " $xbox; printf " 0.000  0.000\\\\\n"
printf "cellBasisVector2\t"; printf " 0.000 "; printf "%6.3f " $ybox; printf " 0.000\\\\\n"
printf "cellBasisVector3\t"; printf " 0.000  0.000 "; printf "%6.3f\\\\\n" $zbox
printf "cellOrigin\t\t";printf "%6.3f %6.3f %6.3f\n" $x0 $y0 $z0
