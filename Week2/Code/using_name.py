"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: using_name.py
   Work Path: CMEECourseWork/Week2/Code
   Input file:
   Function: Exemplify the use of main()
   Output:
   Usage: python using_name.py
   Date: Oct, 2020"""

if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')

print("This module's name is: " + __name__)
