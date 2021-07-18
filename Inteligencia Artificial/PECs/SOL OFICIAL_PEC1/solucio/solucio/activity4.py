#! /usr/bin/env python
# -*- coding: utf-8 -*-

from math import sqrt

from recommenders import weightedRating

from activity1 import readUserValuations

# Read favorits.data file, return {user: favorite hotel}
def readFavorites(filename):
    myfile = file(filename)
    
    lines = [(l.strip()).split("\t") for l in myfile.readlines()]
    # l[0] is the user id, l[1] the hotel id
    dictio = {int(l[0]) : int(l[1])  for l in lines}
    return dictio
    

# Read files in the proper format
valuations = readUserValuations("hotels.data")
favorites  = readFavorites("favorits.data")    

# A simple Pearson correlation function between two lists
def simplePearson(list1, list2):
    mean1 = sum(list1)
    mean2 = sum(list2)

    num  = sum([(list1[i]-mean1)*(list2[i]*mean2) for i in range(len(list1))])    
    den1 = sqrt(sum([pow(list1[i]-mean1, 2) for i in range(len(list1))]))
    den2 = sqrt(sum([pow(list2[i]-mean2, 2) for i in range(len(list2))]))
    den  = den1*den2

    if den==0:
        return 0

    return num/den


# Compute the mean Pearson coeff between a pair of users
# Input two diccionaries with ratings of each user {hotel: [valuations]}
def pearsonCoeff_list(user1, user2):
    # Retrieve the hotels common to both users
    commons  = [x for x in user1 if x in user2]
    nCommons = float(len(commons))

    # If there are no common elements, return zero; otherwise
    # compute the coefficient
    if nCommons==0:
        return 0

    # Compute the mean Pearson coeff for all common hotels
    return sum([simplePearson(user1[x], user2[x]) for x in commons])/nCommons



# Run the recommender. We get {user: (list of recommended hotels in desc order)}
recomPearson = {usr : zip(*weightedRating(valuations, usr, pearsonCoeff_list))[0]
                   for usr in valuations.keys() }
                   
# Finally compute the average position of the favorite hotel in the 
# recommendation for each user. The closest to position 0, the better the
# recommender has performed
positions = [recomPearson[usr].index(favorites[usr]) for usr in favorites]                    

meanPosition = sum(positions)/float(len(positions))
print meanPosition