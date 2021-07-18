#! /usr/bin/env python
# -*- coding: utf-8 -*-

from apartat1 import *
from kmeans_dictio import *



##################################################################################
#
# Leemos los ficheros de valoraciones y descubrimientos:
valoraciones = leerFichero()
descobertes = llegeixDescobertes("descobertes.data")

# Para los diferentes valores de k, aplicamos k-means y miramos los resultados:
for k in range(2,9):
	(asignaciones, centroides) = kmeans_dictio(valoraciones,k,50, pearsonCoeff)
	
	# Generamos [(usuario, grupo, similitud con el centroide)]
	similituds = [(usr, assignacions[usr], 
	                          pearsonCoeff(valoracions[usr],centroides[assignacions[usr]])) 
	                          for usr in assignacions]
	# Separamos por grupos
	simil_grups = [filter(lambda x:x[1]==grup,similituds) for grup in range(k)]
	
	# Encontramos los usuarios representativos de cada grupo (máxima similitud con el centroide)
	representants = []
	for sg in simil_grups:
		(usuaris, grups, simil) = zip(*sg)
		posicio = simil.index(max(simil))
		representants.append(usuaris[posicio])
		
	# Encontramos las preferencias de los restaurantes (valoraciones más altas primero)
	preferencies = []
	for grup in range(k):
		# Ordenar per valoració descendentment
		ordenats = sorted(valoracions[representants[grup]].iteritems(), key=lambda x:x[1], reverse=True)
		preferencies.append(zip(*ordenats)[0])
		
	
	# Para cada usuario, mirar en que grupo se encuentra y en qué posición de la 
	# de recomendaciones se encuentra su nuevo restaurante favorito.
	# Puede ser que algunos descubrimientos no se encuentren, por lo que deberan ser descartados:
	suma  = 0
	cont  = 0
	minim = len(descobertes)
	maxim = 0
	for usuari in descobertes:
		if descobertes[usuari] in preferencies[assignacions[usuari]]:
			posicio = preferencies[assignacions[usuari]].index(descobertes[usuari])
			suma += posicio
			cont += 1
			if posicio > maxim:
				maxim = posicio
			if posicio < minim:
				minim = posicio
	
	print "k-means k=", k, " posición media=", float(suma)/cont, " posición mínima=", minim, " posición máxima=", maxim
		
