
"""
Para generar claves RSA:
p y q son dos números primos: n = p·q; ɸ(n) = (p-1) · (q-1)
e (=Exponente público): e ϵ (1,ɸ(n)) de forma que mcd(e,ɸ(n))=1
d (=Exponente privado): d·e = 1 mod ɸ(n) ==> d = e^-1 mod ɸ(n)

Clave pública es el par (n,e)
Clave privada es el valor d

Los valores ɸ(n), p y q son valores secretos que solo conoce el propietario
de la clave privada.
"""

"""
A: Emisor		-->	K(pub): Clave pública = (na,ea) = (8881, 5163)
B: Receptor		-->	K(pub): Clave pública = (nb,eb) = (12091, 4321)
m = mensaje en claro
c= mensaje cifrado

Cifrar: c = m^(eb) mod nb
Descifrar: m = c^db mod nb
"""
def xgcd(a, b):
    """return (g, x, y) such that a*x + b*y = g = gcd(a, b)"""
    x0, x1, y0, y1 = 0, 1, 1, 0
    while a != 0:
        q, b, a = b // a, a, b % a
        y0, y1 = y1, y0 - q * y1
        x0, x1 = x1, x0 - q * x1
    return b, x0, y0

def modInv(n, a):
    """Calcula el inverso de a módulo n.
       Utiliza el algoritmo extendido de Euclides para ello.
 
    Args:
        a: número del que se calcula el módulo
        n: módulo del inverso
     
    Returns:
        inverso de a módulo n
 
    """
    mcd , u , v = xgcd(n,a)
    if mcd != 1:
        print("No existe inverso")
        return 0
     
    return u%a


def cifra_RSA(m, nb, eb):
	#param1: m = mensaje a cifrar
	#param2: na = n de emisor
	#param3: ea = e de emisor
	#param4: nb = n de receptor
	#param5: eb = e de receptor

	c = pow(m,eb)%nb

	return c

def descifra_RSA(c,n,e):
	primos=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,
		71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,
		163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257]
	for i in primos:
		if n%i==0:
			p=i
			q=n/p
			break
		"""else:
			p=-1
			q=2
			print("Error")
			break"""
	
	fi_de_n = (p-1)*(q-1)

	d=(modInv(e, fi_de_n))

	#m=((c**d)%n)
	

	#Descifrar: m = c^db mod nb


	return ("Para obtener m: WolfrangAlpha (https://www.wolframalpha.com/widgets/view.jsp?id=570e7445d8bdb334c7128de82b81fc13): x (=c):",c, "y (=d):",d, "mod (=n):",n)




print (cifra_RSA(1324561, 2261011201, 1658920449))
print (descifra_RSA(514,793,143))


