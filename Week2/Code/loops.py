# FOR loops in Python
#Print 0,1,2,3,4
for i in range(5):
    print(i)

#Print elements in my_list
my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

#Calculate the sum of numbers in summands
total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

# WHILE loops  in Python
#Print all integers in the interval [0,100]
z = 0
while z < 100:
    z = z + 1
    print(z)

#An infinite while loop
b = True
while b:
    print("GERONIMO! infinite loop! ctrl+c to stop!")
# ctrl + c to stop!