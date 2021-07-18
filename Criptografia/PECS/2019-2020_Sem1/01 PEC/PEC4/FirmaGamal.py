
"""
Algoritmo de firma ElGamal:
m = mensaje en claro
K_priv_ = (d) --> Clave privada del emisor

h = valor aleatorio ϵ [2,..., p-2] coprimo con p-1 (mcd(h,p-1)=1)
r = α ^h mod p
s ==> m = dr + hs mod (p-1) --> s=(m-d*r)*h^(-1) mod (p-1)

La firma corresponde al par de valores (r,s)

Algoritmo de validación de la firma ElGamal:
m = mensaje en claro
(r,s) = firma del mensaje
k_pub_ = (p, α, β) --> Clave pública del emisor:

t = β^r*r^s mod p

t == α^m mod p --> La firma digital es válida, en caso contrario no.
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


def firma_Gamal(m, p, alfa, d, h):
	
	r = (pow(alfa,h))%p

	aux_s = (m-(d*r))%(p-1)
	inv_mod_h = modInv(h,(p-1))

	s = (aux_s * inv_mod_h)%(p-1)
	
	return (r, s)

def validar_firmaElGamal(m, alfa, d, r,s,p):
	beta = (pow(alfa,d))%p
	t = ((pow(beta,r))*(pow(r,s)))%p
	check = (pow(alfa,m))%p

	return(t==check)

#def firma_Gamal(m, p, alfa, d, h):
print ("Firma ElGamal: ",firma_Gamal(3, 41, 30, 30, 9))
#def validar_firmaElGamal(m, alfa, d, r,s,p):
print ("Firma válida: ", validar_firmaElGamal(4,2,6,7,2,13))



