library(ggplot2)

Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
CleanReadCount = c(882436,53612702,48426748,45805759,35282101,45059211,44466776) # 842095
MetagenomicReadCount = c(882436,5300592,3557052,4618023,10413704,38837759,17014144) # 665507
HostReadCount = CleanReadCount-MetagenomicReadCount

data = rbind(
  data.frame(relabel=relabels,ReadCount=MetagenomicReadCount,Type=rep("Non-host",length(MetagenomicReadCount))),
  data.frame(relabel=relabels,ReadCount=HostReadCount,Type=rep("Host",length(MetagenomicReadCount)))
)

pdf("NonHostRatio.pdf")
p = ggplot(data,aes(fill=Type,x=relabel,y=ReadCount/1e+6))+
  geom_bar(stat = "identity")+
  ylab("Read (million)")+
  xlab(NULL)+
  theme_classic()+
  theme(axis.text.x=element_text(angle=90,hjust=0.5,vjust=0.5))+
  scale_y_continuous(expand = c(0,0))
print(p)
dev.off()

#########################################################################
#########################################################################
### Subsampling
#########################################################################
#########################################################################
names(relabels) = Samples
relabels = sort(relabels)
ranks = c("phylum","class","order","family","genus","species")

ReadData = function(sample,rank,percent,rep){
    # Read quantification file
    # Return data frame with taxon names and relative abundances
    data = paste(sample,"/",percent,"_",rep,"/FunctionAnnotation/",rank,"Quantify.txt",sep="")
    data = read.table(data,header=TRUE,sep="\t")

    d = data.frame(Name = data$Name,Group=data$Group,quantify = data$TotalCount)
    
    colnames(d) = c("Name","Group",relabels[sample])
    return(d)}

DataFrame = function(rank,percent,rep){
    # Return relative abundance matrix of all samples (data frame)
    d = data.frame(Name=c(NA),Group=c(NA))
    
    for (sample in names(relabels)){
        data = ReadData(sample,rank,percent,rep)
        d = merge(d,data,by=c("Name","Group"),all=TRUE)
    }
    
    d = subset(d,d$Name!="NA")
    
    d[is.na(d)] = 0

    write.table(d,file=paste(percent,"_",rep,"_",rank,"_matrix.txt",sep=""),sep="\t",row.names=FALSE)
    
    return(d)}

for (rank in ranks){
        DataFrame(rank,"1","1")
}

#########################################################################
#########################################################################
### Species heatmap
#########################################################################
#########################################################################
percents = seq(0.1,1,0.1)

GroupAbundance = function(sample,percent,rank){
    
    if (rank=="all"){
        data = paste(sample,"/",percent,"_1/FunctionAnnotation/TaxonQuantification.txt",sep="")
    }else{
        data = paste(sample,"/",percent,"_1/FunctionAnnotation/",rank,"Quantify.txt",sep="")
    }

    data = read.table(data,sep="\t",header=TRUE)

    data = aggregate(data$TotalCount, by=list(Group=data$Group), sum)
    
    data = data.frame(Group=data$Group, 
                      TotalCount=data$x, 
                      Sample=rep(relabels[sample],length(data$Group)),
                      RelAbundance=data$x/sum(data$x),
                      Zscore = (data$x-mean(data$x))/sd(data$x))

    return(data)
}

GroupAbundanceFrame = function(percent,rank){
    d = data.frame(Group=c(),TotalCount=c(),Sample=c(),RelAbundance=c(),Zscore=c())
    for (sample in names(relabels)){
        d = rbind(d,GroupAbundance(sample,percent,rank))
        }
    return(d)
}

Plot = function(percent,rank,y){
    data = GroupAbundanceFrame(percent,rank)

    pdf = paste(percent,"_",rank,"_",y,"_GroupAbundance.pdf",sep="")
    
    if (y=="TotalCount"){yvalues=data[,y]/1e+6;ylab="Reads (million)"
    }else if (y=="RelAbundance"){yvalues=data[,y];ylab="Relative Abundance"
    }else if (y=="Zscore"){yvalues=data[,y];ylab="Z-score"}
    
    pdf(pdf)
    p = ggplot(data,aes(fill=Group,x=Sample,y=yvalues))+
    geom_bar(stat="identity")+
    ylab(ylab)+
    xlab(NULL)+
    theme_classic()+
    theme(axis.text.x=element_text(angle=90,hjust=0.5,vjust=0.5))+
    scale_y_continuous(expand = c(0,0))+
    scale_fill_manual(values=c("#000000","#0000FF","#FF00FF","#66FFFF","#006600","#FF0000"))
    print(p)
    dev.off()
}

Plot("1","all","TotalCount")
Plot("1","all","RelAbundance")
Plot("1","all","Zscore")

Plot("1","species","TotalCount")
Plot("1","species","RelAbundance")
Plot("1","species","Zscore")
