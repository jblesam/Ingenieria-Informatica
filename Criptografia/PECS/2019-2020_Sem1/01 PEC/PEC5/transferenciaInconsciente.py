import math
import decimal
import sympy
import random
from sympy.core.numbers import mod_inverse

s0 = 5674
s1 = 29072
n = 29987
e = 23267
d = 11483
x0 = 26282
x1 = 15961

#b = 1
#k = 174
#v = (x0+(k**e)) % n
v = 4389
k0 = ((v-x0)**d) % n
k1 = ((v-x1)**d) % n

ciph_s0 = (s0 + k0) % d
ciph_s1 = (s1 + k1) % d

print("ciph_s0 =", ciph_s0, "y ciph_s1 =",ciph_s1)