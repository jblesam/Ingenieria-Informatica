
def mu(x):

    if 0 <= x <= 0.09:
        return 0.64
    elif x <= 0.168:
        return -4*x + 1
    elif x <= 0.667:
        return 0.33
    elif x <= 0.75:
        return -4*x + 3

    return 0



v_numerador = 0
v_denominador = 0
v_interval = 0.01 
i = 0
while i < 1:
    v_numerador += mu(i) * i
    v_denominador += mu(i)
    i += v_interval

resultat = v_numerador / v_denominador

print(v_numerador)
print(v_denominador)
print(resultat)
