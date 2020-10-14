"""Some functions in numberic calculation"""
__author__ = 'Cong Liu (cong.liu20@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
#A function that returns the square root of input number
def foo_1(x):
    return x** 0.5 

#A function that returns the larger one in two input numbers
def foo_2(x, y):
    if x > y:
        return x
    return y        

# A function that sorts three input numbers from the smallest to the largest
def foo_3(x, y, z):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

#Calculate x!, where x is the input number
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

#Calculate the factorial of x, using function foo_4()
def foo_5(x):
    if x == 1:
        return 1
    return x * (x - 1)

#Calculate the factorial of x using while statement
def foo_6(x):
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    print(foo_1(2))
    print(foo_2(5,9))
    print(foo_3(3,2,9))
    print(foo_4(10))
    print(foo_5(6))
    print(foo_6(6))

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)