#! /usr/bin/env python
# -*- coding: utf-8 -*-


from recomanadores import *
from apartado1 import *

##################################################################################
#
# Leemos el fichero de valoraciones:
valoracions = llegeixValoracions("valoracions.data")


# Ejecutamos el recomendador y miramos qué restaurante recomienda:
# (similitud euclidiana).No nos interesan las puntuaciones que devuelve el 
# recomendador [(restaurant, valoració),] , por eso esta la instruccion 
# zip(*weighted...)[0]
recomEuclidiana = {usr : zip(* weightedRating(valoracions, usr, euclideanSimilarity))[0]
                   for usr in valoracions.keys() }


# Leemos el fichero de descubrimientos:
descubrimientos = llegeixDescobertes("descobertes.data")

# Calculamos la posición media del descubrimiento del usuario en la lista de recomendaciones:
posiciones = [list(recomEuclidiana[usr]).index(descubrimientos[usr]) for usr in descubrimientos]
print ("Recomendador ponderado con similitud euclidiana.")
print ("Posicin minima de los descubrimientos= ") + str(min(posiciones))
print ("Posicion maxima de los descubrimientos= ") + str(max(posiciones))
print ("Posicion  media de los descubrimientos=") + str(float(sum(posiciones))/len(posiciones))


# Ejecutamos el recomendador y miramos qué restaurante recomienda:
# (con correlación de Pearson)
recomPearson = {usr : zip(*weightedRating(valoracions, usr, pearsonCoeff))[0]
                   for usr in valoracions.keys() }


# Calculamos la posición media del descubrimiento del usuario en la lista de recomendaciones:
posicions = [list(recomPearson[usr]).index(descubrimientos[usr]) for usr in descubrimientos]
print ("Recomendador ponderado con correlacion de Pearson.")
print ("Posicion minima de los descubrimientos= ") + str(min(posiciones))
print ("Posicion maxima de los descubrimientos= ") + str(max(posiciones))
print ("Posicion media de los descubrimientos=") + str(float(sum(posiciones))/len(posiciones))




