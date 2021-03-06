"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: blackbirds.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: re
   Input: ../Data/blackbirds.txt
   Function: Capture the Kingdom, Phylum and Species 
             name for each species and prints it out to screen neatly
   Output: 
   Usage: python blackbirds.py
   Date: Nov, 2020"""

import re

# Read the file (using a different, more python 3 way, just for fun!)
with open('../Data/blackbirds.txt', 'r') as f:
    text = f.read()

# replace \t's and \n's with a spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

#Regular expressions for names of kindom, phylum and species
kingdom = r"(Kingdom\s\w+)"
phylum = r"(Phylum\s\w+)"
species = r"(Species\s\w+\s\w+)"

#Match regular expressions to text
k = re.findall(kingdom, text)
p = re.findall(phylum, text)
s = re.findall(species, text)

#Print kindoms, pylum and species
for i in range(0,len(k)):
    print(k[i])
    print(p[i])
    print(s[i])
    print("\n")

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (slightly easier!), or a single one (slightly harder!)
