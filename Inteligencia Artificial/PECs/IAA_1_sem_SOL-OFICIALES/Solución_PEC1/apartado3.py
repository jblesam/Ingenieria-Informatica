#! /usr/bin/env python
# -*- coding: utf-8 -*-


from HierarchicalClustering import *
from apartado1 import *



# Dado un agrupamiento de restaurantes y un dato {restaurant:valor}
# devuelve una lista con el valor medio de cada grupo
def valorMitjaGrup(agrupament, valors):
	valorGrup = []
	for grup in agrupament.values():
		aux = [valors[x] for x in grup]
		valorGrup.append(sum(aux)/len(aux))

	return valorGrup

# Dado el diccionario de valoración de restaurantes {usuari:{rest:valoració}}
# calcula la valoración media de cada restaurante {restaurant: valoracióMitjana}
def calculaValoracioRestaurants(valoracions):
	resultat = {}
	for usuari in valoracions:
		for rest in valoracions[usuari]:
			if not resultat.has_key(rest):
				resultat[rest] = []
			resultat[rest].append(valoracions[usuari][rest])
				
	# Calcular les valoracionse medias:
	return {r:sum(resultat[r])/len(resultat[r]) for r in resultat}


##################################################################################
#
# Leemos los ficheros de valoraciones y precios:
valoracions = llegeixValoracions("valoracions.data")
preus       = llegeixPreus("valoracions.data")

# Leemos el fichero con las posiciones de los restaurantes:
posicions = llegeixPosicions("restaurants.data")

# Calculamos las valoraciones medias por resturante:
valoracionsRestaurants = calculaValoracioRestaurants(valoracions)


##################################################################################
#
# Agrupamiento de restaurantes con enlace simple y distancia euclidea:
agrupamentSimple = agrupamentAglomeratiu(posicions, numGrups=4, criteri=enllacSimple,
                             dist=distEuclidea)
print "Numero de elementos por grupo:", [len(x) for x in agrupamentSimple.values()]
print "Precios medios con agrupamiento simple:", valorMitjaGrup(agrupamentSimple, preus)
print "Valoraciones medias con agrupamiento simple:", valorMitjaGrup(agrupamentSimple, valoracionsRestaurants)


##################################################################################
#
# Agrupamiento de restaurantes con enlace completa y distancia euclidea:
agrupamentComplet = agrupamentAglomeratiu(posicions, numGrups=4, criteri=enllacComplet,
                             dist=distEuclidea)

print                             
print "Numero de elementos por grupo:", [len(x) for x in agrupamentComplet.values()]
print "Precios medios con agrupamiento completo:", valorMitjaGrup(agrupamentComplet, preus)
print "Valoraciones medias con agrupamiento completo:", valorMitjaGrup(agrupamentComplet, valoracionsRestaurants)

