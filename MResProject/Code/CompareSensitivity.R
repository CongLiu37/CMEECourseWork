library(ggplot2)

HillDiversity = read.table("Taxon_HillDiversity.txt",sep="\t",header=TRUE,row.names = NULL)
HillDiversity = subset(HillDiversity,Group=="All")

LF_F18 = subset(HillDiversity,HillDiversity$Sample=="LF_F18")
PGcomcol3_Bimp = subset(HillDiversity,HillDiversity$Sample=="PGcomcol3_Bimp")
PGcomcol4a_Bimp = subset(HillDiversity,HillDiversity$Sample=="PGcomcol4a_Bimp")
PGcomcol4b_Bimp = subset(HillDiversity,HillDiversity$Sample=="PGcomcol4b_Bimp")
PGnos_high_hv13_1 = subset(HillDiversity,HillDiversity$Sample=="PGnos_high_hv13-1")
PGnos_high_hv13_2 = subset(HillDiversity,HillDiversity$Sample=="PGnos_high_hv13-2")
PGnos_inter_hv15 = subset(HillDiversity,HillDiversity$Sample=="PGnos_inter_hv15")
PGpollen_fresh = subset(HillDiversity,HillDiversity$Sample=="PGpollen_fresh")

pdf("ExtraSpecies_Bumble.pdf")
p1 = ggplot()+
  geom_point(size=2,(aes(x=PGcomcol3_Bimp$CleanRead*PGcomcol3_Bimp$SubsamplePercent/1e+6,
                         y=(PGcomcol3_Bimp$SpeciesRichness-PGcomcol3_Bimp$AssemblySpeciesRichness)/PGcomcol3_Bimp$AssemblySpeciesRichness,
                         colour="PGcomcol3_Bimp")))+
  geom_point(size=2,(aes(x=PGcomcol4a_Bimp$CleanRead*PGcomcol4a_Bimp$SubsamplePercent/1e+6,
                         y=(PGcomcol4a_Bimp$SpeciesRichness-PGcomcol4a_Bimp$AssemblySpeciesRichness)/PGcomcol4a_Bimp$AssemblySpeciesRichness,
                         colour="PGcomcol4a_Bimp")))+
  geom_point(size=2,(aes(x=PGcomcol4b_Bimp$CleanRead*PGcomcol4b_Bimp$SubsamplePercent/1e+6,
                         y=(PGcomcol4b_Bimp$SpeciesRichness-PGcomcol4b_Bimp$AssemblySpeciesRichness)/PGcomcol4b_Bimp$AssemblySpeciesRichness,
                         colour="PGcomcol4b_Bimp")))+
  labs(colour="Sample",title="Bumble bee")+
  xlab("Read Depth (million)")+
  ylab("Growth rate of detected species richness")+
  theme_classic()+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,1))+
  scale_color_manual(values=c("#FF3399","#FF3300","#990000"),
                     labels=c("Bee_Bimpatiens_hv3_1","Bee_Bimpatiens_hv4_1","Bee_Bimpatiens_hv4_2"))
print(p1)
dev.off()
#
pdf("ExtraSpecies_Honey.pdf")
p2 = ggplot()+
  # geom_point(size=2,(aes(x=PGnos_high_hv13_1$CleanRead*PGnos_high_hv13_1$SubsamplePercent/1e+6,
  #                        y=(PGnos_high_hv13_1$SpeciesRichness-PGnos_high_hv13_1$AssemblySpeciesRichness)/PGnos_high_hv13_1$AssemblySpeciesRichness,
  #                        colour="PGnos_high_hv13_1")))+
  geom_point(size=2,(aes(x=PGnos_high_hv13_2$CleanRead*PGnos_high_hv13_2$SubsamplePercent/1e+6,
                         y=(PGnos_high_hv13_2$SpeciesRichness-PGnos_high_hv13_2$AssemblySpeciesRichness)/PGnos_high_hv13_2$AssemblySpeciesRichness,
                         colour="PGnos_high_hv13_2")))+
  geom_point(size=2,(aes(x=PGnos_inter_hv15$CleanRead*PGnos_inter_hv15$SubsamplePercent/1e+6,
                         y=(PGnos_inter_hv15$SpeciesRichness-PGnos_inter_hv15$AssemblySpeciesRichness)/PGnos_inter_hv15$AssemblySpeciesRichness,
                         colour="PGnos_inter_hv15")))+
  geom_point(size=2,(aes(x=PGpollen_fresh$CleanRead*PGpollen_fresh$SubsamplePercent/1e+6,
                         y=(PGpollen_fresh$SpeciesRichness-PGpollen_fresh$AssemblySpeciesRichness)/PGpollen_fresh$AssemblySpeciesRichness,
                         colour="PGpollen_fresh")))+
  labs(colour="Sample",title="Honey bee")+
  xlab("Read Depth (million)")+
  ylab("Growth rate of detected species richness")+
  theme_classic()+
  scale_x_continuous(expand = c(0,0),limits = c(0,65))+
  scale_y_continuous(expand = c(0,0),limits = c(0,1))+
  scale_color_manual(values=c("#000099","#33FFFF","#0066CC","#6600FF"),
                     labels=c("Bee_Amellifera_hv13_1","Bee_Amellifera_hv13_2","Bee_Amellifera_hv15_1","Bee_Amellifera_wild_1"))
print(p2)
dev.off()
#
pdf("ExtraSpecies_Flower.pdf")
p3 = ggplot()+
  geom_point(size=2,(aes(x=LF_F18$CleanRead*LF_F18$SubsamplePercent/1e+6,
                         y=(LF_F18$SpeciesRichness-LF_F18$AssemblySpeciesRichness)/LF_F18$AssemblySpeciesRichness,
                         colour="LF_F18")))+
  labs(colour="Sample",title="Flower")+
  xlab("Read Depth (million)")+
  ylab("Growth rate of detected species richness")+
  theme_classic()+
  scale_x_continuous(expand = c(0,0),limits = c(0,1.5))+
  scale_y_continuous(expand = c(0,0),limits = c(0,4))+
  scale_color_manual(values=c("#00CC00"),labels=c("Flower_eDNA"))
print(p3)
dev.off()