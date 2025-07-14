library(boot)
args <- commandArgs(trailingOnly = TRUE)
file_delg <- paste('tot-scaled-',args[1],'-repw.dat',sep="")
data <-read.table(file_delg)
num_reps <- as.integer(args[2])
sim.comb <- NULL
for (n in 1:10000) {
        sim.comb <- rbind(sim.comb,mean(sample(data[,1],num_reps,replace=TRUE,prob=NULL),na.rm=TRUE))
}
file_out <- paste('dg-tot-scaled-boot-',args[1],'.dat',sep="")
write.table(sim.comb, file=file_out, sep='\t', row.names=FALSE, col.names=FALSE, quote=FALSE)
