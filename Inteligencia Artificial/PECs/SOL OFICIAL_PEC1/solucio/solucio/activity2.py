#! /usr/bin/env python
# -*- coding: utf-8 -*-

from kmeans_list import *

from activity1 import readHotelValuations


# Compute the mean valuations of each hotel to get a list of 8 valuations
# for each one
def meanHotelValuations(dictioHotels):
    dictioMeans = {}
    for hotel in dictioHotels:
        # Each hotel has a dictio {user: [eight valuations]}
        vals = zip(*dictioHotels[hotel].values())
        dictioMeans[hotel] = list(map(lambda x:sum(x)/len(x), vals))
    
    return dictioMeans
    
# Execute k-means on the hotels read
hotels      = readHotelValuations("hotels.data")
meansHotels = meanHotelValuations(hotels)
(assignment, centroids) = kmeans_list(meansHotels, 4, 50)




# Activity 3: Adjusted Rand Index
from sklearn import metrics

# Reference clustering
labels_true = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3]

print metrics.adjusted_rand_score(labels_true,assignment.values())

# Let's test one k-means against another to see if they are more similar
(assignment2, centroids) = kmeans_list(meansHotels, 4, 50)
print metrics.adjusted_rand_score(assignment.values(), assignment2.values())