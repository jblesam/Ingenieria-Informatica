
"""
Algoritmo de intercambio de claves de Diffie-Hellman:
p: número primo aleatorio
α: Entero ϵ [2,..., p-2]
a: valor aleatorio elegido por A (=K_privada_) ϵ [2,..., p-2]
K_publicaA_ = (α^b)^a mod p
b: valor aleatorio elegido por B (=K_privada_) ϵ [2,..., p-2]
K_publicaB_ = (α^a)^b mod p

A y B intercambian sus K_publicaX_

Clave compartida: K_ab_ = K_publicaA_^a mod p = K_publicaB_^b mod p

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


def diffieHellman(p, alfa, a, b):
	
	kpubA = pow(alfa,a)%p
	kpubB = pow(alfa,b)%p

	kab = (pow(kpubB,a))%p
	kba = (pow(kpubA,b))%p

	return (kab,kba,(kab==kba))


print(diffieHellman(1289, 6, 827, 153))

