"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: cfexercises2.py
   Cong Liu: CMEECourseWork/Week2/Code
   Input file: 
   Function: Show the usage of for and while loop
   Output:
   Usage: python cfexercise2.py
   Date: Oct, 2020"""

#For integers in interval [0,12), 
#print "hello" when the integer are divided exactly by 3
for j in range(12):
    if j % 3 == 0:
        print('hello')

#For integers in interval [0,15),
#print "hello" when the integer is 12 or 15
for j in range(15):
     if j % 5 == 3:
        print('hello')
     elif j % 4 == 3:
        print('hello')

#Print hello" and add 3 with z, until z equals 15
#Start value of z is 0
z = 0
while z != 15:
    print('hello')
    z = z + 3

#When z < 100, conduct the loop, and add 1 to z at the end of every cycle
#In the loop, if z = 31, print "hello" 7 times; if z = 18, print "hello"
#Start value of z is 12
z = 12
while z < 100:
    if z == 31:
        for k in range(7):
            print('hello')
    elif z == 18:
        print('hello')
    z = z + 1
