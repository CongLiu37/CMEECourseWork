import os
import sys
import pandas as pd
import numpy as np

args = sys.argv

# Absolute path to non-host data
# /rds/general/user/cl3820/home/Non_Host_data/<SampleName>*
rawData1 = args[1] 
rawData2 = args[2]

# Absolute path to output directory, named after sample
# e.g. /rds/general/user/cl3820/ephemeral/Rarefaction/PGcomcol3_Bimp
outDir = args[3]

sample = args[4] # Sample Name
threads = str(args[5]) # 32
sample_percent = str(args[6]) # What percent of the original dataset is subsampled
repeat = str(args[7]) # int

sample_percent = sample_percent+"_"+repeat # e.g. 0.1_1 (0.1: subsampling percent; 1: repeat 1)

print("#########################################################################")
print("#########################################################################")
print(args)
#########################################################################
#########################################################################
### Subsampling
#########################################################################
#########################################################################
if not os.path.exists(outDir):
    print("Make directory: "+outDir)
    os.system("mkdir "+outDir)
if not os.path.exists(outDir+"/"+sample_percent):
    print("Make directory: "+outDir+"/"+sample_percent)
    os.system("mkdir "+outDir+"/"+sample_percent)

if sample_percent.split("_")[0] != "1":
    Data1 = outDir+"/"+sample_percent+"/"+sample+"_"+sample_percent.split("_")[0]+"_1.fq"
    Data2 = outDir+"/"+sample_percent+"/"+sample+"_"+sample_percent.split("_")[0]+"_2.fq"
    if not os.path.exists(Data1) or not os.path.exists(Data2):
        # BBmap: Subsample metagenomic mate pairs
        # INPUT: rawData1
        #        rawData2
        # OUTPUT: Data1 = outDir+"/"+sample_percent+"/"+sample+"_"+sample_percent.split("_")[0]+"_1.fq"
        #         Data2 = outDir+"/"+sample_percent+"/"+sample+"_"+sample_percent.split("_")[0]+"_2.fq"
        cmd = "/rds/general/user/cl3820/home/anaconda3/bin/reformat.sh "+"in="+rawData1+" "+"in2="+rawData2+" "+"out="+Data1+" "+"out2="+Data2+" "+"samplerate="+sample_percent.split("_")[0]
        print("Command:")
        print(cmd)
        os.system(cmd)
        print("Done")  
else:
    # Ananlyze the whole dataset without subsampling
    Data1 = rawData1
    Data2 = rawData2
    print("Subsample percentage = 1")
    print("Analyzing the whole dataset")

#########################################################################
#########################################################################
### Assembly
#########################################################################
#########################################################################
# Clean output space
if os.path.exists(outDir+"/"+sample_percent+"/PreAssembly"):
    os.system("rm "+outDir+"/"+sample_percent+"/PreAssembly")

os.system("mkdir "+outDir+"/"+sample_percent+"/PreAssembly")
os.system("mkdir "+outDir+"/"+sample_percent+"/PreAssembly/assembly")

# SPAdes: assemble subsampled reads
# INPUT: Data1
#        Data2
# OUTPUT: outDir+"/"+sample_percent+"/PreAssembly/assembly.tar"
cmd = "/rds/general/user/cl3820/home/SPAdes-3.15.2-Linux/bin/spades.py -t"+" "+threads+" "+"-k 21,31,41,51,61,71,81,91,101 --only-assembler --meta -1 "+Data1+" -2 "+Data2+" -o "+outDir+"/"+sample_percent+"/PreAssembly/assembly"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")
# Compress outDir+"/"+sample_percent+"/PreAssembly/assembly"
cmd = "tar -cf "+outDir+"/"+sample_percent+"/PreAssembly/assembly"+".tar"+" "+outDir+"/"+sample_percent+"/PreAssembly/assembly"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

# Seqkit: Sort assembled contigs
#         One line for each sequence
# INPUT: outDir+"/"+sample_percent+"/PreAssembly/assembly/scaffolds.fasta"
# OUTPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly.fa"
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/seqkit seq -w 0 "+outDir+"/"+sample_percent+"/PreAssembly/assembly/scaffolds.fasta"+" > "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly.fa"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

# Remove contigs shorter than 500 bp
# INPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly.fa"
# OUTPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.fa"
l = []
f = open(outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly.fa","r")
for line in f:
    l.append(line.strip()) 

k_1000 = []
for i in range(0, len(l)):
    if l[i][0] == ">":
        if len(l[i+1]) >= 500:
            k_1000.append(l[i])
            k_1000.append(l[i+1])

#########################################################################
#########################################################################
### Assign assembled contigs to taxa
#########################################################################
#########################################################################
if len(k_1000) != 0: # If there is contig longer than 500 bp 
    o = open(outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.fa","w")
    for i in k_1000:
        o.write(i+"\n")
    o.close()
    
    # DIAMOND: Align contigs to nr
    # INPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.fa"
    # OUTPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.blast"
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/diamond blastx -p"+" "+threads+" "+"-d /rds/general/user/cl3820/home/nr_diamond/nr.dmnd -q "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.fa"+" --long-reads -e 1e-5 --id 50 -b 12 --top 10 --out "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.blast"+" -f 6"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")

    # MEGAN6: Assign contigs to taxa
    # INPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.blast"
    # OUTPUT: outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.rma"
    #         outDir+"/"+sample_percent+"/PreAssembly/taxon_assembly_total.txt" (Three-column tabular table: rank, taxon path, contig count)
    #         outDir+"/"+sample_percent+"/PreAssembly/taxon_ID.txt" (Three-column tabular table: rank, txid, contig count)
    cmd = "/rds/general/user/cl3820/home/megan/tools/blast2rma -i"+" "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.blast"+" -o "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.rma"+" -f BlastTab -bm BlastX --paired false -lg true -mdb /rds/general/user/cl3820/home/MEGANDatabase/megan-map-Jul2020-2.db -t 32 -ram readCount -ms 50 -me 1e-5 -mpi 50 -top 10 -supp 0"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/megan/tools/rma2info -i"+" "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.rma"+" -o "+outDir+"/"+sample_percent+"/PreAssembly/taxon_assembly_total.txt"+" "+"-c2c Taxonomy -n true -p true -r true -mro true -u false"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/megan/tools/rma2info -i"+" "+outDir+"/"+sample_percent+"/PreAssembly/"+sample+"_assembly_500bp.rma"+" -o "+outDir+"/"+sample_percent+"/PreAssembly/taxon_ID.txt"+" "+"-c2c Taxonomy -n false -p false -r true -mro true -u false"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
else:
    # Assembling failed
    print("No contigs longer than 500 bp.")
    print("Assembling failed.")

#########################################################################
#########################################################################
### Get reference genomes
#########################################################################
#########################################################################
if not os.path.exists(outDir+"/"+sample_percent+"/Genomes"):
    print("Make directory: "+outDir+"/"+sample_percent+"/Genomes")
    os.system("mkdir "+outDir+"/"+sample_percent+"/Genomes")

print("#########################################################################")
print(outDir+"/"+sample_percent+"/Genomes")

# Get species txid found from assembly
if os.path.exists(outDir+"/"+sample_percent+"/PreAssembly/taxon_ID.txt"):
    taxonID = outDir+"/"+sample_percent+"/PreAssembly/taxon_ID.txt"
    f = open(taxonID,"r")
    ID_species = []
    for line in f:
        line = line.strip().split("\t")
        if line[0] == "S":
            ID_species.append(str(line[1]))
    f.close()

    # files of paths
    total_fna = open(outDir+"/"+sample_percent+"/Genomes/total_fna_list.txt","w") # Absolute paths to fna
    gff = open(outDir+"/"+sample_percent+"/Genomes/total_gff_list.txt","w") # Absolute paths to gff
    faa = open(outDir+"/"+sample_percent+"/Genomes/total_faa_list.txt","w") # Absolute paths to faa

    for txid in ID_species:
        if os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid):
            os.system("rm -r "+outDir+"/"+sample_percent+"/Genomes/"+txid)
        if os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid+".zip"):
            os.system("rm "+outDir+"/"+sample_percent+"/Genomes/"+txid+".zip")

        # If the genomic dataset of a species has already bee downloaded, copy it to outDir+"/"+sample_percent+"/Genomes/"
        percent = float(sample_percent.split("_")[0])
        i = 0.1
        while i < percent:
            if os.path.exists(outDir+"/"+str(i)+"_"+sample_percent.split("_")[1]+"/Genomes/"+txid):
                os.system("cp -r "+outDir+"/"+str(i)+"_"+sample_percent.split("_")[1]+"/Genomes/"+txid+" "+outDir+"/"+sample_percent+"/Genomes/")
                os.system("cp "+outDir+"/"+str(i)+"_"+sample_percent.split("_")[1]+"/Genomes/"+txid+".zip"+" "+outDir+"/"+sample_percent+"/Genomes/")
                print("Dataset of "+txid+" already exists in "+outDir+"/"+str(i)+"_"+sample_percent.split("_")[1]+"/Genomes/")
                break
            else:
                i = i+0.1

        if not os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid+".zip") and not os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid):
            # Get reference genomes in RefSeq (GCF)
            os.system("/rds/general/user/cl3820/home/datasets download genome taxon "+txid+" --filename "+outDir+"/"+sample_percent+"/Genomes/"+txid+".zip"+" --exclude-rna --reference --refseq")
        if not os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid+".zip") and not os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid):
            # If no reference genomes found in RefSeq, try GenBank (GCA)
            os.system("/rds/general/user/cl3820/home/datasets download genome taxon "+txid+" --filename "+outDir+"/"+sample_percent+"/Genomes/"+txid+".zip"+" --exclude-rna --reference")
        if os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid+".zip") and not os.path.exists(outDir+"/"+sample_percent+"/Genomes/"+txid):
            # unzip genome directory
            os.system("unzip "+outDir+"/"+sample_percent+"/Genomes/"+txid+".zip"+" -d "+outDir+"/"+sample_percent+"/Genomes/"+txid)
            
        for tup in os.walk(outDir+"/"+sample_percent+"/Genomes/"+txid):
            if tup[1] == []:
                Str = []
                for i in tup[2]:
                    Str.append(os.path.splitext(i)[1])
                if ".faa" in Str:
                    for i in tup[2]:
                        file = tup[0]+"/"+i
                        if file[-3:] == "fna":
                            total_fna.write(file+"\n") # Absolute paths to fna
                        elif file[-3:] == "gff":
                            gff.write(file+"\n") # Absolute paths to gff
                        elif file[-3:] == "faa":
                            faa.write(file+"\n") # Absolute paths to faa
                else:
                    print("Unannotated genome: "+txid)
                    os.system("rm -r "+outDir+"/"+sample_percent+"/Genomes/"+txid)
                    os.system("rm "+outDir+"/"+sample_percent+"/Genomes/"+txid+".zip")
    total_fna.close()
    gff.close()
    faa.close()
print("Done")
print("#########################################################################")

#########################################################################
#########################################################################
### Fragment recruitment
#########################################################################
#########################################################################
l = ""
if os.path.exists(outDir+"/"+sample_percent+"/Genomes/total_fna_list.txt"):
    f = open(outDir+"/"+sample_percent+"/Genomes/total_fna_list.txt","r")
    for line in f:
        line = line.strip()
        l = l+line+","
    l = l[:-1]
    f.close()

if len(l) != 0:
    if not os.path.exists(outDir+"/"+sample_percent+"/Genomes/Reference.1.bt2") and not os.path.exists(outDir+"/"+sample_percent+"/Genomes/Reference.1.bt2l"):
        # Bowtie2: Build index with basename "Reference"
        # INPUT: listed in l
        # OUTPUT: outDir+"/"+sample_percent+"/Genomes/Reference.*.bt2(l)"
        cmd = "/rds/general/user/cl3820/home/anaconda3/bowtie2-build "+l+" "+outDir+"/"+sample_percent+"/Genomes/Reference"
        print("Command:")
        print(cmd)
        os.system(cmd)
        print("Done")

    # Bowtie2: Map reads to reference genomes (Index: outDir+"/"+sample_percent+"/Genomes/Reference.*.bt2(l))
    # SAMtools: Convert SAM to BAM
    # INPUT: Data1
    #        Data2
    # OUTPUT: outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam"
    cmd = "/rds/general/user/cl3820/home/anaconda3/bowtie2 --sensitive --end-to-end -p "+threads+" -x "+outDir+"/"+sample_percent+"/Genomes/Reference"+" -1 "+Data1+" -2 "+Data2+" -S "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"
    print("Command: ")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools view -@ "+threads+" -b -S "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+" > "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")

    # Remove SAM
    os.system("rm "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam")

    # SAMtools: Extract BAM of unmapped reads
    #           Convert BAM to fq
    # INPUT: outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam"
    # OUTPUT: outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped"
    #         outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped.1.fq
    #         outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped.2.fq
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools view -@ "+threads+" -u -f 12 "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam"+" > "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools fastq -1 "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped.1.fq -2 "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped.2.fq "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped"+" -@ "+threads
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")

    # Unmapped reads
    fq1 = outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped.1.fq"
    fq2 = outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam"+".bam_unmapped.2.fq"
else:
    fq1 = Data1
    fq2 = Data2

#########################################################################
#########################################################################
### Assembly-independent search
#########################################################################
#########################################################################

# DIAMOND: Align unmapped reads to nr
# INPUT: fq1, fq2
# OUTPUT: outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.blast"
#         outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.2.blast"
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/diamond blastx -p"+" "+threads+" "+"-d /rds/general/user/cl3820/home/nr_diamond/nr.dmnd -q "+fq1+" -e 1e-5 --id 50 -b 12 --top 10 --out "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.blast"+" -f 6"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/diamond blastx -p"+" "+threads+" "+"-d /rds/general/user/cl3820/home/nr_diamond/nr.dmnd -q "+fq2+" -e 1e-5 --id 50 -b 12 --top 10 --out "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.2.blast"+" -f 6"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

# MEGAN6: Assign unmapped reads to taxa
# INPUT: outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.blast"
#        outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.2.blast"
# OUTPUT: outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.rma"
#         outDir+"/"+sample_percent+"/FirstRound/taxon_unmapped_total.txt"
#         outDir+"/"+sample_percent+"/FirstRound/taxon_ID.txt"
cmd = "/rds/general/user/cl3820/home/megan/tools/blast2rma -i"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.blast"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.2.blast"+" "+"-o"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.rma"+" -f BlastTab -bm BlastX --paired true -lg false -mdb /rds/general/user/cl3820/home/MEGANDatabase/megan-map-Jul2020-2.db -t 32 -ram readCount -ms 50 -me 1e-5 -mpi 50 -top 10 -supp 0.1"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")
cmd = "/rds/general/user/cl3820/home/megan/tools/rma2info -i"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.rma"+" -o "+outDir+"/"+sample_percent+"/FirstRound/taxon_unmapped_total.txt"+" "+"-c2c Taxonomy -n true -p true -r true -mro true -u false"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")
cmd = "/rds/general/user/cl3820/home/megan/tools/rma2info -i"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.rma"+" -o "+outDir+"/"+sample_percent+"/FirstRound/taxon_ID.txt"+" "+"-c2c Taxonomy -n false -p false -r true -mro true -u false"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

#########################################################################
#########################################################################
### Extract CDS
#########################################################################
#########################################################################
if os.path.exists(outDir+"/"+sample_percent+"/FunctionAnnotation"):
    os.system("rm -r "+outDir+"/"+sample_percent+"/FunctionAnnotation")
os.system("mkdir "+outDir+"/"+sample_percent+"/FunctionAnnotation")

os.system("mkdir "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS")

f = pd.read_table(outDir+"/"+sample_percent+"/PreAssembly/taxon_ID.txt",header=None,sep="\t")
f = f[f[0]=="S"][1].values.tolist() # list of species txid

Assembly2Txid = open(outDir+"/"+sample_percent+"/Assembly2Txid.txt","w")
for identifier in f:
    gffs_str = os.popen("grep "+"\"/"+str(identifier)+"/\""+" "+outDir+"/"+sample_percent+"/Genomes/total_gff_list.txt").read().strip()
    if gffs_str != "":
        gffs = gffs_str.split("\n")
        for line in gffs:
            line = line.split("/")[-6:]
            gff = outDir+"/"+sample_percent+"/"
            for i in line:
                gff = gff+i+"/"
            gff = gff[:-1]

            txid = gff.split("/")[10]
            GCF = gff.split("/")[13]

            Assembly2Txid.write(GCF+"\t"+txid+"\n")

            # Convert gff to bed of CDS
            cmd = "awk -v OFS=\'\\t\' -v FS=\'\\t\' \'$3 == \"CDS\" {print $1, $4-1, $5, \".\",\".\",$7}' "+gff+" > "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+".bed && echo \"Done\""
            print("Command:")
            print(cmd)
            os.system(cmd)
            os.system("cat "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+".bed"+">>"+outDir+"/"+sample_percent+"/FunctionAnnotation/total_CDS.bed && echo \"Added to total_CDS.bed\"")
            
            # Merge fna files of one GCF
            fna = os.popen("grep \'"+GCF+"\'"+" "+outDir+"/"+sample_percent+"/Genomes/total_fna_list.txt").read().split("\n")[:-1]
            for f in fna:
                fna_path = outDir+"/"+sample_percent+"/"
                file = f.split("/")[-6:]
                for i in file:
                    fna_path = fna_path+i+"/"
                fna_path = fna_path[:-1]
                os.system("cat "+fna_path+" >> "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+".fna && echo \"Added to "+GCF+"_"+txid+".fna"+"\"")
            
            # Extract CDS
            cmd = "/rds/general/user/cl3820/home/anaconda3/bin/bedtools getfasta"+" -fi "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+".fna"+" -bed "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+".bed"+" -s "+">"+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+"_CDS.fasta && echo \"Done\""
            print("Command:")
            print(cmd)
            os.system(cmd)
            os.system("cat "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+"_CDS.fasta"+">>"+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS.fasta && echo \"Added to CDS.fasta\"")

            # Taxonomy information of CDS
            intervals = pd.read_csv(outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+".bed",header=None,sep="\t")
            AssemblyID = [GCF]*len(intervals)
            Species = [txid]*len(intervals)
            intervals["AssemblyID"] = AssemblyID
            intervals["species"] = Species
            intervals.to_csv(outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+"_info.txt",sep="\t",index=False,header=False)
            os.system("cat "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS/"+GCF+"_"+txid+"_info.txt"+">>"+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS_info.txt && echo \"Added to CDS_info.txt\"")

Assembly2Txid.close()

# Compute coverage
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/bedtools coverage"+" "+"-a"+" "+outDir+"/"+sample_percent+"/FunctionAnnotation/total_CDS.bed"+" "+"-b"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam"+" > "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDSquantify.txt"
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

# Extract CDS with non-zero coverage
from Bio import SeqIO

if os.path.exists(outDir+"/"+sample_percent+"/FunctionAnnotation/CDS_covered.fasta"):
    os.system("rm "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS_covered.fasta")

CDSquantify = pd.read_table(outDir+"/"+sample_percent+"/FunctionAnnotation/CDSquantify.txt",sep="\t",header=None) #fileds: nucleotide ID, start, end, name, score, strand, read count, read length, seq length, coverage
CDSquantify = CDSquantify[CDSquantify[6]!=0]
CDSquantify.to_csv(outDir+"/"+sample_percent+"/FunctionAnnotation/CDSquantify_covered.txt",header=False,index=False,sep="\t")

CDS_ID = CDSquantify.apply(lambda x:x[0]+":"+str(x[1])+"-"+str(x[2])+"("+x[5]+")",axis=1).values.tolist()
CDS_ID = set(CDS_ID)

with open(outDir+"/"+sample_percent+"/FunctionAnnotation/CDS_covered.fasta",'w') as fp:
    for seq in SeqIO.parse(outDir+"/"+sample_percent+"/FunctionAnnotation/CDS.fasta", "fasta"):
        if seq.id in CDS_ID: 
            fp.write('>')
            fp.write(str(seq.id)+"\n")
            fp.write(str(seq.seq)+"\n")

#########################################################################
#########################################################################
### Function annotation
#########################################################################
#########################################################################
cmd = "/rds/general/user/cl3820/home/eggnog-mapper/emapper.py"+" "+"-m diamond --itype CDS"+" "+"-i"+" "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS_covered.fasta"+" "+"-o"+" "+outDir+"/"+sample_percent+"/FunctionAnnotation/CDS_annotation.txt --no_file_comments --block_size 3000 --cpu "+threads
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

if os.path.exists(outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.fq.gz"):
    cmd = "gzip -d "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.fq.gz"
    os.system(cmd)
    cmd = "gzip -d "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.2.fq.gz"
    os.system(cmd)

cmd = "/rds/general/user/cl3820/home/eggnog-mapper/emapper.py"+" "+"-m diamond --itype CDS"+" "+"-i"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.1.fq"+" "+"-o"+" "+outDir+"/"+sample_percent+"/FunctionAnnotation/forward_annotation.txt --no_file_comments --block_size 3000 --cpu "+threads
print("Command:")
print(cmd)
os.system(cmd)
print("Done")

cmd = "/rds/general/user/cl3820/home/eggnog-mapper/emapper.py"+" "+"-m diamond --itype CDS"+" "+"-i"+" "+outDir+"/"+sample_percent+"/FirstRound/"+sample+"_Ref.sam.bam_unmapped.2.fq"+" "+"-o"+" "+outDir+"/"+sample_percent+"/FunctionAnnotation/reverse_annotation.txt --no_file_comments --block_size 3000 --cpu "+threads
print("Command:")
print(cmd)
os.system(cmd)
print("Done")