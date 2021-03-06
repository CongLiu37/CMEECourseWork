"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: lc2.py
   Work Path: CMEECourseWork/Week2/Code
   Function: Create a list of month,rainfall tuples where the amount of rain was greater than 100 mm.
             create a list of just month names where the amount of rain was less than 50 mm.
             Be done by list comprehensions and conventional loops respectively.
   Usage: python lc2.py
   Date: Oct, 2020"""

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
RainGreaterOneHundred = [i for i in rainfall if i[1] > 100]
print("Task1")
print("Month-rainfall tuples where the amount of rain was greater than 100 mm")
print(RainGreaterOneHundred)
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 
MonthsLessFifty = [i[0] for i in rainfall if i[1] <50]
print("Task2")
print("Month names where the amount of rain was less than 50 mm")
print(MonthsLessFifty)
# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 
list1 = []
list2 = []

for i in rainfall:
    if i[1] > 100:
        list1.append(i)
    elif i[1] < 50:
        list2.append(i[0])

print("Task3")
print("Month-rainfall tuples where the amount of rain was greater than 100 mm")
print(list1)
print("Month names where the amount of rain was less than 50 mm")
print(list2)

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

