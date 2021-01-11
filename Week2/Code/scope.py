"""Language: Python3
   Auther: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: scope.py
   Work Path: CMEECourseWork/Week2/Code
   Function: Exemplify variable scope
   Usage: python scope.py
   Date: Oct, 2020"""

#Exemple 1
_a_global = 10 # a global variable

if _a_global >= 5:
    _b_global = _a_global + 5 # also a global variable

def a_function():
    """Inside the function, _a_global is 5, _b_global is 10, _a_local is 4."""
    _a_global = 5 # a local variable
    
    if _a_global >= 5:
        _b_global = _a_global + 5 # also a local variable
    
    _a_local = 4
    
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value of _b_global is ", _b_global)
    print("Inside the function, the value of _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global is ", _a_global)
print("Outside the function, the value of _b_global is ", _b_global)
"""Outside the function, _a_global is 10 instead of 5,
   _b_global is 15 instead of 10"""


#Exemple 2
_a_global = 10

def a_function():
    """Inside the function, _a_local is 4, _a_global is 10"""
    _a_local = 4
    
    print("Inside the function, the value _a_local is ", _a_local)
    print("Inside the function, the value of _a_global is ", _a_global)
    
    return None

a_function()

print("Outside the function, the value of _a_global is", _a_global)
"""Outside the function, _a_global is 10"""


#Exemple 3
_a_global = 10

print("Outside the function, the value of _a_global is", _a_global)

def a_function():
    """Inside the function, _a_global is 5 instead of 10, _a_local is 4"""
    global _a_global
    _a_global = 5
    _a_local = 4
    
    print("Inside the function, the value of _a_global is ", _a_global)
    print("Inside the function, the value _a_local is ", _a_local)
    
    return None

a_function()

print("Outside the function, the value of _a_global now is", _a_global)
"""_a_global is 5"""

#Exemple 4
def a_function():
    """Before calling _a_function2, _a_global is 10"""
    _a_global = 10

    def _a_function2():
        """Creat a global variable _a_global=20"""
        global _a_global
        _a_global = 20
    
    print("Before calling _a_function2, value of _a_global is ", _a_global)


    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)
    """_a_global is still 10"""
    return None

a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)
"""Now _a_global is 20"""


#Exemple 5
_a_global = 10

def a_function():
    """Another example"""
    def _a_function2():
        """Creat a global variable _a_global=20"""
        global _a_global
        _a_global = 20
    
    print("Before calling _a_function2, value of _a_global is ", _a_global)
    """_a_global is 10"""
    _a_function2()
    
    print("After calling _a_function2, value of _a_global is ", _a_global)
    """_a_global is 20"""
a_function()

print("The value of a_global in main workspace / namespace is ", _a_global)
"""_a_global is 20"""
