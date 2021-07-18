#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# --- IMPLEMENTATION GOES HERE -----------------------------------------------
#  Student helpers (functions, constants, etc.) can be defined here, if needed



def uoc_bifid_genkey(keyword, period):
    """
    EXERCISE 1: Bifid Key Generation
    :keyword: string with the key word
    :period: period of the groups
    :return: list with the matrix and the period
    """

    square = []
    # --- IMPLEMENTATION GOES HERE ---
    # lista de caracteres para crear la matriz
    listChar = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
                        "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    # Comprueba que la key es alfanumerica
    while keyword.isalnum()==False:
        print("Introduzca unicamente caracteres alfanumericos")
        keyword=input("Teclee la palabra clave: ")
    # Por si se escriben minusculas en la key, pasamos todo a mayusculas
    keyword=keyword.upper()

    # Crear una lista que contenga la key mas la lista de caracteres
    keyListAux=[]
    for i in keyword:
        keyListAux.append(i)
    for i in listChar:
        keyListAux.append(i)

    # Eliminamos los caracteres repetidos para obtener una lista con los 36 caracteres alfanumericos
    # cuyo inicio es la palabra clave sin letras repetidos
    keyListNoRep = []
    for i in keyListAux:
        if i not in keyListNoRep:
            keyListNoRep.append(i)

    # agrupamos los caracteres de la lista en grupos de 6, para crear la "matriz" de 6x6
    for i in range(0, 6):
        subSquare = []
        for j in range(0, 6):
            subSquare.append(keyListNoRep[0])
            keyListNoRep.remove(keyListNoRep[0])
        square.append(subSquare)

    # --------------------------------

    return [square, period]


def uoc_bifid_cipher(message, key):
    """
    EXERCISE 2: Bifid cipher
    :message: message to cipher (plaintext)
    :key: key to use when ciphering the message (as it is returned by
          uoc_bifid_genkey() )
    :return: ciphered text
    """

    ciphertext = ""

    #### IMPLEMENTATION GOES HERE ####
    # obtenemos el nº del periodo y la matriz alfanumerica con la que realizar el cifrado
    period = int(key[1])
    square=key[0]

    # Comprueba que el mensaje es alfanumerico
    while message.isalnum() == False:
        print("Introduzca unicamente caracteres alfanumericos")
        message = input("Teclee el mensaje a cifrar: ")
    # pasamos el mensaje a mayusculas
    message=message.upper()

    # Obtener para cada letra del mensaje, el nº de letra y fila de su posicion en la matriz alfanumerica
    row=[]
    col=[]

    for k in message:
        for i in range(0,6):
            for j in range(0,6):
                if k in square[i][j]:
                    row.append(i)
                    col.append(j)

    # creamos la lista unica intercalando elementos de las filas y columnas en base al nº de periodo
    totalList=[]

    while len(col)!=0:
        if len(row)!=0:
            for i in range(0,period):
                if row:
                    totalList.append(row[0])
                    row.remove(row[0])
            for i in range(0,period):
                if col:
                    totalList.append(col[0])
                    col.remove(col[0])

    # En base a la lista creada, creamos el texto cifrado. Sustituyendo cada pareja de nº por la letra que corresponde
    # a la posicion de la matriz alfanumerica

    while len(totalList)!=0:
        r=int(totalList[0])
        c=int(totalList[1])
        ciphertext+=square[r][c]
        totalList.remove(totalList[1])
        totalList.remove(totalList[0])

    # --------------------------------

    return ciphertext


def uoc_bifid_decipher(message, key):
    """
    EXERCISE 3: Bifid decipher
    :message: message to decipher (ciphertext)
    :key: key to use when deciphering the message (as it is returned by
          uoc_bifid_genkey() )
    :return: plaintext corresponding to the ciphertext
    """

    plaintext = ""

    #### IMPLEMENTATION GOES HERE ####
    # obtenemos el nº del periodo y la matriz alfanumerica con la que realizar el descifrado
    period=int(key[1])
    square=key[0]

    # Comprueba que el texto es alfanumerico
    while message.isalnum() == False:
        print("Introduzca unicamente caracteres alfanumericos")
        message = input("Teclee el mensaje a descifrar: ")
    # pasamos el texto a mayusculas
    message = message.upper()

    # A partir del mensaje cifrado, se obtiene de cada caracter el nº de fila y columna de la posicion que ocupa
    # en la matriz alfanumerica
    totalList=[]
    for k in message:
        for i in range(0,6):
            for j in range(0,6):
                if k in square[i][j]:
                    totalList.append(i)
                    totalList.append(j)

    # Separamos la lista anterior en dos, una de los nº que corresponderian a las listas y otro al de las columnas
    # agrupandol en base al nº de periodo
    mid=len(totalList)
    row=[]
    col=[]
    flag=1
    while len(totalList)!=0:
        if flag==1:
            for i in range(0,period):
                if len(row)<(mid//2):
                    row.append(totalList[0])
                    totalList.remove(totalList[0])
                    flag=2
        else:
            for i in range(0,period):
                if totalList:
                    col.append(totalList[0])
                    totalList.remove(totalList[0])
                    flag=1

    # Obtenemos el texto descifrado buscando en la matriz alfanumerica las letras que corresponden a la posicion
    # correspondiente de combinar las lisas de filas y columnas
    while len(row)!=0:
        r=int(row[0])
        c=int(col[0])
        plaintext+=square[r][c]
        row.remove(row[0])
        col.remove(col[0])

    # --------------------------------

    return plaintext



