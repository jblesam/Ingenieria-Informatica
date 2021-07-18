#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import math
import decimal
import sympy
import random
from sympy.core.numbers import mod_inverse


# --- IMPLEMENTATION GOES HERE -----------------------------------------------
#  Student helpers (functions, constants, etc.) can be defined here, if needed


# ----------------------------------------------------------------------------





def uoc_rsa_genkeys(keylen):
    """
    EXERCISE 1.1: Create a pair of RSA keys of keylen bits
    :keylen: length in bits of the key to generate
    :return: key pair in format [[e, n], [d, n]]
    """

    key = [[-1, -1], [-1, -1]]

    # --- IMPLEMENTATION GOES HERE ---

    nlen = 1

    while(nlen != keylen):
        p_exp = random.randrange(keylen-1)
        q_exp = keylen - p_exp

        sw_p = -1
        sw_q = -1

        p = random.randrange(2**p_exp)

        while (sw_p == -1): #Obtenemos un número primo (p) entre 1 y 2^keylen
            if(sympy.isprime(p) == False):
                p = sympy.nextprime(p)
                if(p > 2**p_exp):
                    p = random.randrange(2**p_exp)
                else:
                    sw_p = 1
            else:
                sw_p = 1

        q = random.randrange(2**q_exp)

        while (sw_q == -1):#Obtenemos un número primo (q) entre 1 y 2^keylen
                        #este número primo, multiplicado por p, nos dará n
            if(sympy.isprime(q) == False):
                q = sympy.nextprime(q)
                if (q>2**q_exp):
                    q = random.randrange(2**q_exp)
                else:
                    sw_q = 1
            else:
                sw_q = 1

        n = p*q #Obtenemos n
        nbin = int(bin(n)[2:])
        nlen = len(str(nbin))

        #Comprueba que n tiene la longitud en bits requerida
        #print(2**(keylen-1), " <= ", n , " <= ", 2**keylen)

    fi_de_n = (p-1) * (q-1)

    mcd = 0

    # Obtenemos e (el exponente público)

    while (mcd != 1):
        e = random.randrange(fi_de_n)
        mcd = sympy.gcd(e, fi_de_n)
        #print ("e: ",e)
        #print ("mcd: ",mcd)

    # Obtenemos la clave privada:

    d = sympy.mod_inverse(e, fi_de_n)

    key = [[e, n], [d, n]]
    
    # --------------------------------

    return key



def uoc_rsa_cipher(pubkey, message):
    """
    EXERCISE 1.2: RSA enciphering
    :pubkey: public key, in format [e, n]
    :message: an integer representing the message
    :return: an integer representing the ciphered message
    """

    ciphertext = -1

    #### IMPLEMENTATION GOES HERE ####

    e = int(pubkey[0]) #Debemos asegurarnos de que en adelante lo considere como int (no Integer)
    n = int(pubkey[1]) #Debemos asegurarnos de que en adelante lo considere como int (no Integer)

    ciphertext = pow(message,e,n)


    ##################################

    return ciphertext



def uoc_rsa_decipher(privkey, ciphertext):
    """
    EXERCISE 1.3: Decipher a message with RSA
    :privkey: private key in format [d, n]
    :ciphertext: an integer representing the ciphertext
    :return: an integer representing the plaintext message
    """

    plaintext = ""

    #### IMPLEMENTATION GOES HERE ####

    d = int(privkey[0]) #Debemos asegurarnos de que en adelante lo considere como int (no Integer)
    n = int(privkey[1]) #Debemos asegurarnos de que en adelante lo considere como int (no Integer)

    plaintext = pow(ciphertext,d,n)


    ##################################

    return plaintext




def uoc_pollard_pm1(n, B):
    """
    EXERCISE 2.1: Decipher a message with RSA
    :privkey: private key in format [d, n]
    :ciphertext: an integer representing the ciphertext
    :return: an integer representing the plaintext message
    """


    factor = 1

    #### IMPLEMENTATION GOES HERE ####

    a = 2
    #b = 2

    for i in range (2,B):
        a = pow(a,i,n)
        #b = pow(b,i,n)

    if (a>1):
        d = sympy.gcd(a-1, n)

        if(1<d<n):
            factor = d
    else:
        factor = n

    ##################################

    return factor



def uoc_rsa_retrieve_privkey(p, q, pubkey):
    """
    EXERCISE 2.2: Recover the private key using the provided factors and exponent
    :p: p factor
    :q: q factor
    :pubkey: public key, in format [e, n]
    :return: privkey format [d, n]
    """

    key = [-1, -1]

    # --- IMPLEMENTATION GOES HERE ---
    
    n = p * q
    fi_de_p = p-1
    fi_de_q = q-1
    fi_de_n = fi_de_p*fi_de_q

    e = pubkey[0]

    # Obtenemos la clave privada:
    d = mod_inverse(e, fi_de_n)

    key = [d, n]
    
    # --------------------------------

    return key



def uoc_rsa_genkeys_using_strong_primes(keylen):
    """
    EXERCISE 3.1: Create a pair of RSA keys of keylen bits
    :keylen: length in bits of the key to generate
    :return: key pair in format [[e, n], [d, n]]
    """

    key = [[-1, -1], [-1, -1]]

    # --- IMPLEMENTATION GOES HERE ---
    """
    # LA PRECAUCIÓN DE NO TOMAR PRIMOS PEQUEÑOS SE HA TOMADO EN LA IMPLEMENTACIÓN DEL EJERCICIO 1,
    # POR LO QUE EN ESTA PARTE DE LA PRÁCTICA SE HA ENTREGADO EL MISMO CÓDIGO.
    #
    #
    # SI LA EJECUCIÓN DE LOS JUEGOS DE PRUEBAS SE ATASCARA, RUEGO VUELVAN A INTENTARLA, PASARÁ LOS JUEGOS.
    # GRACIAS.
    """


    nlen = 1

    while(nlen != keylen):
        p_exp = random.randrange(keylen-1)
        q_exp = keylen - p_exp

        sw_p = -1
        sw_q = -1

        p = random.randrange(2**p_exp)

        while (sw_p == -1): #Obtenemos un número primo (p) entre 1 y 2^keylen
            if(sympy.isprime(p) == False):
                p = sympy.nextprime(p)
                if(p > 2**p_exp):
                    p = random.randrange(2**p_exp)
                else:
                    sw_p = 1
            else:
                sw_p = 1

        q = random.randrange(2**q_exp)

        while (sw_q == -1):#Obtenemos un número primo (q) entre 1 y 2^keylen
                        #este número primo, multiplicado por p, nos dará n
            if(sympy.isprime(q) == False):
                q = sympy.nextprime(q)
                if (q>2**q_exp):
                    q = random.randrange(2**q_exp)
                else:
                    sw_q = 1
            else:
                sw_q = 1

        n = p*q #Obtenemos n
        nbin = int(bin(n)[2:])
        nlen = len(str(nbin))

        #Comprueba que n tiene la longitud en bits requerida
        #print(2**(keylen-1), " <= ", n , " <= ", 2**keylen)

    fi_de_n = (p-1) * (q-1)

    mcd = 0

    # Obtenemos e (el exponente público)

    while (mcd != 1):
        e = random.randrange(fi_de_n)
        mcd = sympy.gcd(e, fi_de_n)
        #print ("e: ",e)
        #print ("mcd: ",mcd)

    # Obtenemos la clave privada:

    d = sympy.mod_inverse(e, fi_de_n)

    key = [[e, n], [d, n]]
    
    # --------------------------------

    return key




