#!/usr/bin/env python
# -*- coding: utf-8 -*-

from Crypto.Cipher import DES
from Crypto.Cipher import DES3


# --- IMPLEMENTATION GOES HERE ---------------------------------------------
#  Student helpers (functions, constants, etc.) can be defined here, if needed

def insertParityBit(key):
    """
    función para insertar los bits de paridad
    """
    cont = 0
    pairedKey = ""

    while (cont+1) <= len(key):

        if cont % 7 == 0 and cont > 0:
            pairedKey = pairedKey + "1" + key[cont]
        
        else:
            pairedKey = pairedKey + key[cont]
        
        cont += 1
    pairedKey = pairedKey + "1"

    return pairedKey    

def bitsToBytes(msg, size):
    """
    función para transformar a bytes una cadena
    """
    messageBits = int(msg, 2)
    messageInBytes = messageBits.to_bytes(size, byteorder = 'big')

    return messageInBytes

def bytesToBits(msg):
    """
    función para transformar bytes a bits
    """
    messageBytes = int.from_bytes(msg, byteorder = 'big')
    messageinBits = bin(messageBytes)

    return messageinBits

def refillingPadding(message, size):
    """
    función para hacer un rellenado con ceros hasta completar el tamaño del mensaje
    para que sea múltiplo del tamaño del bloque
    """
    if len(message) % size != 0:
        for i in range(len(message) % size, size):
            message = message + "0"

    return message

def checkLen(message, size):
    """
    función para hacer un rellenado con ceros por la izquierda en caso de que nos
    devuelva bits de menos
    """
    if len(message) < size:
        message = (size - len(message)) * "0" + message
    else:
        message = message

    return message

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

    des = DES.new(bitsToBytes(insertParityBit(key),8),DES.MODE_ECB)
    
    cipher = des.encrypt(bitsToBytes(message, 8))
    cipher_text = str(bytesToBits(cipher)[2:])


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

    triple_des = DES3.new(bitsToBytes(insertParityBit(key),24),DES3.MODE_ECB)

    paddedmsg = refillingPadding(message,64) #Rellenamos con ceros hasta que la longitud del mensaje sea múltiplo de 64

    cipher = triple_des.encrypt(bitsToBytes(paddedmsg, int(len(paddedmsg)/8)))

    cipher_text = checkLen(str(bytesToBits(cipher)[2:]), 64)
    #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
    
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
    
    paddedmsg = refillingPadding(message,64) #Rellenamos con ceros hasta que la longitud del mensaje sea múltiplo de 64 (padding)

    des = DES.new(bitsToBytes(insertParityBit(key),8), DES.MODE_ECB)

    cipher = des.encrypt(bitsToBytes(paddedmsg,int(len(paddedmsg)/8)))
    cipher_text=str(bytesToBits(cipher)[2:])


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
    #Rellenamos con ceros hasta que la longitud del mensaje sea múltiplo de 64 (padding)
    paddedmsg=refillingPadding(message,64)

    blockMsg = ""

    #Dividimos el mensaje en fragmentos de 64 bits:
    for i in range (int(len(paddedmsg) / 64)):
        initPointer = i * 64

        blockMsg = paddedmsg[initPointer:(initPointer+64)] #Hacemos bloques (particiones) del mensaje de 64bits
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        cbc_exit = checkLen(str(bin(int(iv,2) ^ int(blockMsg,2))[2:]), 64)
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        des = checkLen(uoc_des(cbc_exit, key), 64)

        iv = des

        cipher_text = cipher_text + des

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
    paddedMsg = refillingPadding(message,64)

    blockMsg=""
    vectorDes = iv
    for i in range (int(len(paddedMsg) / 64)):
        initPointer = i * 64

        blockMsg = paddedMsg[initPointer:(initPointer+64)] #Hacemos bloques (particiones) del mensaje de 64bits
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        vectorDes = checkLen(uoc_des(vectorDes, key), 64)
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        ofb_exit = checkLen(str(bin(int(vectorDes,2) ^ int(blockMsg,2))[2:]), 64)

        cipher_text += ofb_exit



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

    paddedMsg = refillingPadding(message,64) #padding de mensaje
    paddedNonce = refillingPadding(nonce, 64) #padding de nonce

    for i in range (int(len(paddedMsg) / 64)):
        original_nonce_size = len(paddedNonce)
        initPointer = i * 64 #(para hacer las particiones del mensaje)

        blockMsg = paddedMsg[initPointer:(initPointer+64)] #Hacemos bloques (particiones) del mensaje de 64bits

        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        des = checkLen(uoc_des(paddedNonce, key), 64)
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        ctr_exit = checkLen(str(bin(int(des,2) ^ int(blockMsg,2))[2:]), 64)

        paddedNonce = str(bin(int(paddedNonce, 2) + 1)[2:])

        if (original_nonce_size != len(paddedNonce)):
            paddedNonce = "0" + paddedNonce

        cipher_text = cipher_text + ctr_exit



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

    zerosExpected = 168 - (2 * len(message))
    invertedMsg = message[::-1] # Obtenemos cadena con orden invertido

    zerosStr = ""
    for i in range (zerosExpected):#Calcula cantidad necesaria de 0s
        zerosStr = zerosStr + "0"

    output = message + zerosStr + invertedMsg

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

    msgToBinary = str(" ".join(f"{ord(i):08b}" for i in message)) #obtener valor en binario de cada caracter
    msgBin_noBlanks = ""

    for m in range(len(msgToBinary)): #Quitamos los " "
        if msgToBinary[m] != " ":
            msgBin_noBlanks += msgToBinary[m]
    
    while len(msgBin_noBlanks) % block_len != 0:#rellenamos con 1s
        msgBin_noBlanks = msgBin_noBlanks + "1"

    output = msgBin_noBlanks

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

    h="FFFFFFFFFFFFFFFF" #Valor Inicial (H0) de la función hash

    h_i = bin(int(h, 16))[2:]
    key = uoc_g(h_i)

    message = uoc_naive_padding(message, 64)

    for i in range (int(len(message) / 64)):
        initPointer = i * 64
        
        blockMsg = message[initPointer:(initPointer + 64)] # Crea bloques del mensaje de 64 bits
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        if i == 0:
            des = checkLen(uoc_des3(blockMsg, key), 64)
        else:
            des = checkLen(uoc_des3(blockMsg, uoc_g(h_i)), 64)
        
        #Con checkLen(message, size) añadimos bits 0 a la izquierda en caso de que nos devuelva bits de menos
        hash_exit = checkLen(str(bin(int(des, 2) ^ int(blockMsg, 2) ^ int(h_i, 2))[2:]), 64)

        h_i = hash_exit


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

    msg_a = prefix + "A"
    msg_b = prefix + "AW"

    msg_a = uoc_naive_padding(msg_a, 64)
    msg_b = uoc_naive_padding(msg_b + (str(bin(0xFF)[2:])), 64)
    
    #print(uoc_hash(msg_a==msgb))

    collision = ("msg_a", "msg_b")


    # --------------------------------

    return collision

