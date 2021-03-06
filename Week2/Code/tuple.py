"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: tuple.py
   Work Path: CMEECourseWork/Week2/Code
   Function: print latin name, common name, mass on a separate line
   Usage: python tuple.py
   Date: Oct, 2020"""

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# 
# A nice example output is:
# 
# Latin name: Passerculus sandwichensis
# Common name: Savannah sparrow
# Mass: 18.7
# ... etc.

# Hints: use the "print" command! You can use list comprehensions!
for i in birds:
    print("Latin name: " + i[0])
    print("Common name: " + i[1])
    print("Mass: " + str(i[2]))
    print("\n")
