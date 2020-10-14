"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: align_seqs_fasta.py
   Running: In CMEECourseWork/Week2
   Input file:  two fasta files saved in CMEECourseWork/Week1/Data
   Function: Align two sequences saved in input files. 
             If input files were not provided, the script would take 407228326.fasta and 407228412.fasta as input.
   Output: The best alignment and corresponding score, saved in Results/align.txt
   Usage in terminal: python align_seqs_fasta.py [file1] [file2]
   Date: Oct, 2020"""

#importing
import sys
import os

os.chdir("/home/cong/CMEECourseWork/")
files = sys.argv[1:]

def fasta(f):
    file = open("Week1/Data/" + str(f), "r")
    list1 = []
    for line in file:
        line = line.strip()
        list1.append(line)
    file.close()

    list2 = []
    for i in range(0, len(list1)):
        if list1[i][0] == ">":
            list2.append(list1[i])
            seq = ""
            for j in range(i + 1, len(list1)):
                if list1[j][0] != ">":
                    seq = seq + list1[j]
                else:
                    break
            list2.append(seq)
    return list2        
        
# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest
if len(files) != 0:
    seq1 = fasta(files[0])[1]
    seq2 = fasta(files[1])[1]
else:
    seq1 = fasta("407228326.fasta")[1]
    seq2 = fasta("407228412.fasta")[1]


l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

output = open("Week2/Results/align.txt", "w")

output.write(my_best_align + "\n")
output.write(s1 + "\n")
output.write("Best score: " + str(my_best_score))

output.close()