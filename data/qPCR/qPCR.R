#Error bar fuction
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
stop("vectors must be same length")
arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length/3, ...)
}


### User Data
#Genes list
#Use the corresponding gene names listed here as the Ct file name
genes<-c("GeneA","GeneB","GeneC")
#Number of sample
num_sam <- 10;
#Number of repeat (biological or technical)
num_rep <- 2;
#Line of Control
lctrl <- 1;

num_gene <- length(genes);
###Figure layout
#Number of row
num_row <- 1;
#Number of column
num_col <- 3;
layout(mat=matrix(1:num_gene, num_row, num_col, byrow=TRUE))


#Main
for (myct in genes) {
	
#Read data
ct<- read.table(myct)
#Format data
row.names(ct)<-ct$V1
for	(j in 1:(2*num_rep)) {
	ct[j]<-ct[j+1]
}
ct<-ct[-(2*num_rep+1)]

expr=rep(NA, num_sam*num_rep)
dim(expr)<-c(num_sam,num_rep)

#ctr_ref
ref_calibrator<-mean(as.numeric(ct[lctrl,1:num_rep]))
calibrator<-mean(as.numeric(ct[lctrl,(num_rep+1):(2*num_rep)]-ref_calibrator))

for (i in 1:num_sam) {
	ref<-mean(as.numeric(ct[i,1:num_rep]))
	#dCt
	dct<-ct[i,(num_rep+1):(2*num_rep)]-ref
	#ddCt
	ddct<-dct-calibrator
	#fold
	expr[i,1:num_rep]<-2^-ddct
}
fold<-t(expr)

fold.means=rep(NA, num_sam)
fold.sd=rep(NA, num_sam)


for (i in 1:num_sam) {
	fold.means[i]<-mean(fold[,i])
	fold.sd[i]<-sd(fold[,i])
}

ymax=max(fold.means)+1.1*max(fold.sd)
barx <- barplot(fold.means,col=1,ylim=c(0,ymax),names.arg=row.names(ct), main=myct,xlab="Tissue type",ylab="Normlized fold expression")
error.bar(barx,fold.means, fold.sd)

}