#! /usr/bin/env python
# -*- coding: utf-8 -*-
global file
# Lee el fichero valoracions.data y devuelve un diccionario
# de valoraciones {usuari: {restaurant:valoració}}
def llegeixValoracions(nomFitxer):

    fitxer = file(nomFitxer)
    
    linies = [(l.strip()).split("\t") for l in fitxer.readlines()]
    diccio = {int(l[0]) : {}  for l in linies}
    for l in linies:
	# Se toma l[3] que es la columna de valoracion de los usuarios
        diccio[int(l[0])][int(l[1])] = float(l[3])
    return diccio

# Lee el fichero valoracions.data y devuelve un diccionario
# de precios {restaurant:preu}
def llegeixPreus(nomFitxer):
    fitxer = file(nomFitxer)    
    linies = [(l.strip()).split("\t") for l in fitxer.readlines()]
    # El codigo de cada restaurant está en la columna 1
    diccio = {int(l[1]) : []  for l in linies}
    for l in linies:
            # Se toma l[2] que es la columna de precios, descartando los negativos
            preu = float(l[2])
            if preu > 0:
                diccio[int(l[1])].append(preu)
			
    #  Finalmente se calcula el precio medio de cada restaurante
    for rest in diccio:
	    diccio[rest] = sum(diccio[rest])/len(diccio[rest])
    return diccio

# Lee el fichero descobertes.data y devuelve un diccionario
# de descubrimientos {usuari: restaurant}
def llegeixDescobertes(nomFitxer):
    fitxer = file(nomFitxer)
    
    linies = [(l.strip()).split("\t") for l in fitxer.readlines()]
    diccio = {}
    for l in linies:
        diccio[int(l[0])] = int(l[1])
    return diccio

# Lee el fichero restaurants.data y devuelve un
# dicionario de restaurantes {restaurant : (posicióX, posicióY)}
def llegeixPosicions(nomFitxer):
    fitxer = file(nomFitxer)
    
    linies = [(l.strip()).split("\t") for l in fitxer.readlines()]
    diccio = {}
    for l in linies:
        diccio[int(l[0])] = (float(l[1]), float(l[2]))
    return diccio

