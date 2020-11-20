"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: dictionary.py
   Work Path: CMEECourseWork/Week2/Code
   Input file:
   Function: Practical of python programming
   Output:
   Usage: python dictionary.py
   Date: Oct, 2020"""

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]
# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc

taxa_dic = {}

keys = []
for i in taxa:
        keys.append(i[1])
keys = set(keys)

for i in keys:
        values = []
        for j in taxa:
                if j[1] == i:
                        values.append(j[0])
        values = set(values)
        taxa_dic[i] = values

print(taxa_dic)
