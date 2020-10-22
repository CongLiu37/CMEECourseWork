"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: oaks.py
   Work Path: CMEECourseWork/Week2
   Input file:
   Function: Practical of python programming
   Output:
   Usage: python oaks.py
   Date: Oct, 2020"""

## Finds just those taxa that are oak trees from a list of species

taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
       ]

def is_an_oak(name):
    """Check whether the genus of input is Quercus"""
    return name.lower().startswith('quercus ') #Returns T or F

##Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

##Using list comprehensions   
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

##Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
