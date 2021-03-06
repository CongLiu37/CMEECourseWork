"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: regexs.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: re
   Input:
   Function: Examplify the usage of regular express.
   Output: 
   Usage: python regexs.py
   Date: Nov, 2020"""

import re

my_string = "a given string"
match = re.search(r"\s", my_string)
print(match)
print(match.group())

match = re.search(r'\d', my_string)
print(match)

MyStr = 'an example'
match = re.search(r'\w*\s', MyStr)
if match:                      
    print('found a match:', match.group()) 
else:
    print('did not find a match')    

match = re.search(r'2', "it takes 2 to tango")
print(match.group())

match = re.search(r'\d', "it takes 2 to tango")
print(match.group())

match = re.search(r'\d.*' , "it takes 2   to tango")
print(match.group())

match = re.search(r'\s\w{1,3}\s', 'once upon a time')
print(match.group())

match = re.search(r'\s\w*$', 'once upon a time')
print(match.group())

print(
    re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group()
)

print(
    re.search(r'^\w*.*\s', 'once upon a time').group()
)

print(
    re.search(r'^\w*.*?\s', 'once upon a time').group()
)

print(
    re.search(r'<.+>', 'This is a <EM>first</EM> test').group()
)

print(
    re.search(r'<.+?>', 'This is a <EM>first</EM> test').group()
)

print(
    re.search(r'\d*\.?\d*','1432.75+60.22i').group()
)

print(
    re.search(r'[AGTC]+', 'the sequence ATTCGT').group()
)

print(
    re.search(r'\s+[A-Z]\w+\s*\w+', "The bird-shit frog's name is Theloderma asper.").group()
)

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+",MyStr)
print(match.group())

MyStr = 'Samraat Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+",MyStr)
print(match)
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+",MyStr)
print(match.group())

MyStr = 'Samraat?+ Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s\?\+]+,\s[\w\.@]+,\s[\w\s]+",MyStr)
print(match.group())

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+",MyStr)
print(match.group())
print(match.group(0))
match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)",MyStr)
if match:
    print(match.group(0))
    print(match.group(1))
    print(match.group(2))
    print(match.group(3))

MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"
emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr) 
for email in emails:
    print(email)

f = open('Data/TestOaksData.csv', 'r')
found_oaks = re.findall(r"Q[\w\s].*\s", f.read())
print(found_oaks)

MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"
found_matches = re.findall(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+)", MyStr)
print(found_matches)
for item in found_matches:
    print(item)

import urllib3
conn = urllib3.PoolManager() # open a connection
r = conn.request('GET', 'https://www.imperial.ac.uk/silwood-park/academic-staff/') 
webpage_html = r.data #read in the webpage's contents
print(type(webpage_html))
My_Data  = webpage_html.decode()
print(My_Data)
pattern = r"Dr\s+\w+\s+\w+"
regex = re.compile(pattern) # example use of re.compile(); you can also ignore case  with re.IGNORECASE 
for match in regex.finditer(My_Data): # example use of re.finditer()
    print(match.group())

New_Data = re.sub(r'\t'," ", My_Data) # replace all tabs with a space
print(New_Data)
