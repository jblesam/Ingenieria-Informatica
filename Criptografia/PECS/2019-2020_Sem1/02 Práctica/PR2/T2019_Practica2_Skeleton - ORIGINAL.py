#!/usr/bin/env python
# -*- coding: utf-8 -*-

from Crypto.Cipher import DES
from Crypto.Cipher import DES3


# --- IMPLEMENTATION GOES HERE ---------------------------------------------
#  Student helpers (functions, constants, etc.) can be defined here, if needed




# --------------------------------------------------------------------------




def uoc_des(message, key):
    """
    Implements 1 block DES enciphering using a 56-bit key.

    :param message: string of 1 and 0s with the binary representation of the messsage, 64 char. long
    :param key: string of 1 and 0s with the binary representation of the key, 168 char. long
    :return: string of 1 and 0s with the binary representation of the ciphered message, 64 char. long
    """

    cipher_text = ""

    # --- IMPLEMENTATION GOES HERE ---


    # --------------------------------

    return cipher_text




def uoc_des3(message, key):
    """
    Implements 1 block DES enciphering using a 168-bit key.

    :param message: string of 1 and 0s with the binary representation of the messsage, 64 char. long
    :param key: string of 1 and 0s with the binary representation of the key, 168 char. long
    :return: string of 1 and 0s with the binary representation of the ciphered message, 64 char. long
    """

    cipher_text = ""

    # --- IMPLEMENTATION GOES HERE ---


    # --------------------------------

    return cipher_text





def uoc_ecb(key, message):
    """
    Implements the ECB block cipher mode.

    :param key: string of 1 and 0s with the binary representation of the key, 56 char. long
    :param message: string of 1 and 0s with the binary representation of the message
    :return: string of 1 and 0s with the binary representation of the ciphered message
    """

    cipher_text = ""

    # --- IMPLEMENTATION GOES HERE ---



    # --------------------------------
    
    return cipher_text





def uoc_cbc(iv, key, message):
    """
    Implements the CBC block cipher mode.

    :param iv: string of 1 and 0s with the initializacion vector, 64 char. long
    :param key: string of 1 and 0s with the binary representation of the key, 56 char. long
    :param message: string of 1 and 0s with the binary representation of the message
    :return: string of 1 and 0s with the binary representation of the ciphered message
    """

    cipher_text = ""

    # --- IMPLEMENTATION GOES HERE ---



    # --------------------------------
    
    return cipher_text




def uoc_ofb(iv, key, message):
    """
    Implements the OFB block cipher mode.

    :param iv: string of 1 and 0s with the initializacion vector, 64 char. long
    :param key: string of 1 and 0s with the binary representation of the key, 56 char. long
    :param message: string of 1 and 0s with the binary representation of the message
    :return: string of 1 and 0s with the binary representation of the ciphered message
    """

    cipher_text = ""

    # --- IMPLEMENTATION GOES HERE ---



    # --------------------------------
    
    return cipher_text


def uoc_ctr(nonce, key, message):
    """
    Implements the CTR block cipher mode.

    :param iv: string of 1 and 0s with the initializacion vector, 64 char. long
    :param key: string of 1 and 0s with the binary representation of the key, 56 char. long
    :param message: string of 1 and 0s with the binary representation of the message
    :return: string of 1 and 0s with the binary representation of the ciphered message
    """

    cipher_text = ""

    # --- IMPLEMENTATION GOES HERE ---



    # --------------------------------
    
    return cipher_text






def uoc_g(message):
    """
    Implements the g function.

    :param message: string of 1 and 0s with the binary representation of the messsage, 64 char. long
    :return: string of 1 and 0s, 168 char. long
    """

    output = ""

    # --- IMPLEMENTATION GOES HERE ---


    # --------------------------------

    return output


def uoc_naive_padding(message, block_len):
    """
    Implements a naive padding scheme. As many 0 are appended at the end of the message
    until the desired block length is reached.

    :param message: string with the message
    :param block_len: integer, block length
    :return: string of 1 and 0s with the padded message
    """

    output = ""

    # --- IMPLEMENTATION GOES HERE ---


    # --------------------------------

    return output


def uoc_hash(message):
    """
    Implements the hash function.

    :param message: a char. string with the message
    :return: string of 1 and 0s with the hash of the message
    """

    h_i = ""

    # --- IMPLEMENTATION GOES HERE ---


    # --------------------------------

    return h_i


def uoc_collision(prefix):
    """
    Generates collisions for uoc_hash, with messages having a given prefix.

    :param prefix: string, prefix for the messages
    :return: 2-element tuple, with the two strings that start with prefix and have the same hash.
    """

    collision = ("", "")

    # --- IMPLEMENTATION GOES HERE ---


    # --------------------------------

    return collision




