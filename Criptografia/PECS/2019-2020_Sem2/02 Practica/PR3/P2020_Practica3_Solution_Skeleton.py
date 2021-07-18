#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import random
import sympy
import hashlib
import string

class UOCRandom:
    """
    Example:
    >>> rnd = UOCRandom()
    >>> rnd.get(1, 100)
    7
    >>> rnd = UOCRandom()
    >>> rnd.get(1, 100)
    7

    Example with seed:
    >>> rnd = UOCRandom(7)
    >>> rnd.get(1, 100)
    42
    >>> rnd = UOCRandom(7)
    >>> rnd.get(1, 100)
    42
    """
    random_values = []

    def __init__(self, seed=None):
        random.seed(seed)

    def get(self, min_value, max_value):
        if UOCRandom.random_values:
            return UOCRandom.random_values.pop()
        return random.randint(min_value, max_value)


# --- IMPLEMENTATION GOES HERE -----------------------------------------------

def men_gen(size=8, chars=string.ascii_uppercase + string.digits):
    """
    Función para generar valores aleatorios.
    Longitud por defecto 8 digitos
    Caracteres por defecto, letras mayusculas y numeros
    Dado que en el enunciado no se indica como deben ser ni que longitud deben tener las
    preimagenes ni colisiones se han especificado estas por defecto aunque es posible modifarlas
    al llamar a la funcion
    """
    return ''.join(random.choice(chars) for _ in range(size))

#  Student helpers (functions, constants, etc.) can be defined here, if needed


def uoc_dsa_genkey(L, N):
    """
    EXERCISE 1.1: Create a pair of DSA keys of num_bits bits
    :L: L value of the DSA algorithm
    :N: N value of the DSA algorithm
    :return: key pair in format [[p,q,g,y], [p,q,g,x]]
    """

    result = [[], []]

    #### IMPLEMENTATION GOES HERE ####
    """
    Buscamos primero un nº primo q tal que 2^N–1 < q < 2^N y a partir de el buscamos el nº primo
    p 2^L–1 < p < 2^L y que ademas se cumpla que q sea divisor de p-1 (la implementacion se hace busando un valor
    p aleatorio, del que q pueda ser divisor y que si le sumamos 1, p+1 sea primo, en las comprobaciones, tambien
    se prueba haciendo a dicho p proporcional a q para ahorrar busquedas)
    """

    rnd = UOCRandom()
    verif_q = -1
    q = sympy.randprime(2 ** (N - 1) + 1, 2 ** N)
    while verif_q == -1:
        div = rnd.get(2 ** (L - 1) + 1, 2 ** L)
        if div % q == 0:
            if sympy.isprime(div + 1):
                p = div + 1
                break
        else:
            div = div - (div % q)
            if sympy.isprime(div + 1):
                p = div + 1
                break
            else:
                div = div + q
                if sympy.isprime(div + 1):
                    p = div + 1
                    break

    # g ademas de ser 1 < g < p, debe ser un generador del subgrupo de q elementos
    h = rnd.get(1,p-1)
    g = pow(h,((p-1)//q), p)
    x = rnd.get(1,q)
    y = pow(g,x,p)

    result = [[p, q, g, y], [p, q, g, x]]

    ##################################

    return result


def uoc_dsa_sign(privkey, message):
    """
    EXERCISE 1.2: Sign a message using DSA
    :privkey: Private key in format [p,q,g,x]
    :message: Message to sign
    :return: Signature of the message in [r,s] format 
    """
    result = [0, 0]

    #### IMPLEMENTATION GOES HERE ####
    # Codificacion de los pasos de firma DSA que se indican en el modulo 5

    rnd = UOCRandom()
    m = message
    p = privkey[0]
    q = privkey[1]
    g = privkey[2]
    x = privkey[3]
    r = 0
    s = 0

    while (r==0 or s==0):
        k = rnd.get(1, q)
        r = (pow(g, k, p))%q
        s = sympy.mod_inverse(k,q)*(m+x*r)%q

    result = [r,s]

    ##################################

    return result


def uoc_dsa_verify(pubkey, message, signature):
    """
    EXERCISE 1.3: Verify a DAS signature
    :pubkey: Public key in format [p,q,g,y]
    :message: Message to verify
    :signature: Signature of the message in [r,s] format 
    :return: True if the signature is valid or False
    """

    result = None

    #### IMPLEMENTATION GOES HERE ####
    # Codificacion de los pasos para la validacion de firma DSA que se indican en el modulo 5

    m = message
    p = pubkey[0]
    q = pubkey[1]
    g = pubkey[2]
    y = pubkey[3]
    r = signature[0]
    s = signature[1]

    if (r==0 or s==0):
        result = False
    else:
        w = sympy.mod_inverse(s,q)
        u_1 = (m*w)%q
        u_2 = (r*w)%q
        a = pow(g,u_1,p)
        b = pow(y,u_2,p)
        temp = (a*b)%p
        v = temp%q
        verif = r%q
        if v == verif:
            result = True
        else:
            result = False

    ##################################  

    return result


def uoc_sha1(message, num_bits):
    """
    EXERCISE 2.1: SHA1 hash
    :message: String with the message
    :num_bits: number of bits from 1 to 160 (it will always be a multiple of 4)
    :return: hexadecimal string with the num_bits least significant bits from 
             the SHA1 hash of the message
    """
    result = ''

    #### IMPLEMENTATION GOES HERE ####

    m = str(message)

    # Usamos la libreria hashlib para crear un objeto sha1 al que le pasamos el mensaje
    # y asi codificarlo. Lo siguiente es obtener esa codificacion del mensaje en formato
    # hexadecimal
    h = hashlib.sha1(m.encode("utf-8"))
    temp = h.hexdigest()

    # Como queremos obtener los num_bits menos significativos invertimos la codificacion en
    # hexadecimal obtenida
    enc = temp[::-1]

    # Como trabajamos en hex, dividimos num_bits entre 4 para obtener los bits menos significativos
    # teniendo en cuenta que una vez obtenidos, debemos volver a invetrir para tenerlos en el orden
    # correcto

    for i in range(0, num_bits//4):
        result += str(enc[i])
    result = result[::-1]

    ##################################  

    return result


def uoc_sha1_find_preimage(message, num_bits):
    """
    EXERCISE 2.2: Find SHA1 preimage
    :message: String with the message
    :num_bits: number of bits from 1 to 160 (it will always be a multiple of 4)
    :return: another string (different from message) which has identical 
             uoc_sha1() hash. 
    """

    preimg = ""

    #### IMPLEMENTATION GOES HERE ####
    # calculamos el hash del mensaje recibido, y creamos mensajes aleatorios y vamos comparando su hash con el
    # del mensaje que recibe la funcion hasta que sean iguales

    m2 = men_gen()
    dif = -1

    m1_sha = uoc_sha1(message, num_bits)
    m2_sha = uoc_sha1(m2, num_bits)

    while dif == -1:
        if message != m2 and m1_sha == m2_sha:
            break
        else:
            m2 = men_gen()
            m2_sha = uoc_sha1(m2, num_bits)

    preimg=m2

    ##################################

    return preimg


def uoc_sha1_collisions(num_bits):
    """
    EXERCISE 2.3: Find SHA1 collisions
    :num_bits: number of bits from 1 to 160 (it will always be a multiple of 4)
    :return: a pair of (different) strings with the same uoc_sha1() hash. 
    """

    collisions = (None, None)

    #### IMPLEMENTATION GOES HERE ####
    # se repite la operatoria de la funcion anterior, pero en este caso, los dos mensajes son generados
    # de forma aleatoria, fijando uno de ellos y repitiendo la generacion del otro hasta encontrar un
    # hash igual

    m1 = men_gen()
    m2 = men_gen()
    m1_sha = uoc_sha1(m1, num_bits)
    m2_sha = uoc_sha1(m2, num_bits)
    dif=-1

    while dif == -1:
        if m1 != m2 and m1_sha == m2_sha:
            break
        else:
            m2 = men_gen()
            m2_sha = uoc_sha1(m2, num_bits)

    collisions=(m1, m2)

    ##################################   

    return collisions


def uoc_dsa_extract_private_key(pubkey, m1, sig1, m2, sig2):
    """
    EXERCISE 3.1: Implements the algorithm used by an attacker to recover 
    :pubkey: Public key in format [p,q,g,y]
    :m1: Message signed
    :sig1: Signature of m1
    :m2: Message signed
    :sig2: Signature of m2
    :privkey: Private key in format [p,q,g,x]
    """

    privkey = None

    # --- IMPLEMENTATION GOES HERE ---
    """
    Basado en la explicacion de ataque con dos mensajes diferentes generados con la misma clave privada del
    algoritmo de ElGmal, en DSA obtenemos:
    k = ((m1-m2)/(s1-s2)) mod q
    x = ((s*k)-m)*r^-1) mod q
    """

    p = pubkey[0]
    q = pubkey[1]
    g = pubkey[2]
    r = sig1[0]
    s1 = sig1[1]
    s2 = sig2[1]

    w = sympy.mod_inverse(r, q)
    M = (m1 - m2) % q
    S = sympy.mod_inverse(s1 - s2, q)
    k = M * S

    x = (((s1 * k) - m1) * w) % q

    privkey = [p,q,g,x]

    # --------------------------------

    return privkey


def uoc_dsa_deterministic_sign(privkey, message):
    """
    EXERCISE 3.2: Sign a message using DSA
    :privkey: Private key in format [p,q,g,x]
    :message: Message to sign
    :return: Signature of the message in [r,s] format 
    """
    result = [0, 0]

    #### IMPLEMENTATION GOES HERE ####
    """
    Repetimos el proceso de firma anterior, pero esta vez usando como semilla del generador para el valor
    aleatorio el nº entero resultante de concatenar el valor hex del hash de la clave privada con el valor 
    hex del hash del mensaje
    """

    m = message
    p = privkey[0]
    q = privkey[1]
    g = privkey[2]
    x = privkey[3]
    r = 0
    s = 0
    conc = ''

    hash_x = uoc_sha1(x, 64)
    hash_m = uoc_sha1(m, 64)
    conc = hash_x + hash_m
    seed = int(conc, 16)
    rnd = UOCRandom(seed)

    while (r == 0 or s == 0):
        k = rnd.get(1, q)
        r = (pow(g, k, p)) % q
        s = sympy.mod_inverse(k, q) * (m + x * r) % q
        result = [r, s]

    ##################################

    return result
