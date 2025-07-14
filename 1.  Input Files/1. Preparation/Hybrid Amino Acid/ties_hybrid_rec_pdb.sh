#!/bin/bash
## $1 - first command line argument - path/name of the protein pdb file.
## $2 - second command line argument - residue number to be mutated.
## $3 - third command line argument - name of the hybrid library file (assuming that it and the file hybrid-residue-namelist.dat are both located in $PWD).

IFS='%'
cp $1 rec.pdb
resnum=$(printf "%4s" "$2")
awk -v resnum=$resnum 'substr($0,23,4)==resnum {print NR}' rec.pdb > temp
original_resname=$(awk -v resnum=$resnum 'substr($0,23,4)==resnum {print}' rec.pdb | sed -n '1p' | cut -c18-20)
unset IFS

hybrid_residue_name=$(sed -n '2p' $3 | awk '{print $1}' | cut -d "\"" -f 2)

for i in `cat temp`; 
do
		sed -i "$i s#$original_resname#$hybrid_residue_name#" rec.pdb; 
	done

	rm temp

	#arr_names1=(`awk '{if (length($0) > 3) printf"%4s%",$0; else printf" %-3s%",$0;}' hybrid-residue-namelist-res1.dat`)
	arr_names1=(`awk '{ if ($0 !~ /[H]/) print}' hybrid-residue-namelist-res1.dat`)
	#arr_names2=(`awk '{if (length($1) > 3) printf"%4s%",$1; else printf" %-3s%",$1;}' hybrid-residue-namelist.dat`)
	arr_names2=(`awk '{ if ($1 !~ /[H]/) print $1}' hybrid-residue-namelist.dat`)

	arr_common=($(comm -12 <(printf '%s\n' "${arr_names1[@]}" | sort) <(printf '%s\n' "${arr_names2[@]}" | sort)))
	for i in `echo "${arr_common[@]}"`; 
	do
			new_name=$(awk -v i=$i '$1==i {print $2}' hybrid-residue-namelist.dat)
				IFS='%'
					old_name=$(echo "$i" | awk '{if (length($0) > 3) printf"%s\n",$0; else printf" %-3s\n",$0;}')
						line_num=$(awk -v resnum=$resnum -v old_name=$old_name 'substr($0,23,4)==resnum && substr($0,13,4)==old_name {print NR}' rec.pdb)
							mod_line=$(awk -v resnum=$resnum -v old_name=$old_name 'substr($0,23,4)==resnum && substr($0,13,4)==old_name {print}' rec.pdb | awk -v new_n=$new_name '{if (length(new_n) > 3) printf"%s%s%s\n", substr($0,1,12),new_n,substr($0,17); else printf"%s %-3s%s\n",substr($0,1,12),new_n,substr($0,17);}')
								sed -i "$line_num a \\$mod_line" rec.pdb
									unset IFS
								done

								arr_uncommon1=($(comm -23 <(printf '%s\n' "${arr_names1[@]}" | sort) <(printf '%s\n' "${arr_names2[@]}" | sort)))
								arr_uncommon2=($(comm -13 <(printf '%s\n' "${arr_names1[@]}" | sort) <(printf '%s\n' "${arr_names2[@]}" | sort)))

								if [ ${#arr_uncommon1[@]} -ne 0 ] && [ ${#arr_uncommon2[@]} -ne 0 ]; then
									rm -f temp1; for i in `echo "${arr_uncommon1[@]}"`; do echo $i	${i:1} >> temp1 ;done
									rm -f temp2; for i in `echo "${arr_uncommon2[@]}"`; do echo $i	${i:1} >> temp2 ;done
									arr1=(`awk '{print $2}' temp1`)
									arr2=(`awk '{print $2}' temp2`)

									arr_common_order2=($(comm -12 <(printf '%s\n' "${arr1[@]}" | sort) <(printf '%s\n' "${arr2[@]}" | sort)))
									if [ ${#arr_common_order2[@]} -ne 0 ]; then
										for j in `echo "${arr_common_order2[@]}"`;
										do
												i2=$(awk -v j=$j '($2==j) {print $1}' temp2)
												        new_name=$(awk -v i=$i2 '$1==i {print $2}' hybrid-residue-namelist.dat)
														i1=$(awk -v j=$j '($2==j) {print $1}' temp1)
														        IFS='%'
															        old_name=$(echo "$i1" | awk '{if (length($0) > 3) printf"%s\n",$0; else printf" %-3s\n",$0;}')
																        line_num=$(awk -v resnum=$resnum -v old_name=$old_name 'substr($0,23,4)==resnum && substr($0,13,4)==old_name {print NR}' rec.pdb)
																	        mod_line=$(awk -v resnum=$resnum -v old_name=$old_name 'substr($0,23,4)==resnum && substr($0,13,4)==old_name {print}' rec.pdb | awk -v new_n=$new_name '{if (length(new_n) > 3) printf"%s%s%s\n", substr($0,1,12),new_n,substr($0,17); else printf"%s %-3s%s\n",substr($0,1,12),new_n,substr($0,17);}')
																		        sed -i "$line_num a \\$mod_line" rec.pdb
																			        unset IFS
																			done
									fi

									arr_uncommon1=($(comm -23 <(printf '%s\n' "${arr1[@]}" | sort) <(printf '%s\n' "${arr2[@]}" | sort)))
									arr_uncommon2=($(comm -13 <(printf '%s\n' "${arr1[@]}" | sort) <(printf '%s\n' "${arr2[@]}" | sort)))

									if [ ${#arr_uncommon1[@]} -ne 0 ] && [ ${#arr_uncommon2[@]} -ne 0 ]; then
										rm -f temp3; for i in `echo "${arr_uncommon1[@]}"`; do j=$(awk -v i=$i '($2==i){print $1}' temp1); echo $j	${i:0:1} >> temp3 ;done
										rm -f temp4; for i in `echo "${arr_uncommon2[@]}"`; do j=$(awk -v i=$i '($2==i){print $1}' temp2); echo $j	${i:0:1} >> temp4 ;done
										arr3=(`awk '{print $2}' temp3`)
										arr4=(`awk '{print $2}' temp4`)

										arr_common_order3=($(comm -12 <(printf '%s\n' "${arr3[@]}" | sort) <(printf '%s\n' "${arr4[@]}" | sort)))
										if [ ${#arr_common_order3[@]} -ne 0 ]; then
											for j in `echo "${arr_common_order3[@]}"`;
											do
													i2=$(awk -v j=$j '($2==j){print $1}' temp4 | head -1)
													        new_name=$(awk -v i=$i2 '$1==i {print $2}' hybrid-residue-namelist.dat)
															i1=$(awk -v j=$j '($2==j) {print $1}' temp3 | head -1)
															        IFS='%'
																        old_name=$(echo "$i1" | awk '{if (length($0) > 3) printf"%s\n",$0; else printf" %-3s\n",$0;}')
																	        line_num=$(awk -v resnum=$resnum -v old_name=$old_name 'substr($0,23,4)==resnum && substr($0,13,4)==old_name {print NR}' rec.pdb)
																		        mod_line=$(awk -v resnum=$resnum -v old_name=$old_name 'substr($0,23,4)==resnum && substr($0,13,4)==old_name {print}' rec.pdb | awk -v new_n=$new_name '{if (length(new_n) > 3) printf"%s%s%s\n", substr($0,1,12),new_n,substr($0,17); else printf"%s %-3s%s\n",substr($0,1,12),new_n,substr($0,17);}')
																			        sed -i "$line_num a \\$mod_line" rec.pdb
																				        unset IFS
																				done
										fi

										rm temp3 temp4
									fi
									rm temp1 temp2
								fi
								new_n=$(awk '$1=="N" {print $2}' hybrid-residue-namelist.dat)
								new_c=$(awk '$1=="C" {print $2}' hybrid-residue-namelist.dat)
								rm -f hybrid_res_bond_info.dat
								i=$(($2-1))
								echo "bond rec.$i.C rec.$2.$new_n" >> hybrid_res_bond_info.dat
								i=$(($2+1))
								echo "bond rec.$2.$new_c rec.$i.N" >> hybrid_res_bond_info.dat
