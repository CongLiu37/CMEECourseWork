"""
DESCRIPTION:
This script computes Hill numbers of order 0, 1, 2 for inventories of species/KOs

DEPENDENCIES:
Python modules: os, re, sys, pandas, numpy, math

ARGUMENTS:

OUTPUT:
Seen in annotations

Note:
Take output of IntegratedPipeline.py as input
"""

import os
import re
import sys
import pandas as pd
import numpy as np
import math
e = math.e

Type = sys.argv[1] # Taxon/Function
# Sample names
samples = ["LF_F18","PGcomcol3_Bimp","PGcomcol4a_Bimp","PGcomcol4b_Bimp","PGnos_high_hv13-1","PGnos_high_hv13-2","PGnos_inter_hv15","PGpollen_fresh"]

# Rarefaction percentage
percent = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]

# Sample name to raw read number
RawReadCount = {"LF_F18":1443107,"PGcomcol3_Bimp":63973750,"PGcomcol4a_Bimp":58988182,"PGcomcol4b_Bimp":54955553,"PGnos_high_hv13-1":1104861,"PGnos_high_hv13-2":56836899,"PGnos_inter_hv15":63159968,"PGpollen_fresh":58113227}

# Sample name to clean read number
CleanReadCount = {"LF_F18":882436,"PGcomcol3_Bimp":53612702,"PGcomcol4a_Bimp":48426748,"PGcomcol4b_Bimp":45805759,"PGnos_high_hv13-1":842095,"PGnos_high_hv13-2":35282101,"PGnos_inter_hv15":45059211,"PGpollen_fresh":44466776}

# Sample name to metagenomic (non-host) read number
MetagenomicReadCount = {"LF_F18":882436,"PGcomcol3_Bimp":5300592,"PGcomcol4a_Bimp":3557052,"PGcomcol4b_Bimp":4618023,"PGnos_high_hv13-1":665507,"PGnos_high_hv13-2":10413704,"PGnos_inter_hv15":38837759,"PGpollen_fresh":17014144}

def HillDiversity(vector,q):
    """
    Compute Hill number.

    INPUT:
    q: order of Hill number
    vector: iterative and numeric subject represents relative abundances of species
    """
    if q == 1:
        ShannonIndex = 0
        for p in vector:
            ShannonIndex = ShannonIndex-p*math.log(p)
        D = math.exp(ShannonIndex)
    else:
        index = 0
        for p in vector:
            index = index+math.pow(p,q)
        D = math.pow(index,1.0/(1.0-q))
    return(D)

output = Type+"_HillDiversity.txt"

if os.path.exists(output):
     os.system("rm "+output)

os.system("touch "+output)

header = "Sample\tRawRead\tCleanRead\tMetagenomicRead\tSubsamplePercent\tAssemblySpeciesRichness\tSpeciesRichness\t"

for q in ["0","1","2"]:
    header = header+"Hill_"+q+"\t"

header = header[:-1]
os.system("echo \""+header+"\""+" "+">> "+output)

for Sample in samples:
     for SubsamplePercent in percent:
        # Sample 
        # RawRead 
        # CleanRead 
        # MetagenomicRead 
        # SubsamplePercent
        string = Sample+"\t"+str(RawReadCount[Sample])+"\t"+str(CleanReadCount[Sample])+"\t"+str(MetagenomicReadCount[Sample])+"\t"+str(SubsamplePercent)+"\t"

        Assembly_ID = pd.read_table(Sample+"/"+str(SubsamplePercent)+"_1/PreAssembly/taxon_ID.txt",sep="\t",header=None) # fields: Rank, txid, number
        TaxonQuantify = pd.read_table(Sample+"/"+str(SubsamplePercent)+"_1/FunctionAnnotation/TaxonQuantification.txt",sep="\t",header=0) # headers: txid, CDS, Read, path, TotalCount
        speciesquantify = pd.read_table(Sample+"/"+str(SubsamplePercent)+"_1/FunctionAnnotation/speciesQuantify.txt",header=0,sep="\t") # Name", "CDS", "Read", "TotalCount", "Rel_Abundance"

        # AssemblySpeciesRichness
        # SpeciesRichness
        patternS = "\[species\] [A-Za-z <>.0-9]*;"
        AssemblySpeciesName = []
        SpeciesName = []
        for index in TaxonQuantify.index:
            row = TaxonQuantify.loc[index,]
            txid = row["txid"]
            path = row["path"]
            species = re.findall(patternS,str(path))
            if species != []:
                SpeciesName = SpeciesName+species
                if txid in Assembly_ID[1].values:
                    AssemblySpeciesName = AssemblySpeciesName+species

        AssemblySpeciesRichness = len(set(AssemblySpeciesName))
        SpeciesRichness = len(set(SpeciesName))

        string = string +str(AssemblySpeciesRichness)+"\t"+str(SpeciesRichness)+"\t"

        if Type=="Taxon":
            species_vector = speciesquantify["TotalCount"].values
            species_vector = species_vector/species_vector.sum()
            
            # "Hill_"+str(q)+"\t"
            for q in [0,1,2]:
                Hill = HillDiversity(species_vector,q)
                string = string + str(Hill)+"\t"

        if Type=="Function":
            KO_quantify = pd.read_table(Sample+"/"+str(SubsamplePercent)+"_1/FunctionAnnotation/KO_quantify.txt",sep="\t",header=0)

            KO_vector = KO_quantify["ReadCount"].values
            KO_vector = KO_vector/KO_vector.sum()

            # "Hill_"+str(q)+"\t"
            for q in [0,1,2]:
                Hill = HillDiversity(KO_vector,q)
                string = string + str(Hill)+"\t"

        string = string[:-1]
        os.system("echo \""+string+"\""+" "+">> "+output)


