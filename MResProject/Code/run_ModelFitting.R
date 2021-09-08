# DESCRIPTION:
# Run model fitting. 
# Generate tables summarizing coefficients, model final slopes, optimal sequencing depth.
# Visualize models.

# DEPENDENCIES:
# minpack.lm, ggplot2
# R script DiversityModel.R

# ARGUMENTS:

# OUTPUT:

# Note:
# Take output of ComputeDiversity.py as input

library(ggplot2)
library(minpack.lm)

source("DiversityModel.R")

q_values = c("0","1","2")
Samples = c("LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp",
            "PGnos_high_hv13-1","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh")
relabels = c("Flower_eDNA","Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2",
             "Bee_Amellifera_hv13_1","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1")
names(relabels)=Samples

ConvertID = function(input){
  output = rep(NA,length(input))
  for (i in 1:length(input)){
  if (input[i] %in% Samples){
  output[i] = unname(relabels[input[i]])
  }else{
    output[i]=input[i]
  }}
  return(output)
}

Fitting = function(type){ # Taxon/Function
    OutputTable = data.frame()

    for (sample in Samples){
    for (q in q_values){
        run = run_ModelFitting(sample,q,type)

        ret = c(sample,q,run$Asymptote,
                
                run$simu_x[length(run$simu_x)],run$y[length(run$y)],run$simu_y[length(run$simu_y)],
                run$d_simu_y[length(run$d_simu_y)],run$simu_y[length(run$simu_y)]/run$Asymptote,
                
                run$OptDepth_0.5,run$OptDiversity_0.5,run$OptDiversity_0.5/run$Asymptote,
                run$OptDepth_0.1,run$OptDiversity_0.1,run$OptDiversity_0.1/run$Asymptote,
                run$OptDepth_0.05,run$OptDiversity_0.05,run$OptDiversity_0.05/run$Asymptote,
                run$OptDepth_0.01,run$OptDiversity_0.01,run$OptDiversity_0.01/run$Asymptote,
                
                run$m1[1],run$m1[2],run$m1[3],run$weight[1],
                run$m2[1],run$m2[2],run$m2[3],run$weight[2],
                run$m3[1],run$m3[2],run$m3[3],run$m3[4],run$weight[3],
                run$m4[1],run$m4[2],run$m4[3],run$m4[4],run$weight[4],
                run$m5[1],run$m5[2],run$m5[3],run$m5[4],run$m5[5],run$weight[5])
        OutputTable = rbind(OutputTable,ret)
        }
    }
    colnames(OutputTable) = c("Sample","q","Asymptote",
                            "FinalDepth","FinalDiversity","ExpectedFinalDiversity","FinalSlope",
                            "ExpectedFinalCov",
                            "OptDepth_0.5","OptDiversity_0.5","OptCov_0.5",
                            "OptDepth_0.1","OptDiversity_0.1","OptCov_0.1",
                            "OptDepth_0.05","OptDiversity_0.05","OptCov_0.05",
                            "OptDepth_0.01","OptDiversity_0.01","OptCov_0.01",
                            "m1_a","m1_b","m1_AIC","m1_weight",
                            "m2_a","m2_b","m2_AIC","m2_weight",
                            "m3_a","m3_b","m3_c","m3_AIC","m3_weight",
                            "m4_a","m4_b","m4_c","m4_AIC","m4_weight",
                            "m5_a","m5_b","m5_c","m5_d","m5_AIC","m5_weight")
    write.table(OutputTable,paste(type,"_ModelSummary.txt",sep=""),row.names = FALSE,sep="\t",quote=FALSE)

    data = OutputTable
    Table1 = subset(data,q=="0")
Table1 = data.frame(Sample=Table1$Sample,
                    FinalDepth=Table1$FinalDepth,
                    FinalDiversity=Table1$FinalDiversity,
                    ExpectedFinalDiversity=Table1$ExpectedFinalDiversity,
                    FinalSlope=Table1$FinalSlope,
                    Asymptote=Table1$Asymptote,
                    Cov=as.numeric(Table1$ExpectedFinalDiversity)/
                      as.numeric(Table1$Asymptote))
Table1=apply(Table1,2,ConvertID)
write.csv(Table1,paste(type,"Hill0_FinalSlope.csv",sep=""),row.names=FALSE)

Table2 = data[order(data[,"q"],decreasing = FALSE),]
Table2 = data.frame(Sample=Table2$Sample,
                    q = Table2$q,
                    Asymptote=Table2$Asymptote,
                    
                    OptDepth_0.5=Table2$OptDepth_0.5,
                    OptDiversity_0.5=Table2$OptDiversity_0.5,
                    OptCov_0.5=Table2$OptCov_0.5,
                    
                    OptDepth_0.1=Table2$OptDepth_0.1,
                    OptDiversity_0.1=Table2$OptDiversity_0.1,
                    OptCov_0.1=Table2$OptCov_0.1,
                    
                    OptDepth_0.05=Table2$OptDepth_0.05,
                    OptDiversity_0.05=Table2$OptDiversity_0.05,
                    OptCov_0.05=Table2$OptCov_0.05,
                    
                    OptDepth_0.01=Table2$OptDepth_0.01,
                    OptDiversity_0.01=Table2$OptDiversity_0.01,
                    OptCov_0.01=Table2$OptCov_0.01)
Table2=apply(Table2,2,ConvertID)
write.csv(Table2,paste(type,"_OptDepth.csv",sep=""),row.names=FALSE)

Table3 = data[order(data[,"q"],decreasing = FALSE),]
Table3 = Table3[!colnames(Table3)%in%c("FinalDepth","FinalDiversity","Asymptote",
                              "ExpectedFinalDiversity","FinalSlope","ExpectedFinalCov",
                              "OptDepth_0.5","OptDiversity_0.5","OptCov_0.5","OptDepth_0.1","OptDiversity_0.1",
                              "OptCov_0.1","OptDepth_0.05","OptDiversity_0.05","OptCov_0.05",
                              "OptDepth_0.01","OptDiversity_0.01","OptCov_0.01")]
Table3 = apply(Table3,2,ConvertID)
write.csv(Table3,paste(type,"_Coefficients.csv",sep=""),row.names=FALSE)
}

Fitting("Taxon")
Fitting("Function")


type = "Taxon"
q = "0"
H13_2 = run_ModelFitting("PGnos_high_hv13-2",q,type)
H15 = run_ModelFitting("PGnos_inter_hv15",q,type)
Hp = run_ModelFitting("PGpollen_fresh",q,type)
pdf("Honey_TaxonHill_0.pdf")
p1 = ggplot()+
  geom_point((aes(x=H13_2$x,y=H13_2$y,colour="Bee_Amellifera_hv13_2")))+
  geom_point(aes(x=H15$x,y=H15$y,colour="Bee_Amellifera_hv15_1"))+
  geom_point(aes(x=Hp$x,y=Hp$y,colour="Bee_Amellifera_wild_1"))+
  geom_line(aes(x=H13_2$simu_x,y=H13_2$simu_y,colour="Bee_Amellifera_hv13_2"))+
  geom_line(aes(x=H15$simu_x,y=H15$simu_y,colour="Bee_Amellifera_hv15_1"))+
  geom_line(aes(x=Hp$simu_x,y=Hp$simu_y,colour="Bee_Amellifera_wild_1"))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=0)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,180))+
  scale_color_manual(values=c("#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p1)
dev.off()

q = "1"
H13_2 = run_ModelFitting("PGnos_high_hv13-2",q,type)
H15 = run_ModelFitting("PGnos_inter_hv15",q,type)
Hp = run_ModelFitting("PGpollen_fresh",q,type)
pdf("Honey_TaxonHill_1.pdf")
p2 = ggplot()+
  geom_point((aes(x=H13_2$x,y=H13_2$y,colour="Bee_Amellifera_hv13_2")))+
  geom_point(aes(x=H15$x,y=H15$y,colour="Bee_Amellifera_hv15_1"))+
  geom_point(aes(x=Hp$x,y=Hp$y,colour="Bee_Amellifera_wild_1"))+
  geom_line(aes(x=H13_2$simu_x,y=H13_2$simu_y,colour="Bee_Amellifera_hv13_2"))+
  geom_line(aes(x=H15$simu_x,y=H15$simu_y,colour="Bee_Amellifera_hv15_1"))+
  geom_line(aes(x=Hp$simu_x,y=Hp$simu_y,colour="Bee_Amellifera_wild_1"))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=1)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,22))+
  scale_color_manual(values=c("#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p2)
dev.off()

q = "2"
H13_2 = run_ModelFitting("PGnos_high_hv13-2",q,type)
H15 = run_ModelFitting("PGnos_inter_hv15",q,type)
Hp = run_ModelFitting("PGpollen_fresh",q,type)
pdf("Honey_TaxonHill_2.pdf")
p3 = ggplot()+
  geom_point((aes(x=H13_2$x,y=H13_2$y,colour="Bee_Amellifera_hv13_2")))+
  geom_point(aes(x=H15$x,y=H15$y,colour="Bee_Amellifera_hv15_1"))+
  geom_point(aes(x=Hp$x,y=Hp$y,colour="Bee_Amellifera_wild_1"))+
  geom_line(aes(x=H13_2$simu_x,y=H13_2$simu_y,colour="Bee_Amellifera_hv13_2"))+
  geom_line(aes(x=H15$simu_x,y=H15$simu_y,colour="Bee_Amellifera_hv15_1"))+
  geom_line(aes(x=Hp$simu_x,y=Hp$simu_y,colour="Bee_Amellifera_wild_1"))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Species Diversity (q=2)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,12))+
  scale_color_manual(values=c("#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p3)
dev.off()

q = "0"
B3 = run_ModelFitting("PGcomcol3_Bimp",q,type)
B4a = run_ModelFitting("PGcomcol4a_Bimp",q,type)
B4b = run_ModelFitting("PGcomcol4b_Bimp",q,type)
pdf("Bumble_TaxonHill_0.pdf")
p4 = ggplot()+
  geom_point((aes(x=B3$x,y=B3$y,colour="Bee_Bimpatiens_hv3_1")))+
  geom_point(aes(x=B4a$x,y=B4a$y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_point(aes(x=B4b$x,y=B4b$y,colour="Bee_Bimpatiens_hv4_2"))+
  geom_line(aes(x=B3$simu_x,y=B3$simu_y,colour="Bee_Bimpatiens_hv3_1"))+
  geom_line(aes(x=B4a$simu_x,y=B4a$simu_y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_line(aes(x=B4b$simu_x,y=B4b$simu_y,colour="Bee_Bimpatiens_hv4_2"))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=0)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,180))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"))
print(p4)
dev.off()

q = "1"
B3 = run_ModelFitting("PGcomcol3_Bimp",q,type)
B4a = run_ModelFitting("PGcomcol4a_Bimp",q,type)
B4b = run_ModelFitting("PGcomcol4b_Bimp",q,type)
pdf("Bumble_TaxonHill_1.pdf")
p5 = ggplot()+
  geom_point((aes(x=B3$x,y=B3$y,colour="Bee_Bimpatiens_hv3_1")))+
  geom_point(aes(x=B4a$x,y=B4a$y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_point(aes(x=B4b$x,y=B4b$y,colour="Bee_Bimpatiens_hv4_2"))+
  geom_line(aes(x=B3$simu_x,y=B3$simu_y,colour="Bee_Bimpatiens_hv3_1"))+
  geom_line(aes(x=B4a$simu_x,y=B4a$simu_y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_line(aes(x=B4b$simu_x,y=B4b$simu_y,colour="Bee_Bimpatiens_hv4_2"))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=1)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,22))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"))
print(p5)
dev.off()

q = "2"
B3 = run_ModelFitting("PGcomcol3_Bimp",q,type)
B4a = run_ModelFitting("PGcomcol4a_Bimp",q,type)
B4b = run_ModelFitting("PGcomcol4b_Bimp",q,type)
pdf("Bumble_TaxonHill_2.pdf")
p6 = ggplot()+
  geom_point((aes(x=B3$x,y=B3$y,colour="Bee_Bimpatiens_hv3_1")))+
  geom_point(aes(x=B4a$x,y=B4a$y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_point(aes(x=B4b$x,y=B4b$y,colour="Bee_Bimpatiens_hv4_2"))+
  geom_line(aes(x=B3$simu_x,y=B3$simu_y,colour="Bee_Bimpatiens_hv3_1"))+
  geom_line(aes(x=B4a$simu_x,y=B4a$simu_y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_line(aes(x=B4b$simu_x,y=B4b$simu_y,colour="Bee_Bimpatiens_hv4_2"))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=2)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,12))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"))
print(p6)
dev.off()

q = "0"
Fl = run_ModelFitting("LF_F18",q,type)
pdf("Flower_TaxonHill_0.pdf")
p7 = ggplot()+
  geom_point((aes(x=Fl$x,y=Fl$y,colour="Flower_eDNA")))+
  geom_line(aes(x=Fl$simu_x,y=Fl$simu_y,colour="Flower_eDNA"))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=0)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        #legend.text=element_text(size=15,face="bold"),
        #legend.title=element_text(size=15,face="bold"),
        legend.position="none",
        plot.margin=unit(c(5.5, 230, 5.5, 5.5),"points"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,1))+
  scale_y_continuous(expand = c(0,0),limits = c(0,180))+
  scale_color_manual(values=c("#00CC00"))
print(p7)
dev.off()

q = "1"
Fl = run_ModelFitting("LF_F18",q,type)
pdf("Flower_TaxonHill_1.pdf")
p8 = ggplot()+
  geom_point((aes(x=Fl$x,y=Fl$y,colour="Flower_eDNA")))+
  geom_line(aes(x=Fl$simu_x,y=Fl$simu_y,colour="Flower_eDNA"))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=1)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        # legend.text=element_text(size=15,face="bold"),
        # legend.title=element_text(size=15,face="bold"),
        legend.position="none",
        plot.margin=unit(c(5.5, 230, 5.5, 5.5),"points"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,1))+
  scale_y_continuous(expand = c(0,0),limits = c(0,22))+
  scale_color_manual(values=c("#00CC00"))
print(p8)
dev.off()

q = "2"
Fl = run_ModelFitting("LF_F18",q,type)
pdf("Flower_TaxonHill_2.pdf")
p9 = ggplot()+
  geom_point((aes(x=Fl$x,y=Fl$y,colour="Flower_eDNA")))+
  geom_line(aes(x=Fl$simu_x,y=Fl$simu_y,colour="Flower_eDNA"))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Species diversity (q=2)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        # legend.text=element_text(size=15,face="bold"),
        # legend.title=element_text(size=15,face="bold"),
        legend.position="none",
        plot.margin=unit(c(5.5, 230, 5.5, 5.5),"points"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,1))+
  scale_y_continuous(expand = c(0,0),limits = c(0,12))+
  scale_color_manual(values=c("#00CC00"))
print(p9)
dev.off()

type = "Function"
q = "0"
H13_2 = run_ModelFitting("PGnos_high_hv13-2",q,type)
H15 = run_ModelFitting("PGnos_inter_hv15",q,type)
Hp = run_ModelFitting("PGpollen_fresh",q,type)
pdf("Honey_FunctionHill_0.pdf")
p10 = ggplot()+
  geom_point((aes(x=H13_2$x,y=H13_2$y,colour="Bee_Amellifera_hv13_2")))+
  geom_point(aes(x=H15$x,y=H15$y,colour="Bee_Amellifera_hv15_1"))+
  geom_point(aes(x=Hp$x,y=Hp$y,colour="Bee_Amellifera_wild_1"))+
  geom_line(aes(x=H13_2$simu_x,y=H13_2$simu_y,colour="Bee_Amellifera_hv13_2"))+
  geom_line(aes(x=H15$simu_x,y=H15$simu_y,colour="Bee_Amellifera_hv15_1"))+
  geom_line(aes(x=Hp$simu_x,y=Hp$simu_y,colour="Bee_Amellifera_wild_1"))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=0)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,9000))+
  scale_color_manual(values=c("#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p10)
dev.off()

q = "1"
H13_2 = run_ModelFitting("PGnos_high_hv13-2",q,type)
H15 = run_ModelFitting("PGnos_inter_hv15",q,type)
Hp = run_ModelFitting("PGpollen_fresh",q,type)
pdf("Honey_FunctionHill_1.pdf")
p11 = ggplot()+
  geom_point((aes(x=H13_2$x,y=H13_2$y,colour="Bee_Amellifera_hv13_2")))+
  geom_point(aes(x=H15$x,y=H15$y,colour="Bee_Amellifera_hv15_1"))+
  geom_point(aes(x=Hp$x,y=Hp$y,colour="Bee_Amellifera_wild_1"))+
  geom_line(aes(x=H13_2$simu_x,y=H13_2$simu_y,colour="Bee_Amellifera_hv13_2"))+
  geom_line(aes(x=H15$simu_x,y=H15$simu_y,colour="Bee_Amellifera_hv15_1"))+
  geom_line(aes(x=Hp$simu_x,y=Hp$simu_y,colour="Bee_Amellifera_wild_1"))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=1)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,2000))+
  scale_color_manual(values=c("#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p11)
dev.off()

q = "2"
H13_2 = run_ModelFitting("PGnos_high_hv13-2",q,type)
H15 = run_ModelFitting("PGnos_inter_hv15",q,type)
Hp = run_ModelFitting("PGpollen_fresh",q,type)
pdf("Honey_FunctionHill_2.pdf")
p12 = ggplot()+
  geom_point((aes(x=H13_2$x,y=H13_2$y,colour="Bee_Amellifera_hv13_2")))+
  geom_point(aes(x=H15$x,y=H15$y,colour="Bee_Amellifera_hv15_1"))+
  geom_point(aes(x=Hp$x,y=Hp$y,colour="Bee_Amellifera_wild_1"))+
  geom_line(aes(x=H13_2$simu_x,y=H13_2$simu_y,colour="Bee_Amellifera_hv13_2"))+
  geom_line(aes(x=H15$simu_x,y=H15$simu_y,colour="Bee_Amellifera_hv15_1"))+
  geom_line(aes(x=Hp$simu_x,y=Hp$simu_y,colour="Bee_Amellifera_wild_1"))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Function Diversity (q=2)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,1200))+
  scale_color_manual(values=c("#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p12)
dev.off()

q = "0"
B3 = run_ModelFitting("PGcomcol3_Bimp",q,type)
B4a = run_ModelFitting("PGcomcol4a_Bimp",q,type)
B4b = run_ModelFitting("PGcomcol4b_Bimp",q,type)
pdf("Bumble_FunctionHill_0.pdf")
p13 = ggplot()+
  geom_point((aes(x=B3$x,y=B3$y,colour="Bee_Bimpatiens_hv3_1")))+
  geom_point(aes(x=B4a$x,y=B4a$y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_point(aes(x=B4b$x,y=B4b$y,colour="Bee_Bimpatiens_hv4_2"))+
  geom_line(aes(x=B3$simu_x,y=B3$simu_y,colour="Bee_Bimpatiens_hv3_1"))+
  geom_line(aes(x=B4a$simu_x,y=B4a$simu_y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_line(aes(x=B4b$simu_x,y=B4b$simu_y,colour="Bee_Bimpatiens_hv4_2"))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=0)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,9000))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"))
print(p13)
dev.off()

q = "1"
B3 = run_ModelFitting("PGcomcol3_Bimp",q,type)
B4a = run_ModelFitting("PGcomcol4a_Bimp",q,type)
B4b = run_ModelFitting("PGcomcol4b_Bimp",q,type)
pdf("Bumble_FunctionHill_1.pdf")
p14 = ggplot()+
  geom_point((aes(x=B3$x,y=B3$y,colour="Bee_Bimpatiens_hv3_1")))+
  geom_point(aes(x=B4a$x,y=B4a$y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_point(aes(x=B4b$x,y=B4b$y,colour="Bee_Bimpatiens_hv4_2"))+
  geom_line(aes(x=B3$simu_x,y=B3$simu_y,colour="Bee_Bimpatiens_hv3_1"))+
  geom_line(aes(x=B4a$simu_x,y=B4a$simu_y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_line(aes(x=B4b$simu_x,y=B4b$simu_y,colour="Bee_Bimpatiens_hv4_2"))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=1)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,2000))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"))
print(p14)
dev.off()

q = "2"
B3 = run_ModelFitting("PGcomcol3_Bimp",q,type)
B4a = run_ModelFitting("PGcomcol4a_Bimp",q,type)
B4b = run_ModelFitting("PGcomcol4b_Bimp",q,type)
pdf("Bumble_FunctionHill_2.pdf")
p15 = ggplot()+
  geom_point((aes(x=B3$x,y=B3$y,colour="Bee_Bimpatiens_hv3_1")))+
  geom_point(aes(x=B4a$x,y=B4a$y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_point(aes(x=B4b$x,y=B4b$y,colour="Bee_Bimpatiens_hv4_2"))+
  geom_line(aes(x=B3$simu_x,y=B3$simu_y,colour="Bee_Bimpatiens_hv3_1"))+
  geom_line(aes(x=B4a$simu_x,y=B4a$simu_y,colour="Bee_Bimpatiens_hv4_1"))+
  geom_line(aes(x=B4b$simu_x,y=B4b$simu_y,colour="Bee_Bimpatiens_hv4_2"))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=2)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        legend.text=element_text(size=15,face="bold"),
        legend.title=element_text(size=15,face="bold"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,1200))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"))
print(p15)
dev.off()

q = "0"
Fl = run_ModelFitting("LF_F18",q,type)
pdf("Flower_FunctionHill_0.pdf")
p16 = ggplot()+
  geom_point((aes(x=Fl$x,y=Fl$y,colour="Flower_eDNA")))+
  geom_line(aes(x=Fl$simu_x,y=Fl$simu_y,colour="Flower_eDNA"))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=0)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        #legend.text=element_text(size=15,face="bold"),
        #legend.title=element_text(size=15,face="bold"),
        legend.position="none",
        plot.margin=unit(c(5.5, 230, 5.5, 5.5),"points"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,1))+
  scale_y_continuous(expand = c(0,0),limits = c(0,9000))+
  scale_color_manual(values=c("#00CC00"))
print(p16)
dev.off()

q = "1"
Fl = run_ModelFitting("LF_F18",q,type)
pdf("Flower_FunctionHill_1.pdf")
p17 = ggplot()+
  geom_point((aes(x=Fl$x,y=Fl$y,colour="Flower_eDNA")))+
  geom_line(aes(x=Fl$simu_x,y=Fl$simu_y,colour="Flower_eDNA"))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=1)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        # legend.text=element_text(size=15,face="bold"),
        # legend.title=element_text(size=15,face="bold"),
        legend.position="none",
        plot.margin=unit(c(5.5, 230, 5.5, 5.5),"points"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,1))+
  scale_y_continuous(expand = c(0,0),limits = c(0,2000))+
  scale_color_manual(values=c("#00CC00"))
print(p17)
dev.off()

q = "2"
Fl = run_ModelFitting("LF_F18",q,type)
pdf("Flower_FunctionHill_2.pdf")
p18 = ggplot()+
  geom_point((aes(x=Fl$x,y=Fl$y,colour="Flower_eDNA")))+
  geom_line(aes(x=Fl$simu_x,y=Fl$simu_y,colour="Flower_eDNA"))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Function diversity (q=2)")+
  theme_classic()+
  theme(axis.title=element_text(size=20,face="bold"),
        axis.text=element_text(size=20,face="bold"),
        # legend.text=element_text(size=15,face="bold"),
        # legend.title=element_text(size=15,face="bold"),
        legend.position="none",
        plot.margin=unit(c(5.5, 230, 5.5, 5.5),"points"),
        title=element_text(size=20,face="bold"))+
  scale_x_continuous(expand = c(0,0),limits = c(0,1))+
  scale_y_continuous(expand = c(0,0),limits = c(0,1200))+
  scale_color_manual(values=c("#00CC00"))
print(p18)
dev.off()
