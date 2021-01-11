"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: boilerplate.py
   Work Path: CMEECourseWork/Week2/Code
   Dependencies: sys
   Function: Exemplify the usage of main function
   Usage: python boilerplate.py
   Date: Oct, 2020"""

#Docstring
__appname__ = '[application name here]'
__author__ = 'Your Name (your@email.address)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## imports ##
import sys # module to interface our program with the operating system

## constants ##


## functions ##
def main(argv):
    """ Main entry point of the program """
    print('This is a boilerplate') # NOTE: indented using two tabs or 4 spaces
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)
    
