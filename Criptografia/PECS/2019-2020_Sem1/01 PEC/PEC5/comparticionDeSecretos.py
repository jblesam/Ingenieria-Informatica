import math
import decimal
import sympy
import random
from sympy.core.numbers import mod_inverse

"""
modulo=479
m = 5

#Calculadora de determinantes: http://es.onlinemschool.com/math/assistance/equation/kramer/

detNumerador=3853191360

detDenominador= -1722720

numerador=detNumerador%modulo

denominador=detDenominador%modulo



moduloInversoDeno=mod_inverse(denominador, modulo)

print((numerador*moduloInversoDeno)%modulo)

"""
x = 22
p = 89
result = (40 + (52*x) + (43*(x**2)) + (52*(x**3))) % p

print(result)