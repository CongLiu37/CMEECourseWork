"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: lc1.py
   Work Path: CMEECourseWork/Week2/Code
   Input file:
   Function: Practical of python programming
   Output:
   Usage: python lc1.py
   Date: Oct, 2020"""

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 
Latin_names = [i[0] for i in birds]
common_names = [i[1] for i in birds]
body_masses = [i[2] for i in birds]
print("Task 1")
print("Latin names")
print(Latin_names)
print("Common names")
print(common_names)
print("Body masses")
print(body_masses)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 
LatinNames = []
CommonNames = []
BodyMasses = []
for i in birds:
    LatinNames.append(i[0])
    CommonNames.append(i[1])
    BodyMasses.append(i[2])
print("Task2")
print("Latin names")
print(LatinNames)
print("Common names")
print(CommonNames)
print("Body masses")
print(BodyMasses)

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 
