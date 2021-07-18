import math
import decimal
import sympy
import random
from sympy.core.numbers import mod_inverse

m = 231
p = 593
kea = 343
keb = 183

c1 = (m ** kea) % p
c2 = (c1 ** keb) % p

kda = sympy.mod_inverse(kea, (p-1))

c3 = (c2 ** kda) % p

print (c3)