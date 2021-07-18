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
    
    
    # --------------------------------

    return key




