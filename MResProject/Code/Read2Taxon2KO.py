import os
import sys
import numpy as np
import pandas as pd
# sys.path.append('/rds/general/user/cl3820/home/taxomias')
import taxomias as tx
import re

args = sys.argv

sample = args[1]
percent = args[2]
print(args)

dire = sample+"/"+percent+"_1/FunctionAnnotation"

# Merge taxon and abundance table of CDS
CDS_quantify = pd.read_table(dire+"/CDSquantify.txt",sep="\t",header=None) #fileds: nucleotide ID, start, end, name, score, strand, read count, read length, seq length, coverage

CDS_txid = pd.read_table(dire+"/CDS_info.txt",sep="\t",header=None) # fileds: nucleotide ID, start, end, name, score, strand, assembly ID, txid

CDS_txid.columns = ["SeqID","start","end","CDSname","score","strand","AssemblyID","txid"]
CDS_txid["ReadCount"] = CDS_quantify[6]
CDS_txid["Coverage"] = CDS_quantify[9]

CDS_txid = CDS_txid[CDS_txid["ReadCount"]!=0]
CDS_txid.to_csv(dire+"/CDS_txid_quantify.txt",sep="\t",index=False,header=True) # header: "SeqID","start","end","CDSname","score","strand","AssemblyID","txid", "ReadCount", "Coverage"

#########################################################################
#########################################################################
### Abundance of taxa identified
#########################################################################
#########################################################################
CDS = pd.read_table(dire+"/CDS_txid_quantify.txt",sep="\t",header=0) # header: "SeqID","start","end","CDSname","score","strand","AssemblyID","txid", "ReadCount", "Coverage"
read = pd.read_table(dire+"/../FirstRound/taxon_ID.txt",sep="\t",header=None) # fields: rank (S,G), txid, read count (pair)

txid_CDSquantify = CDS["ReadCount"].groupby(CDS["txid"]).sum() # read count

txid = CDS["txid"].values.tolist()+read[1].values.tolist()
txid = list(set(txid))

path = []
rank = []
for i in txid:
    rank.append(tx.RankByTaxid(i))
    path_id = tx.PathByTaxid(i)
    path_name = ""
    for j in path_id:
        path_name = path_name+"["+tx.RankByTaxid(j)+"]"+" "+tx.NameByTaxid(j)+";"
    path.append(path_name)

txid2path = pd.DataFrame({"txid":txid,"path":path})
txid2CDSquantify = pd.DataFrame({"txid":txid_CDSquantify.index,"CDS":txid_CDSquantify.values})
txid2readquantify = pd.DataFrame({"txid":read[1].values,"Read":2*read[2].values})

f = pd.merge(txid2CDSquantify,txid2readquantify,on="txid",how="outer")
f = pd.merge(f,txid2path,on="txid",how="outer")
f = f.fillna(0)
f["TotalCount"] = f["CDS"]+f["Read"]

f.to_csv(dire+"/TaxonQuantification.txt",header=True,sep="\t",index=False) # header: txid, CDS, Read, path, TotalCount

#########################################################################
#########################################################################
### Abundance of taxa at each rank
#########################################################################
#########################################################################
data = pd.read_table(dire+"/TaxonQuantification.txt",header=0,sep="\t") # header: txid, CDS, Read, path, TotalCount

groups = []
for index in data.index:
    row = data.loc[index,]
    path = row["path"]
    if "[superkingdom] Viruses;" in path:
        groups.append("Viruses")
    elif "[superkingdom] Bacteria;" in path:
        groups.append("Bacteria")
    elif "[kingdom] Viridiplantae;" in path:
        groups.append("Plants")
    elif "[kingdom] Fungi;" in path:
        groups.append("Fungi")
    elif "[phylum] Arthropoda;" in path:
        groups.append("Arthropods")
    else:
        groups.append("Others")

data["Group"] = groups

data.to_csv(dire+"/TaxonQuantification.txt",header=True,sep="\t",index=False)

data = pd.read_table(dire+"/TaxonQuantification.txt",header=0,sep="\t") # header: txid, CDS, Read, path, TotalCount, Group


def RankQuantify(rank):
    """
    This function take taxonomic rank (i.e. phylum, class) as argument.

    OUTPUT:
    outDir+"/"+sample_percent+"/FunctionAnnotation/"+rank+"Quantify.txt" (tabular, "rank" can be phylum, class, order, family, genus, species, header: Name, CDS, Read, TotalCount, Rel_Abundance)
    """
    pattern = "\["+rank+"\] [A-Za-z <>.0-9]*;"
    names = []
    for path in data["path"].values:
        name = re.findall(pattern,path)
        if name == []:
            names.append(0)
        else:
            for j in name:
                j = j.split("]")[1][1:-1]
                names.append(j)
                
    Rankq = pd.DataFrame({"Name":names})
    Rankq["Group"] = data["Group"].values
    Rankq["CDS"] = data["CDS"].values
    Rankq["Read"] = data["Read"].values
    Rankq["TotalCount"] = data["TotalCount"]
    Rankq = Rankq[Rankq["Name"]!=0]
 

    CDS = Rankq["CDS"].groupby(Rankq["Name"]).sum()
    Read = Rankq["Read"].groupby(Rankq["Name"]).sum()
    Total = Rankq["TotalCount"].groupby(Rankq["Name"]).sum()

    out = pd.DataFrame({"Name":CDS.index.tolist(),"CDS":CDS.values.tolist(),"Read":Read.values.tolist(),"TotalCount":Total.values.tolist()})
    out["Rel_Abundance"] = out["TotalCount"]/out["TotalCount"].sum()

    Group = []
    for name in out["Name"].values:
        group = Rankq[Rankq["Name"]==name]["Group"].tolist()[0]
        Group.append(group)
    out["Group"] = Group

    out.to_csv(dire+"/"+rank+"Quantify.txt",header=True,index=False,sep="\t")
    return 0

RankQuantify("phylum")
RankQuantify("class")
RankQuantify("order")
RankQuantify("family")
RankQuantify("genus")
RankQuantify("species")