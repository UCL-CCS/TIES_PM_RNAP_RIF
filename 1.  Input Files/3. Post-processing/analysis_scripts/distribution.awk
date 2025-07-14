# distribution
function max(a,b) {if ((a+0.0) > (b+0.0)) return a; else return b;}
function min(a,b) {if ((a+0.0) < (b+0.0)) return a; else return b;}
BEGIN {
    nb=NB;
}
{
   p[NR]=$1; n=NR;
}
END {
    # detemine max & min
    maxa=p[1];
    mina=p[1];
    for(i=1;i<=n;i++) {
       maxa=max(maxa,p[i]);
       mina=min(mina,p[i]);
    }

    # initialize histogram
    for(j=0;j<nb;j++) h[j]=0.0;
    # sum up histograms and alf
    bin=(maxa-mina)/nb;
    for(i=1;i<=n;i++) {
       j=int((p[i]-mina)/bin);
       h[j]+=1;
    }
    # print out histogram
    for(j=0;j<nb;j++) {
       printf("%8.3f %12.8f\n",(j+0.5)*bin+mina,h[j]/(maxa-mina)*nb/n);
    }
}

