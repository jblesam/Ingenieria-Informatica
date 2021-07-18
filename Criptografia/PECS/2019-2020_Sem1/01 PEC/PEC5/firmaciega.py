import math
import decimal
import sympy
import random
from sympy.core.numbers import mod_inverse

m = 25636

r = 9629

ea = 5995
na = 15481
eb = 34037
nb = 38809
da = 10435
db = 15405

t = pow(r,eb,nb)
m_prim = (m * t)%nb
s = pow(m_prim,db,nb)
print(s)