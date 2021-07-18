"""
Para generar claves El Gamal:
p --> número primo
α --> elemento de orden q
d (valor aleatorio): ES LA CLAVE PRIVADA ϵ [2,..., p-2]
β = α^d mod p

Clave pública = (p, α, β)
Clave privada es el valor d

Cifrar: 
Elegimos v (valor aleatorio): c=(c1,c2)
            c1 = α ^v mod p
            c2 = m · β^v mod p

Descifrar: m = (c2/c1^d) mod p
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


def cifra_Gamal(m, p, alfa, d, v):
	
	c1 = pow(alfa, v)%p

	beta = pow(alfa, d)%p

	c2 = m*pow(beta, v)%p
	
	return (c1, c2)

def descifra_Gamal(p, c1,c2,d):
	aux=(pow(c1,d)%p)

	aux=modInv(aux,p)

	m=(c2*aux)%p

	return (m)



#def cifra_Gamal(m, p, alfa, alfa_b, d, v):
print ("Cifrado: ",cifra_Gamal(65, 1409, 1271, 51, 44))
#def descifra_Gamal(p, c1,c2,d):
print ("Descifrado: ",descifra_Gamal(61,55,56,12))

