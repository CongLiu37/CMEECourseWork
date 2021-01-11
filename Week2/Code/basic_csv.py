"""Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Script: basic_csv.py
Work Path: CMEECourseWork/Week2/Code
Dependencies: csv
Input: testcsv.csv saved in CMEECourseWork/Week2/Data
Output: Print rows and corresponded species name in terminal
        Save species name and body mass in Results/bodymass.csv
Usage: python basic_csv.py
Date: Oct, 2020"""

import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
f = open('../Data/testcsv.csv','r')

csvread = csv.reader(f) #Each line is splitted by comma and saved as a list

temp = []
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close()

# write a file containing only species name and Body mass
f = open('../Data/testcsv.csv','r')
g = open('../Results/bodymass.csv','w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
