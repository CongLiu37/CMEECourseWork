"""
DESCRIPTION:
This script conducts pathway inference.

DEPENDENCIES:
Python modules: os, sys, numpy, pandas
Other softwares: MinPath

ARGUMENTS:
args[1]:  <directory> output directory
args[2]: <float> subsampling proportion

OUTPUT:
Seen in annotations

Note:
Take output of IntegratedPipeline.py as input
"""

import os
import sys
import numpy as np
import pandas as pd

args = sys.argv

sample = args[1]
percent = args[2]

dire = sample+"/"+percent+"_1/FunctionAnnotation"

KO_abundance = pd.read_table(dire+"/KO_quantify.txt",sep="\t",header=0)
KO_term = pd.read_table("MinPath/data/KEGG-family.txt",sep="\t",header=None)
KO_term.columns = ["KEGG_KO","Description"]

KO_abundance_term = pd.merge(KO_abundance,KO_term,on="KEGG_KO",how="left")
# output
KO_abundance_term.to_csv(dire+"/KO_Abundance_Description.txt",header=True,sep="\t",index=False)

Txid_KO = pd.read_table(dire+"/Txid_KO.txt",sep="\t",header=None)
Txid_KO = Txid_KO.drop(index=0)
#output
Txid_KO.to_csv(dire+"/Txid_KO_NoHeader.txt",header=False,sep="\t",index=False)

# pathway inference
cmd = "python"+" "+"/rds/general/user/cl3820/home/MinPath/MinPath.py"+" "+"-ko"+" "+dire+"/Txid_KO_NoHeader.txt"+" "+"-report"+" "+dire+"/Pathway.txt"+" "+"-details"+" "+dire+"/PathwayDetails.txt"
os.system(cmd)

Pathway = pd.read_table(dire+"/Pathway.txt",sep="  ",header=None)

def ConvertData(series):
    """
    Wrangle output of MinPath
    """
    PathwayID = "map"+series[0].split(" ")[1]
    Naive = series[1].split(" ")[1]
    MinPath = series[2].split(" ")[1]
    TotalGene = series[4]
    GeneFound = series[6]
    Cov = GeneFound/TotalGene
    Description = series[8]
    dic = {"PathwayID":PathwayID,"Naive":Naive,"MinPath":MinPath,"TotalGene":TotalGene,"GeneFound":GeneFound,"Coverage":Cov,"Description":Description}
    ret = pd.Series(dic)
    return ret

Pathway = Pathway.apply(func=ConvertData,axis=1).sort_values(by="Coverage",axis=0,ascending=False)

# output
Pathway.to_csv(dire+"/PathwaySummary.txt",header=True,sep="\t",index=False)