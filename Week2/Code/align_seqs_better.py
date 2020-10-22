"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: align_seqs_better.py
   Work Path: CMEECourseWork
   Input: Two fasta files saved in CMEECourseWork/Week1/Data
   Function: Align two sequences saved in input files. 
   Output: All best alignments with equal and highest score, saved in Results/align.txt
   Usage: python align_seqs_better.py [file1] [file2]
   Date: Oct, 2020"""

#importing
import sys

#Save input file names as a list
files = sys.argv[1:]

def fasta(f):
    """convert fasta file to a list with such form: 
       [sequence name start with ">", sequence, ...]"""
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
seq1 = fasta(files[0])[1]
seq2 = fasta(files[1])[1]


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
    """A function that computes a score by returning the number of matches starting
       from arbitrary startpoint (chosen by user)"""
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


#find the best matches (highest score) for the two sequences
my_best_align = None
scores = []
startpoints = []
for i in range(l1):
    z = calculate_score(s1, s2, l1, l2, i)
    scores.append(z)
    startpoints.append(i)

my_best_score = sorted(scores)[-1]
my_best_aligns = []
for i in range(0, len(scores)):
    if scores[i] == my_best_score:
        my_best_align = "." * startpoints[i] + s2
        my_best_aligns.append(my_best_align)

print(my_best_aligns)
print("Best score:", my_best_score)

#Save output
output = open("Week2/Results/align.txt", "w")
output.write(">Best score: " + str(my_best_score) + "\n")
for align in my_best_aligns:
    output.write(align + "\n")
    output.write(s1 + "\n" * 2)

output.close()