BEGIN {
	}

	NR==FNR {
		  p1[NR]=$1; p2[p1[NR]]=$2; nfirst=NR;
		    next
	    }
	    NR!=FNR {
		      n1[NR]=$1; n2[NR]=$2; nt=NR;
		        next
		}

		END {
			    for(i=nfirst+1;i<=nt;i++) {
				           if(match(n1[i],/[A-Za-z0-9]*[A-Za-z][A-Za-z0-9]*/)) p2[n1[i]]=n1[i];
					          if(match(n2[i],/[A-Za-z0-9]*[A-Za-z][A-Za-z0-9]*/)) p2[n2[i]]=n2[i];
						         print " "p2[n1[i]],p2[n2[i]],1
							     }
						     }
