## $1 and $2 are the command line arguments which are the three letter amino acid codes such that $1 is mutated to $2.
## $3 is the third command line argument, which is the name of the hybrid residue.
## $4 is the fourth command line argument, which is the force field name. For eg. ff14SB, ff99SBildn, etc.
#!/bin/bash

#amino_lib=$(grep "loadOff" $AMBERHOME/dat/leap/cmd/leaprc.$4 | grep amino | grep -v ct | grep -v nt | awk '{print $2}')
amino_lib=$(grep "loadOff" $AMBERHOME/dat/leap/cmd/leaprc.protein.$4 | grep amino | grep -v ct | grep -v nt | awk '{print $2}')
sed -n "/entry\.$1\.unit\.atoms/,/\<unit\.atoms\>/p" $AMBERHOME/dat/leap/lib/$amino_lib | sed '$ d' | less > $1.lib
sed -n "/entry\.$2\.unit\.atoms/,/\<unit\.atoms\>/p" $AMBERHOME/dat/leap/lib/$amino_lib | sed '$ d' | less > $2.lib

sed -n "/unit\.atoms/,/unit\.atomspertinfo/p" $1.lib | sed '$ d' > temp1.dat
num_atoms1=$(tail -1 temp1.dat | awk '{print $6}')
sed -n "/unit\.atoms/,/unit\.atomspertinfo/p" $2.lib | sed '1d' | sed '$ d' > temp2.dat

rm -f tmp1 hybrid-residue-namelist-res1.dat
i=0
while read line;
do
		((i++));
			name=$(sed -n "$i"p temp1.dat | awk '{print $1}' | cut -d "\"" -f 2)
				echo "$name" >> tmp1
			done < temp1.dat
			sed -i '1 d' tmp1
			mv tmp1 hybrid-residue-namelist-res1.dat

			rm -f tmp hybrid-residue-namelist.dat
			i=0
			while read line; 
			do
					((i++));
						name1=$(sed -n "$i"p temp2.dat | awk '{print $1}' | cut -d "\"" -f 2 | cut -c1)
							name2=$(echo \""$name1"T"$i"\")
								name3=$(sed -n "$i"p temp2.dat | awk '{print $1}' | cut -d "\"" -f 2)
									name4=$(echo "$name1"T"$i")
										echo "$name3	$name4" >> hybrid-residue-namelist.dat
											sed -n "$i"p temp2.dat | awk -v name=$name2 '{$1=name; print " "$0}' >> tmp
											echo "1st"
										done < temp2.dat
										mv tmp temp2.dat
										awk '{print $6}' temp2.dat > orig-num2.dat

										num_atoms2=$num_atoms1
										rm -f new-num2.dat
										i=0
										while read line;
										do
												((i++))
													((num_atoms2++))
														echo $num_atoms2 >> new-num2.dat
															sed -n "$i"p temp2.dat | awk -v num=$num_atoms2 '{$6=num; print " "$0}' >> tmp
															echo "2nd"
														done < temp2.dat
														mv tmp temp2.dat
														tot_num_atoms=$num_atoms2
														paste orig-num2.dat new-num2.dat > hybrid-residue-numlist.dat
														rm orig-num2.dat new-num2.dat

														sed -n "/unit\.atomspertinfo/,/unit\.boundbox/p" $1.lib | sed '$ d' > temp3.dat
														sed -n "/unit\.atomspertinfo/,/unit\.boundbox/p" $2.lib | sed '1d' | sed '$ d' > temp4.dat

														i=0
														while read line;
														do
																((i++))
																	name1=$(sed -n "$i"p temp4.dat | awk '{print $1}' | cut -d "\"" -f 2 | cut -c1)
																		name2=$(echo \""$name1"T"$i"\")
																			sed -n "$i"p temp4.dat | awk -v name=$name2 '{$1=name; print " "$0}' >> tmp
																			echo "3rd"
																		done < temp4.dat
																		mv tmp temp4.dat

																		sed -n "/unit\.boundbox/,/unit\.connectivity/p" $1.lib | sed '$ d' > temp5.dat
																		sed -n "/unit\.connectivity/,/unit\.hierarchy/p" $1.lib | sed '$ d' > temp6.dat
																		sed -n "/unit\.connectivity/,/unit\.hierarchy/p" $2.lib | sed '1d' | sed '$ d' > temp7.dat

																		i=0
																		while read line
																		do
																				((i++))
																					n=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																						awk -v num=$n '($1==num || $2==num) {$3=0; print}' temp7.dat >> tmp
																						echo "4th"
																					done < hybrid-residue-numlist.dat
																					sort -n tmp | uniq > temp7.dat
																					rm tmp 

																					##############################################################################
																					cp temp7.dat tmp1
																					i=0
																					while read line
																					do
																							((i++))
																								n=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																									awk -v num=$n '($1!=num) {print}' tmp1 > tmp2
																									echo "5th"
																										mv tmp2 tmp1
																									done < hybrid-residue-numlist.dat

																									if [[ -s tmp1 ]]; then
																											rm -f list-temp1.dat
																												sed -n "/unit\.atoms/,/unit\.atomspertinfo/p" $2.lib | sed '1d' | sed '$ d' > tmp
																													i=0
																														while read line
																																do
																																			((i++))
																																					num=$(sed -n "$i"p tmp1 | awk '{print $1}')
																																							name=$(awk -v num=$num '($6 == num){print $1}' tmp | cut -d "\"" -f 2)
																																							echo "6th"
																																							#	        name=$(grep -w "$num" tmp | awk '{print $1}' | cut -d "\"" -f 2)
																																									sed -i "s/\<$num\>/$name/" temp7.dat
																																											num=$(grep -w "$name" temp1.dat | awk '{print $6}')
																																													echo "$name	$num" >> list-temp1.dat
																																														done < tmp1
																																															rm tmp
																									fi
																									rm tmp1

																									cp temp7.dat tmp1
																									i=0
																									while read line
																									do
																											((i++))
																												n=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																													awk -v num=$n '($2!=num) {print}' tmp1 > tmp2
																													echo "7th"
																														mv tmp2 tmp1
																													done < hybrid-residue-numlist.dat

																													if [[ -s tmp1 ]]; then
																															rm -f list-temp2.dat
																																sed -n "/unit\.atoms/,/unit\.atomspertinfo/p" $2.lib | sed '1d' | sed '$ d' > tmp
																																	i=0
																																		while read line
																																				do
																																							((i++))
																																									num=$(sed -n "$i"p tmp1 | awk '{print $2}')
																																											name=$(awk -v num=$num '($6 == num){print $1}' tmp | cut -d "\"" -f 2)
																																											echo "8th"
																																											#	        name=$(grep -w "$num" tmp | awk '{print $1}' | cut -d "\"" -f 2)
																																													sed -i "s/\<$num\>/$name/" temp7.dat
																																															num=$(grep -w "$name" temp1.dat | awk '{print $6}')
																																																	echo "$name	$num" >> list-temp2.dat
																																																		done < tmp1
																																																			rm tmp
																													fi
																													rm tmp1

																													awk -f ../update.awk hybrid-residue-numlist.dat temp7.dat > tmp
																													mv tmp temp7.dat

																													if [[ -s list-temp1.dat ]]; then
																															i=0
																																while read line
																																		do
																																					((i++))
																																							name=$(sed -n "$i"p list-temp1.dat | awk '{print $1}')
																																									num=$(sed -n "$i"p list-temp1.dat | awk '{print $2}')
																																											sed -i "s/\<$name\>/$num/" temp7.dat
																																												done < list-temp1.dat
																																													rm list-temp1.dat
																													fi

																													if [[ -s list-temp2.dat ]]; then
																															i=0
																																while read line
																																		do
																																					((i++))
																																							name=$(sed -n "$i"p list-temp2.dat | awk '{print $1}')
																																									num=$(sed -n "$i"p list-temp2.dat | awk '{print $2}')
																																											sed -i "s/\<$name\>/$num/" temp7.dat
																																												done < list-temp2.dat
																																													rm list-temp2.dat
																													fi

																													#############################################################################################
																													#####################################ALTERNATE VERSION STARTS HERE##########################
																													#num1=$(awk '{print $1}' hybrid-residue-numlist.dat | sort -n | tail -1)
																													#num3=$(awk '{print $1}' hybrid-residue-numlist.dat | sort -n | head -1)
																													#num2=$(awk '{print $2}' hybrid-residue-numlist.dat | sort -n | head -1)
																													#num4=$(awk '{print $2}' hybrid-residue-numlist.dat | sort -n | tail -1)
																													#if [[ $num1 >= $num2 && $num4 >= $num3 ]]; then
																													#	awk '{$4=$4+100; print}' hybrid-residue-numlist.dat > temp-list.dat
																													#	i=0
																													#	while read line
																													#	do
																													#		((i++))
																													#		n1=$(sed -n "$i"p temp-list.dat | awk '{print $3}')
																													#		n2=$(sed -n "$i"p temp-list.dat | awk '{print $4}')
																													#		sed -i "s/\<$n1\>/$n2/" temp7.dat
																													#	done < temp-list.dat
																													#	awk '{$1=$1-100; $2=$2-100; print " "$0}' temp7.dat > tmp
																													#	mv tmp temp7.dat
																													#	rm temp-list.dat
																													#fi

																													#i=0
																													#while read line
																													#do
																													#	((i++))
																													#	n1=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																													#	n2=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $2}')
																													#	sed -i "s/\<$n1\>/$n2/" temp7.dat
																													#done < hybrid-residue-numlist.dat
																													### what if the atom numbers of appearing atoms are not continuous?? This strategy won't work!! But does AMBER number atoms such a way?
																													#diff=$(sed -n '1p' hybrid-residue-numlist.dat | awk '{print $2 - $1}')
																													#awk -v d=$diff '{$1=$1+d; print}' temp7.dat > tmp ; mv tmp temp7.dat
																													#awk -v d=$diff '{$2=$2+d; $3=1; print " "$0}' temp7.dat > tmp ; mv tmp temp7.dat



																													### what if the connecting atom(s) have connectivity higher than one?? This needs a check!! Is it really possible?
																													#num1=$(awk '{print $1}' temp7.dat | sort -n | head -1)
																													#num2=$(awk '{print $2}' hybrid-residue-numlist.dat | sort -n | head -1)
																													#if [[ $num1 < $num2 ]]; then
																													#	num=$((num1-diff))
																													#	sed -n "/unit\.atoms/,/unit\.atomspertinfo/p" $2.lib | sed '1d' | sed '$ d' > tmp
																													#	name=$(grep -w "$num" tmp | awk '{print $1}' | cut -d "\"" -f 2)
																													#	num=$(grep -w "$name" temp1.dat | awk '{print $6}')
																													#	sed -i "s/\<$num1\>/$num/" temp7.dat
																													#	rm tmp
																													#fi

																													#num1=$(awk '{print $2}' temp7.dat | sort -n | tail -1)
																													#num2=$(awk '{print $2}' hybrid-residue-numlist.dat | sort -n | tail -1)
																													#if [[ $num1 > $num2 ]]; then
																													#	num=$((num1-diff))
																													#	sed -n "/unit\.atoms/,/unit\.atomspertinfo/p" $2.lib | sed '1d' | sed '$ d' > tmp
																													#	name=$(grep -w "$num" tmp | awk '{print $1}' | cut -d "\"" -f 2)
																													#	num=$(grep -w "$name" temp1.dat | awk '{print $6}')
																													#	sed -i "s/\<$num1\>/$num/" temp7.dat
																													#	rm tmp
																													#fi
																													###################ALTERNATE VERSION ENDS HERE#####################################

																													sed -n "/unit\.hierarchy/,/unit\.name/p" $1.lib | sed '$ d' > temp8.dat
																													sed -n "/unit\.hierarchy/,/unit\.name/p" $2.lib | sed '1,2d' | sed '$ d' > temp9.dat

																													i=0
																													while read line; 
																													do
																															((i++))
																																num=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																																	awk -v n=$num '($4==n) {print}' temp9.dat >> tmp
																																	ls -l temp9.dat
																																	echo $num "last-1"
																																done < hybrid-residue-numlist.dat

																																#awk -v d=$diff '{$4=$4+d; print " "$0}' tmp > temp9.dat
																																awk -f ../update1.awk hybrid-residue-numlist.dat tmp > temp9.dat
																																rm tmp

																																sed -n "/unit\.name/,/unit\.residueconnect/p" $1.lib | sed '$ d' > temp10.dat
																																sed -n "/unit\.name/,/unit\.residueconnect/p" $2.lib | sed '1,3d' | sed '$ d' > temp11.dat

																																#i=0
																																#while read line;
																																#do
																																#	((i++))
																																#	num=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																																#	awk -v n=$num '(NR==n){print}' temp11.dat >> tmp
																																#done < hybrid-residue-numlist.dat
																																#mv tmp temp11.dat

																																sed -n '/unit\.residueconnect/,$p' $1.lib > temp12.dat
																																sed -n '/unit\.velocities/,$p' $2.lib | sed '1d' > temp13.dat

																																((tot_num_atoms++))
																																((num_atoms1++))
																																sed -i "s/\<$num_atoms1\>/$tot_num_atoms/" temp12.dat
																																((tot_num_atoms--))
																																((num_atoms1--))

																																#i=0     
																																#while read line;
																																#do 
																																#        ((i++))
																																#        num=$(sed -n "$i"p hybrid-residue-numlist.dat | awk '{print $1}')
																																#        awk -v n=$num '(NR==n){print}' temp13.dat >> tmp
																																#done < hybrid-residue-numlist.dat
																																#mv tmp temp13.dat

																																sed -i '1 i\!!index array str  ###  FORCE FIELD:'$4 temp1.dat
																																sed -i '1 a\ "'$3'"' temp1.dat

																																num1=$(awk '($2=="\"N\""){print $6}' temp2.dat)
																																num2=$(awk '($2=="\"C\""){print $6}' temp2.dat)
																																new_connect=$(sed -n '2p' temp12.dat | awk -v num1=$num1 -v num2=$num2 '{$3=num1; $4=num2; print $0}')
																																ls -l temp12.dat
																																echo $num1 $num2 $new_connect "last"
																																sed -i '2 c\'" $new_connect" temp12.dat

																																for i in {2..13}; 
																																do
																																		cat temp1.dat temp$i.dat > tmp
																																			mv tmp temp1.dat
																																		done
																																		mv temp1.dat hybrid.lib
																																		rm temp*.dat

																																		name=$(sed -n 3p hybrid.lib | cut -c8-10)
																																		sed -i "s/\<$name\>/$3/g" hybrid.lib 

																																		mv hybrid.lib $3.lib
																																		rm $1.lib $2.lib
