library(ggplot2)
library(ComplexHeatmap)
library(circlize)
library(proxy)
library(ape)

#########################################################################
#########################################################################
### NonHostRatio.pdf
#########################################################################
#########################################################################
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
### Group abundance distribution
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)

GroupAbundance = function(sample,rank){
    if (rank=="all"){
        data = paste(sample,"/1_1/FunctionAnnotation/TaxonQuantification.txt",sep="")
    }else{
        data = paste(sample,"/1_1/FunctionAnnotation/",rank,"Quantify.txt",sep="")
    }

    data = read.table(data,sep="\t",header=TRUE)

    data = aggregate(data$TotalCount, by=list(Group=data$Group), sum)
    
    data = data.frame(Group=data$Group, 
                      TotalCount=data$x, 
                      Sample=rep(relabels[sample],length(data$Group)),
                      RelAbundance=data$x/sum(data$x))

    return(data)
}

GroupAbundanceFrame = function(rank){
    d = data.frame(Group=c(),TotalCount=c(),Sample=c(),RelAbundance=c())
    for (sample in names(relabels)){
        d = rbind(d,GroupAbundance(sample,rank))
        }
    return(d)
}

Plot = function(rank){
    data = GroupAbundanceFrame(rank)

    pdf = paste("1_",rank,"_RelAbundance_GroupAbundance.pdf",sep="")
    
    yvalues=data[,"RelAbundance"]
    ylab="Relative Abundance"
    
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

Plot("species")
#########################################################################
#########################################################################
### Taxon abundance matrix
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)
ranks = c("phylum","class","order","family","genus","species")

ReadData = function(sample,rank){
    data = paste(sample,"/1_1/FunctionAnnotation/",rank,"Quantify.txt",sep="")
    data = read.table(data,header=TRUE,sep="\t")

    d = data.frame(Name = data$Name,Group=data$Group,quantify = data$TotalCount)
    
    colnames(d) = c("Name","Group",relabels[sample])
    return(d)}

DataFrame = function(rank){
    # Return relative abundance matrix of all samples (data frame)
    d = data.frame(Name=c(NA),Group=c(NA))
    
    for (sample in names(relabels)){
        data = ReadData(sample,rank)
        d = merge(d,data,by=c("Name","Group"),all=TRUE)
    }
    
    d = subset(d,d$Name!="NA")
    
    d[is.na(d)] = 0

    write.table(d,file=paste("1_1_",rank,"_matrix.txt",sep=""),sep="\t",row.names=FALSE,quote=FALSE)
    
    return(d)}

for (rank in ranks){
        DataFrame(rank)
}
#########################################################################
#########################################################################
### Species abundance heatmap
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)

ReadData = function(sample,rank,group){
    data = paste(sample,"/1_1/FunctionAnnotation/",rank,"Quantify.txt",sep="")
    data = read.table(data,header=TRUE,sep="\t")

    if (group != "all"){
        data = subset(data,data$Group==group)
        }
    
    d = data.frame(Name = data$Name, quantify = data$TotalCount/sum(data$TotalCount))

    colnames(d) = c("Name",relabels[sample])
    
    return(d)}

DataFrame = function(rank,group){
    d = data.frame(Name=c(NA))
    
    for (sample in names(relabels)){
        d = merge(d,ReadData(sample,rank,group),by="Name",all=TRUE)}
    
    d = subset(d,d$Name!="NA")
    
    d[is.na(d)] = 0
    
    # write.table(d,file=paste(percent,"_",rep,"_",rank,"_matrix.txt",sep=""),sep="\t",row.names=FALSE)
    
    return(d)}

Frame2Matrix = function(rank,dominance,group){
    data = DataFrame(rank,group)

    others = rep(0,length(Samples))

    for (name in data$Name){
        abun = unlist(subset(data,data$Name==name)[,-1],use.names=FALSE)
        if (max(abun) < dominance){
            others = others+abun
            data = subset(data,data$Name != name)}
    }

    others = c("Others",others)
    others = t(data.frame(others))
    colnames(others) = colnames(data)

    frame = rbind(data,others)

    matrix = as.matrix(frame[,2:(length(Samples)+1)])
    matrix = apply(matrix,2,as.numeric)
    rownames(matrix) = frame$Name
    
    return(matrix)}

Matrix2Heatmap = function(rank,dominance,group){
    data = Frame2Matrix(rank,dominance,group)

    figure = paste("RelativeAbundance_",as.character(dominance),"_",rank,"_",group,".pdf",sep="")

    if (group!="all"){
        row_title = paste(group," ",rank,sep="")
        }else{
            row_title = rank
            }

    if (group=="all"){
        EndCol="red"
        }else if (group=="Arthropods"){
           EndCol="#000000"
        }else if (group=="Bacteria"){
            EndCol="#000099"
        }else if (group=="Fungi"){
            EndCol="#990099"
        }else if (group=="Plants"){
            EndCol="#006600"
        }else if (group=="Viruses"){
            EndCol="#990000"
        }else if (group=="Others"){
            EndCol="#66FFFF"
        }
    
    pdf(figure)
    p = Heatmap(data,
    name="Relative Abundance",column_title="Sample",row_title=row_title,
    row_names_gp=gpar(fontsize = 4.5),column_names_gp=gpar(fontsize = 10),
    column_names_side = "top",
    cluster_rows=FALSE,
    cluster_columns=FALSE,
    col=circlize::colorRamp2(c(0,1),c("#FFFFFF",EndCol))
    )
    print(p)
    dev.off()}

Matrix2Heatmap("species",0.01,"all")
Matrix2Heatmap("species",0.01,"Bacteria")
Matrix2Heatmap("species",0.01,"Arthropods")
Matrix2Heatmap("species",0.01,"Fungi")
Matrix2Heatmap("species",0.01,"Viruses")
Matrix2Heatmap("species",0.01,"Plants")
Matrix2Heatmap("species",0.01,"Others")
Matrix2Heatmap("genus",0.01,"all")
#########################################################################
#########################################################################
### KO abundance matrix
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)

ReadData = function(sample){
    data = paste(sample,"/1_1/FunctionAnnotation/KO_quantify.txt",sep="")
    data = read.table(data,header=TRUE,sep="\t")
    d = data.frame(Name = data$KEGG_KO,quantify = data$ReadCount)
    colnames(d) = c("KEGG_KO",relabels[sample])
    return(d)}

d = data.frame(KEGG_KO=c(NA))
for (sample in names(relabels)){
    data = ReadData(sample)
    d = merge(d,data,by=c("KEGG_KO"),all=TRUE)
}
    
d = subset(d,d$KEGG_KO!="NA")
    
d[is.na(d)] = 0

write.table(d,file="1_1_KO_matrix.txt",sep="\t",row.names=FALSE,quote=FALSE)

#########################################################################
#########################################################################
### Pathway coverage matrix
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)

ReadData = function(sample,percent,rep){
    data = paste(sample,"/",percent,"_",rep,"/FunctionAnnotation/PathwaySummary.txt",sep="")
    data = read.table(data,header=TRUE,sep="\t")
    data = subset(data,data$MinPath=="1")

    d = data.frame(PathwayID = data$PathwayID,Description=data$Description,Cov=data$Coverage)
    
    colnames(d) = c("PathwayID","Description",relabels[sample])
    return(d)}

DataFrame = function(percent,rep){
    # Return relative abundance matrix of all samples (data frame)
    d = data.frame(PathwayID=c(NA),Description=c(NA))
    
    for (sample in names(relabels)){
        data = ReadData(sample,percent,rep)
        d = merge(d,data,by=c("PathwayID","Description"),all=TRUE)
    }
    
    d[is.na(d)] = 0

    write.table(d,file=paste(percent,"_",rep,"_Pathway_matrix.txt",sep=""),sep="\t",row.names=FALSE,quote=FALSE)
    
    return(d)}

DataFrame("1","1")
#########################################################################
#########################################################################
### Pathway coverage heatmap
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)

# data = read.table("1_1_Pathway_matrix.txt",sep="\t",header=TRUE)
# data = data[,-1]
# # for (name in data$Description){
# #         abun = as.numeric(unlist(subset(data,data$Description==name)[,-1],use.names=FALSE))
# #         if (max(abun) < 0.6){
# #             data = subset(data,data$Description != name)}
# #     }
# matrix = as.matrix(data[,2:(length(Samples)+1)])
# matrix = apply(matrix,2,as.numeric)
# rownames(matrix) = data$Description
# pdf("PathwayCov_0.1.pdf")
# p = Heatmap(data,
#     name="Coverage",column_title="Sample",row_title="Pathway",
#     row_names_gp=gpar(fontsize = 4.5),column_names_gp=gpar(fontsize = 10),
#     column_names_side = "top",
#     cluster_rows=FALSE,
#     cluster_columns=FALSE,
#     col=circlize::colorRamp2(c(0,1),c("#FFFFFF","red"))
#     )
# print(p)
# dev.off()
#########################################################################
#########################################################################
### Pathway heatmap
#########################################################################
#########################################################################
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh") # "PGnos_high_hv13-1"
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1") # "Bee_Amellifera_hv13_1"
names(relabels) = Samples
relabels = sort(relabels)

Frame2Matrix = function(file){
    frame = read.table(paste(file,".txt",sep=""),header=TRUE,sep="\t")

    matrix = as.matrix(frame[,3:(length(Samples)+2)])
    matrix = apply(matrix,2,as.numeric)
    rownames(matrix) = frame$Description
    
    return(matrix)}

Matrix2Heatmap = function(file,RowTitle){
    data = Frame2Matrix(file)

    figure = paste("PathwayCov_",file,".pdf",sep="")
    
    pdf(figure)
    p = Heatmap(data,
    name="Coverage",column_title="Sample",row_title=RowTitle,
    row_names_gp=gpar(fontsize = 4.5),column_names_gp=gpar(fontsize = 10),
    column_names_side = "top",
    cluster_rows=FALSE,
    cluster_columns=FALSE,
    col=circlize::colorRamp2(c(0,1),c("#FFFFFF","red"))
    )
    print(p)
    dev.off()}
































PathwayIDs = c()
PathwayDescription = c()

