"""
This script conducts quality filtering and host removing.
Host removing can be ignored if argument 3 is "None".

ARGUMENTS:
1: rawData1 (file, raw fq file 1)
2: rawData2 (file, raw fq file 2)
3: HostIndex (file, base name of Bowtie2 index of host genome)
4: outDir (directory, named after sample name)
5: sample (string, sample name)
6: threads (integer, number of threads)

DEPENDENCIES:
/rds/general/user/cl3820/home/anaconda3/bin/fastqc
/rds/general/user/cl3820/home/NexteraPE-PE.fa (fasta file of adaptor)
/rds/general/user/cl3820/home/anaconda3/bin/trimmomatic
/rds/general/user/cl3820/home/anaconda3/bowtie2
/rds/general/user/cl3820/home/anaconda3/bin/samtools

INPUT:
rawData1
rawData2
HostIndex

OUTPUT:
4 .html and 4 .zip files in outDir (Fastqc reports of raw and clean reads)
outDir+"/"+sample+"_clean.1.fq", outDir+"/unpaired_"+sample+".1.fq" (clean and paired reads)
outDir+"/"+sample+"_clean.2.fq", outDir+"/unpaired_"+sample+".2.fq" (clean and unpaired reads)
outDir+"/"+sample+"_Host.sam"+".bam" (BAM file from mapping clean-paired reads to host genome)
outDir+"/"+sample+"_Host.sam"+".bam_mapped" (BAM file of reads mapped to host genome)
outDir+"/"+sample+"_Host.sam"+".bam_mapped.1.fq", outDir+"/"+sample+"_Host.sam"+".bam_mapped.2.fq" (host reads)
outDir+"/"+sample+"_Host.sam"+".bam_unmapped" (BAM file of reads not mapped to host genome)
outDir+"/"+sample+"_Host.sam"+".bam_unmapped.1.fq", outDir+"/"+sample+"_Host.sam"+".bam_unmapped.2.fq" (non-host reads)
"""

import os
import sys

args = sys.argv

# Arguments
rawData1 = args[1] # Path to raw data 1
rawData2 = args[2] # Path to raw data 2
HostIndex = args[3] # Path to Bowtie2 index of host genomes. If no host, set it "None"
outDir = args[4] # Directory where all output files saved, named after sample
sample = args[5] # sample name
threads = str(args[6]) # threads, max 32 for general hpc jobs

print("#########################################################################")
print("#########################################################################")
print(args)

if not os.path.exists(outDir):
    print("Make directory: "+outDir)
    os.system("mkdir "+outDir)

#########################################################################
#########################################################################
#########################################################################
#########################################################################

# Fastqc: Check raw data quality
# INPUT: rawData1, rawData2
# OUTPUT: QC reports (2 .html and 2 .zip)
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/fastqc -o "+outDir+" -t "+threads+" "+rawData1+" "+rawData2
print("Command: ")
print(cmd)
os.system(cmd)
print("Done")

# Trimmomatic: Data filtering
# INPUT: rawData1, rawData2
# OUTPUT: outDir+"/"+sample+"_clean.1.fq", outDir+"/unpaired_"+sample+".1.fq"
#         outDir+"/"+sample+"_clean.2.fq", outDir+"/unpaired_"+sample+".2.fq"
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/trimmomatic PE -threads "+threads+" -phred33 "+rawData1+" "+rawData2+" "+outDir+"/"+sample+"_clean.1.fq"+" "+outDir+"/unpaired_"+sample+".1.fq"+" "+outDir+"/"+sample+"_clean.2.fq"+" "+outDir+"/unpaired_"+sample+".2.fq"+" ILLUMINACLIP:/rds/general/user/cl3820/home/NexteraPE-PE.fa:2:30:10:1:true HEADCROP:15 TRAILING:20 MINLEN:50 AVGQUAL:20"
print("Command: ")
print(cmd)
os.system(cmd)
print("Done")

# Fastqc: Check clean data quality
# INPUT: outDir+"/"+sample+"_clean.1.fq", outDir+"/"+sample+"_clean.2.fq"
# OUTPUT: QC reports (2 .html and 2 .zip) 
cmd = "/rds/general/user/cl3820/home/anaconda3/bin/fastqc -o "+outDir+" -t "+threads+" "+outDir+"/"+sample+"_clean.1.fq"+" "+outDir+"/"+sample+"_clean.2.fq"
print("Command: ")
print(cmd)
os.system(cmd)
print("Done")

if HostIndex != "None": # Remove host
    # Bowtie2: Map reads to host genome
    # SAMtools: Convert SAM to BAM
    # INPUT: HostIndex
    #        outDir+"/"+sample+"_clean.1.fq"
    #        outDir+"/"+sample+"_clean.2.fq"
    # OUTPUT: outDir+"/"+sample+"_Host.sam"+".bam"
    cmd = "/rds/general/user/cl3820/home/anaconda3/bowtie2 --sensitive --end-to-end -p "+threads+" -x "+HostIndex+" -1 "+outDir+"/"+sample+"_clean.1.fq"+" -2 "+outDir+"/"+sample+"_clean.2.fq"+" -S "+outDir+"/"+sample+"_Host.sam"
    print("Command: ")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools view -@ "+threads+" -b -S "+outDir+"/"+sample+"_Host.sam"+" > "+outDir+"/"+sample+"_Host.sam"+".bam"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")

    # Remove outDir+"/"+sample+"_Host.sam"
    os.system("rm "+outDir+"/"+sample+"_Host.sam")

    # SAMtools: Extract BAM of unmapped reads
    #           Convert extracted BAM to fq
    # INPUT: outDir+"/"+sample+"_Host.sam"+".bam"
    # OUTPUT: outDir+"/"+sample+"_Host.sam"+".bam_unmapped"
    #         outDir+"/"+sample+"_Host.sam"+".bam_unmapped.1.fq"
    #         outDir+"/"+sample+"_Host.sam"+".bam_unmapped.2.fq"
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools view -@ "+threads+" -u -f 12 "+outDir+"/"+sample+"_Host.sam"+".bam"+" > "+outDir+"/"+sample+"_Host.sam"+".bam_unmapped"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools fastq -1 "+outDir+"/"+sample+"_Host.sam"+".bam_unmapped.1.fq -2 "+outDir+"/"+sample+"_Host.sam"+".bam_unmapped.2.fq "+outDir+"/"+sample+"_Host.sam"+".bam_unmapped"+" -@ "+threads
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")

    # SAMtools: Extract BAM of mapped reads
    #           Convert extracted BAM to fq
    # INPUT: outDir+"/"+sample+"_Host.sam"+".bam"
    # OUTPUT: outDir+"/"+sample+"_Host.sam"+".bam_mapped"
    #         outDir+"/"+sample+"_Host.sam"+".bam_mapped.1.fq"
    #         outDir+"/"+sample+"_Host.sam"+".bam_mapped.2.fq"
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools view -@ "+threads+" -u -G 12 "+outDir+"/"+sample+"_Host.sam"+".bam"+" > "+outDir+"/"+sample+"_Host.sam"+".bam_mapped"
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
    cmd = "/rds/general/user/cl3820/home/anaconda3/bin/samtools fastq -1 "+outDir+"/"+sample+"_Host.sam"+".bam_mapped.1.fq -2 "+outDir+"/"+sample+"_Host.sam"+".bam_mapped.2.fq "+outDir+"/"+sample+"_Host.sam"+".bam_mapped"+" -@ "+threads
    print("Command:")
    print(cmd)
    os.system(cmd)
    print("Done")
else:
    # If HostIndex=args[3] is "None", host removing is ignored.
    os.system("mv "+outDir+"/"+sample+"_clean.1.fq"+" "+outDir+"/"+sample+"_Host.sam.bam_unmapped.1.fq")
    os.system("mv "+outDir+"/"+sample+"_clean.2.fq"+" "+outDir+"/"+sample+"_Host.sam.bam_unmapped.2.fq")
    print("HostIndex = "+HostIndex)
    print("Ignore host removing")
    print("Rename "+outDir+"/"+sample+"_clean.1.fq"+" as "+outDir+"/"+sample+"_Host.sam.bam_unmapped.1.fq")
    print("Rename "+outDir+"/"+sample+"_clean.2.fq"+" as "+outDir+"/"+sample+"_Host.sam.bam_unmapped.2.fq")
