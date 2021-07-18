#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# --- IMPLEMENTATION GOES HERE -----------------------------------------------
#  Student helpers (functions, constants, etc.) can be defined here, if needed



# ----------------------------------------------------------------------------





def uoc_foursquare_genkey(keyword1, keyword2):
    """
    EXERCISE 1: Four-Square Key Generation
    :keyword1: string with the first key word
    :keyword2: string with the second key word
    :return: tuple with the 4 matrices that form a Four-Square key
    """

    square = ([],[],[],[])

    # --- IMPLEMENTATION GOES HERE ---
    listOfCharacters=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S",
    "T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"]

    #En primer lugar nos aseguraremos de que las palabras clave están compuestas
    #por caracteres alfanuméricos:
    while keyword1.isalnum()==False:
        print("Sólo se adminten caracteres alfanuméricos")
        keyword1=input("Dame una clave 1 (keyword1) válida ")

    while keyword2.isalnum()==False:
        print("Sólo se adminten caracteres alfanuméricos")
        keyword2=input("Dame una clave 2 (keyword2) válida ")

    #Revisaremos las palabras clave. En caso de haber caracteres escritos en
    #minúscula, los pasaremos a mayúsculas.
    keyword1=keyword1.upper()
    keyword2=keyword2.upper()

    keyword1Listed=[]
    keyword2Listed=[]

    for i in keyword1:
        keyword1Listed.append(i)

    for i in keyword2:
        keyword2Listed.append(i)

    #Creamos una lista que contenga los caracteres de cada una de las palabras clave 
    #y a continuación todos los caracteres de la A a la Z (en mayúsculas) y del 0 al 9
    keyword1Listed=keyword1Listed+listOfCharacters
    keyword2Listed=keyword2Listed+listOfCharacters

    listOfKeyword1=[]
    listOfKeyword2=[]

    #Eliminamos los caracteres repetidos en ambas listas de modo que obtengamos listas
    #de 36 campos que contengan los caracteres de la A a la Z (en mayúsculas) y del 0 al 9
    #sin repetición y comenzando con las palabras clave "keyword1" y "keyword2".
    for i in keyword1Listed:
        if i not in listOfKeyword1:
            
            listOfKeyword1.append(i)

    for i in keyword2Listed:
        if i not in listOfKeyword2:
            
            listOfKeyword2.append(i)

    upperLeftMatrix=[]
    upperRightMatrix=[]
    lowerLeftMatrix=[]
    lowerRightMatrix=[]

    #Preparamos las matrices que compondrán el cuadrado con listas compuestas por
    #6 listas de 6 elemntos cada una

    for k in range(0,4):
        
        if k==0:
            #preparamos la matriz superior izquierda:
            charger = listOfCharacters
            actualizer = upperLeftMatrix
        elif k==1:
            #preparamos la matriz inferior izquierda:
            charger = listOfKeyword2
            actualizer = lowerLeftMatrix
        elif k==2:
            #preparamos la matriz superior derecha:
            charger = listOfKeyword1
            actualizer = upperRightMatrix
        elif k==3:
            #preparamos la matriz inferior derecha:
            charger = listOfCharacters
            actualizer = lowerRightMatrix


        for i in range(0, 6):
            row=[]

            for j in range(0, 6):
                row.append(charger[0])
                charger.append(charger[0])
                charger.remove(charger[0])

            actualizer.append(row)

    #cargamos en la tupla square las matrices
    square=(upperLeftMatrix,lowerLeftMatrix,upperRightMatrix,lowerRightMatrix)

    # --------------------------------

    return square


def uoc_foursquare_cipher(message, key):
    """
    EXERCISE 2: Four-Square cipher
    :message: message to cipher (plaintext)
    :key: key to use when ciphering the message (as it is returned by uoc_foursquare_genkey() )
    :return: ciphered text
    """

    ciphertext = ""

    #### IMPLEMENTATION GOES HERE ####

    #El listado de caracteres con el orden sin alterar se encuentra en los elemntos 0 y 3
    #(que corresponden con los cuadrantes superior izquierdo e inferior derecho del cuadro)
    #de la lista y son idénticos, obtendremos este conjunto de caracteres alfanuméricos
    #sin desordenar y los almacenaremos en una variable (plaintext) en mi caso.
    plaintext=key[0]
    #Haremos lo mismo con los cuadrantes 1 y 2 (inferior izquierdo y superior derecho)
    cypher1=key[2]
    cypher2=key[1]

    #Nos aseguramos de que el mensaje sólo contenga caracteres alfanuméricos
    while message.isalnum()==False:
        print("Sólo se adminten caracteres alfanuméricos")
        message=input("Escribe una palabra para cifrar válida ")

    #Obtenemos la longitud del mensaje
    longitudMensaje=len(message)

    #En caso de ser un número impar de caracteres, deberemos añadir una "X" al final
    evenCharacters = longitudMensaje%2

    if evenCharacters==1:
        message=message+"X"

    #Nos aseguramos de que todos los caracteres estén en mayúscula
    message=message.upper()


    for i in range (0,longitudMensaje,2):
    #Agrupamos los caracteres del mensaje a cifrar en digrafos
        letter1=message[i]
        letter2=message[i+1]

        rowIndex1=0
        rowIndex2=0
        columnIndex1=0
        columnIndex2=0
        
        #Obtenemos las "coordenadas" en los cuadrados de las letras que conforman cada par  
        for j in range (0,6):
            row=plaintext[j]
            if letter1 in row:
                rowIndex1=j
            if letter2 in row:
                rowIndex2=j
            
            for k in range (0,6):
                letter=row[k]
                if letter1==letter:
                    columnIndex1=k
                    
                if letter2==letter:
                    columnIndex2=k
                    

        #Localizamos la letra correspondiente (primer caracter en cuadrante superior derecho
        #y segundo caracter en cuadrante inferior izquierdo) según las coordenadas obtenidas
        cypherRowIndex1=rowIndex1
        cypherRowIndex2=rowIndex2
        cypherColumnIndex1=columnIndex2
        cypherColumnIndex2=columnIndex1

        cypherRow1=cypher1[cypherRowIndex1]
        cypherRow2=cypher2[cypherRowIndex2]

        cypherLetter1=cypherRow1[cypherColumnIndex1]
        cypherLetter2=cypherRow2[cypherColumnIndex2]

        #Concatenamos en orden al str ciphertext los caracteres que vamos obteniendo.
        ciphertext= ciphertext + cypherLetter1 + cypherLetter2



    ##################################

    return ciphertext


def uoc_foursquare_decipher(message, key):
    """
    EXERCISE 3: Four-Square decipher
    :message: message to decipher (ciphertext)
    :key: key to use when deciphering the message (as it is returned by uoc_foursquare_genkey() )
    :return: plaintext corresponding to the ciphertext
    """

    plaintext = ""

    #### IMPLEMENTATION GOES HERE ####

    #El listado de caracteres con el orden sin alterar se encuentra en los elemntos 0 y 3
    #(que corresponden con los cuadrantes superior izquierdo e inferior derecho del cuadro)
    #de la lista y son idénticos, obtendremos este conjunto de caracteres alfanuméricos
    #sin desordenar y los almacenaremos en una variable (plaintextMatrix) en mi caso.
    plaintextMatrix=key[0]
    #Haremos lo mismo con los cuadrantes 1 y 2 (inferior izquierdo y superior derecho)
    cypher1=key[2]
    cypher2=key[1]

    #Nos aseguramos de que el mensaje cifrado sólo contenga caracteres alfanuméricos
    while message.isalnum()==False:
        print("Sólo se adminten caracteres alfanuméricos")
        message=input("Escribe una palabra para descifrar válida ")

    #Obtenemos la longitud del mensaje
    longitudMensaje=len(message)

    #Nos aseguramos de que todos los caracteres estén en mayúscula
    ciphertext=message.upper()

    for i in range (0,longitudMensaje,2):
    #Agrupamos los caracteres del mensaje a cifrar en digrafos
        letter1=ciphertext[i]
        letter2=ciphertext[i+1]

        rowIndex1=0
        rowIndex2=0
        columnIndex1=0
        columnIndex2=0
        
        #Obtenemos las "coordenadas" en los cuadrados de las letras que conforman cada par  
        #Primer caracter:
        for j in range (0,6):
            row=cypher1[j]
            if letter1 in row:
                rowIndex1=j
                    
            for k in range (0,6):
                letter=row[k]
                if letter1==letter:
                    columnIndex1=k
        
        #Segundo caracter:
        for j in range (0,6):
            row=cypher2[j]
            if letter2 in row:
                rowIndex2=j
            
            for k in range (0,6):
                letter=row[k]
                if letter2==letter:
                    columnIndex2=k

        #Localizamos la letra correspondiente (primer caracter en cuadrante superior derecho
        #y segundo caracter en cuadrante inferior izquierdo) según las coordenadas obtenidas
        clearRowIndex1=rowIndex1
        clearRowIndex2=rowIndex2
        clearColumnIndex1=columnIndex2
        clearColumnIndex2=columnIndex1

        clearRow1=plaintextMatrix[clearRowIndex1]
        clearRow2=plaintextMatrix[clearRowIndex2]

        clearLetter1=clearRow1[clearColumnIndex1]
        clearLetter2=clearRow2[clearColumnIndex2]

        #Concatenamos en orden al str ciphertext los caracteres que vamos obteniendo.
        plaintext= plaintext + clearLetter1 + clearLetter2
    
    #Según mensaje del tablón, si el último caracter es una "X", hay que eliminarla

    ultimo=plaintext[longitudMensaje-1]
    newplaintext=""
    if ultimo=="X":
        newplaintext = plaintext
        plaintext=""
        longTextoClaro = len(newplaintext)
        for i in range (0, longTextoClaro-1):
            plaintext = plaintext+newplaintext[i]


    ##################################

    return plaintext


