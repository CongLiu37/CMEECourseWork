library(stringr)
library(dplyr)

args = commandArgs(TRUE)

sample = args[1]
percent = args[2]

dire = paste("/rds/general/user/cl3820/home/Annotations/",sample,"/",percent,"_1/FunctionAnnotation",sep="")

#########################################################################
#########################################################################
### 
#########################################################################
#########################################################################

data = paste(dire,"/SeqAnnotations.txt",sep="")
data = read.table(data,sep="\t",header=TRUE)
data$ReadCount[is.na(data$ReadCount)] = 1

annotations = str_split(data$KEGG_KO,",")
time = sapply(annotations,length)
data = data.frame(SeqID=rep(data$SeqID,time),
                  KEGG_KO=unlist(annotations),
                  txid=rep(data$txid,time),
                  ReadCount=rep(data$ReadCount,time),
                  TxPath=rep(data$TxPath,time),
                  TxGroup=rep(data$TxGroup,time),
                  SeqType=rep(data$SeqType,time))

annotations = str_split(data$KEGG_KO,":")
time = sapply(annotations,length)
data = data.frame(SeqID=rep(data$SeqID,time),
                  KEGG_KO=unlist(annotations),
                  txid=rep(data$txid,time),
                  ReadCount=rep(data$ReadCount,time),
                  TxPath=rep(data$TxPath,time),
                  TxGroup=rep(data$TxGroup,time),
                  SeqType=rep(data$SeqType,time))
data = subset(data,data$KEGG_KO!="ko")
write.table(data,paste(dire,"/SeqAnnotations_complete.txt",sep=""),sep="\t",row.names=FALSE,quote=FALSE)

data = subset(data,data$TxGroup!="Plants")
data = subset(data,data$TxGroup!="Arthropods")
data = subset(data,data$KEGG_KO!="-")
data = subset(data,data$KEGG_KO!="")
data[is.na(data)] = "None"

KO_TaxonPath = data.frame(txid=data$txid,TxPath=data$TxPath,TxGroup=data$TxGroup,KEGG_KO=data$KEGG_KO,ReadCount=as.numeric(data$ReadCount))
KO_TaxonPath = group_by(KO_TaxonPath,txid,TxPath,TxGroup,KEGG_KO)
KO_TaxonPath = summarise(KO_TaxonPath,ReadCount=sum(ReadCount))
write.table(KO_TaxonPath,paste(dire,"/KO_TaxonPath.txt",sep=""),sep="\t",row.names=FALSE,quote=FALSE)

Txid_KO = data.frame(data$txid,data$KEGG_KO)
Txid_KO = Txid_KO[!duplicated(Txid_KO),]
write.table(Txid_KO,paste(dire,"/Txid_KO.txt",sep=""),sep="\t",row.names=FALSE)

KO_abundance = data.frame(KEGG_KO=data$KEGG_KO,ReadCount=as.numeric(data$ReadCount))
KO_abundance = group_by(KO_abundance,KEGG_KO)
KO_abundance = summarise(KO_abundance,ReadCount=sum(ReadCount))
write.table(KO_abundance,paste(dire,"/KO_quantify.txt",sep=""),sep="\t",row.names=FALSE,quote=FALSE)
