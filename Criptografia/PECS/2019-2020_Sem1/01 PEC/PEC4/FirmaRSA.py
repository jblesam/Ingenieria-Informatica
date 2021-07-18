
"""
Algoritmo de firma RSA:
m = mensaje en claro
K_priv_ = (d) --> Clave privada del emisor

s = m^d mod n

Algoritmo de validación de la firma RSA:
m = mensaje en claro
s = firma del mensaje
k_pub_ = (n,e) --> Clave pública del destinatario:

m' = s^e mod n

m' == m --> La firma digital es válida, en caso contrario no.

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


def firma_RSA(m, da, na):
	#param1: m = mensaje a cifrar
	#param2: da = d (clave privada) de emisor
	#param3: na = n de emisor
	
	s = pow(m,da)%na

	return s

print ("Firma RSA del mensaje: ",firma_RSA(13, 3317, 3737))

