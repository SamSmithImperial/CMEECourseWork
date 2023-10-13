#!/usr/bin/env python3 

# this shebang tells the computer where to look for python

"""This exercise is to make this script a module using control_flow.py as an example""" # these triple quotation marks indicate a docstring which are part of the running code but are just used to describe the programme

__appname__ = '[application name here]'
__author__ = 'Your Name (your@email.address)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

# imports

import sys

def foo_1(x):
    return x ** 0.5 # ** is an exponentiation operator

def foo_2(x, y):
    if x > y:
        return x
    return foo_2(5, 10)

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

def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x): # a recursive function that calculates the factorial of x
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     
def foo_6(x): # Calculate the factorial of x in a different way; no if statement involved
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    print(foo_1(5))

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)