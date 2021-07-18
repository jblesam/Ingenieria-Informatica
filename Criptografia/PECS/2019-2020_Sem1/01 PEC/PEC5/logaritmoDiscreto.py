import math
import decimal
import sympy
import random
from sympy.core.numbers import mod_inverse

r = 27
g = 7
p = 418
x = 9
c = pow(g,r,p)
print(c)
b = 1
h = (r + (b*x))%(p-1)
print(h)