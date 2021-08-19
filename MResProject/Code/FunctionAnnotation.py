import os
import sys
import pandas as pd
import numpy as np
import re

args = sys.argv

sample = args[1]
percent = args[2]
print(sample)
print(percent)

dire = "/rds/general/user/cl3820/home/Annotations/"+sample+"/"+percent+"_1/FunctionAnnotation"

#########################################################################
#########################################################################
### Taxon and Function annotation of each read/CDS
#########################################################################
#########################################################################
read2txid = pd.read_table(dire+"/read_txid.txt",header=None,sep="\t") # readID, rank, txid
CDS2txid = pd.read_table(dire+"/CDS_txid_quantify.txt",header=0,sep="\t")
txid2path = pd.read_table(dire+"/TaxonQuantification.txt",header=0,sep="\t")

def CDSName(series):
    series["CDSname"] = str(series["SeqID"])+":"+str(series["start"])+"-"+str(series["end"])+"("+str(series["strand"])+")"
    return series
CDS2txid = CDS2txid.apply(func=CDSName,axis=1,raw=False)


def IDConvert(series):
    if series["SeqType"]=="forward":
        series["SeqID"] = str(series["SeqID"])+"_forward"
        return series
    elif series["SeqType"]=="reverse":
        series["SeqID"] = str(series["SeqID"])+"_reverse"
        return series
    else:
        return series

def MergeAnnotation(SeqType):

    Annotations = pd.read_table(dire+"/"+SeqType+"_annotation.txt.emapper.annotations",header=0,sep="\t")

    Seq2KEGG = pd.DataFrame({"SeqID":Annotations["#query"],"KEGG_KO":Annotations["KEGG_ko"]})
    
    if SeqType=="CDS":
        Seq2Taxon = pd.DataFrame({"SeqID":CDS2txid["CDSname"],"txid":CDS2txid["txid"],"ReadCount":CDS2txid["ReadCount"]})
    else:
        Seq2Taxon = pd.DataFrame({"SeqID":read2txid[0],"txid":read2txid[2],"ReadCount":np.repeat(np.array([1]),read2txid[0].size)})
    
    Taxon2Path = pd.DataFrame({"txid":txid2path["txid"],"TxPath":txid2path["path"],"TxGroup":txid2path["Group"]})

    ret = pd.merge(Seq2KEGG,Seq2Taxon,on="SeqID",how="outer")
    ret = pd.merge(ret,Taxon2Path,on="txid",how="left")
    ret["SeqType"] = np.repeat(np.array([SeqType]),ret["SeqID"].size)

    ret = ret.apply(func=IDConvert,axis=1,raw=False)

    return ret

CDS = MergeAnnotation("CDS")
forward = MergeAnnotation("forward")
reverse = MergeAnnotation("reverse")

final = pd.concat([CDS,forward,reverse],axis=0,join="outer")

if os.path.exists(dire+"/SeqAnnotations.txt"):
    os.system("rm "+dire+"/SeqAnnotations.txt")

final.to_csv(dire+"/SeqAnnotations.txt",header=True,sep="\t",index=False)

