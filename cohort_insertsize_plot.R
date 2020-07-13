#!/usr/bin/env Rscript

library(pheatmap)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = paste0("Insert size distribution for ",args[1])
}

insert_df <- read.table(args[1], header =T, row.names=1, sep="\t")

x<-as.numeric(row.names(insert_df))

for (i in x){
  if (i %% 50 != 0) x[match(i,x)] <- ""
}


pdf(paste0(args[1],".pdf"))

pheatmap(insert_df, cluster_rows=F, cluster_cols=F, scale="column", main=args[2], labels_row=x)

dev.off() 