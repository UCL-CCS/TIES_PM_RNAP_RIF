BEGIN {
	}

	NR==FNR {
		  p1[NR]=$1; p2[p1[NR]]=$2; nfirst=NR;
		    next
	    }
	    NR!=FNR {
		      n1[NR]=$1" "$2" "$3; n2[NR]=$4; nt=NR;
		        next
		}

		END {
			    for(i=nfirst+1;i<=nt;i++) {
				           print " "n1[i],p2[n2[i]]
					       }
				       }
