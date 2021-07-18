ratings = {1: {2:3,3:1,5:4,6:3,7:5}, 2: {1:4,2:1,3:3,5:5,8:2},
           3: {1:2,2:1,4:5,8:1},     4: {1:3,3:2,6:5,8:4}}
from math import sqrt

def euclideanDist(dic1, dic2):
    # Compute the sum of squares of the elements common
    # to both dictionaries
    sum2 = sum([pow(dic1[elem]-dic2[elem], 2)
                for elem in dic1 if elem in dic2])
    return sqrt(sum2)

def euclideanSimilarity(dic1, dic2):
    return 1/(1+euclideanDist(dic1, dic2))
	
def pearsonCoeff(dic1, dic2):
    # Retrieve the elements common to both dictionaries
    commons  = [x for x in dic1 if x in dic2]
    nCommons = float(len(commons))

    # If there are no common elements, return zero; otherwise
    # compute the coefficient
    if nCommons==0:
        return 0

    # Compute the means of each dictionary
    mean1 = sum([dic1[x] for x in commons])/nCommons
    mean2 = sum([dic2[x] for x in commons])/nCommons

    # Compute numerator and denominator
    num  = sum([(dic1[x]-mean1)*(dic2[x]-mean2) for x in commons])
    den1 = sqrt(sum([pow(dic1[x]-mean1, 2) for x in commons]))
    den2 = sqrt(sum([pow(dic2[x]-mean2, 2) for x in commons]))
    den  = den1*den2

    # Compute the coefficient if possible or return zero
    if den==0:
        return 0

    return num/den
    
def readRatings(filename="u.data"):
    lines = [(l.strip()).split("\t")
        for l in (open(filename).readlines())]
    dictio = {int(l[0]) : {}  for l in lines}
   
    for l in lines:
        dictio[int(l[0])][int(l[1])] = int(l[2])   
    return dictio

# Produces a sorted list of global ratings from a dictionary of
# user ratings, in the form
# [(movieId, globalRating)]
def meanGlobalRatings(dictio):
    # Auxiliary dictionary {movieId: [ratings]}
    aux = {}
    for userValue in dictio.values():
        for movieId in userValue:
            if not aux.has_key(movieId):
                aux[movieId] = []
            aux[movieId].append(userValue[movieId])                

    # Compute and sort global ratings
    mean   = lambda x: sum(x)/float(len(x))
    result = [(p, mean(aux[p])) for p in aux]
    result.sort(key = lambda x: x[1], reverse=True)
    return result

# Produces a sorted list of weighted ratings from a dictionary of
# user ratings and a user id.
# You can choose the function of similarity between users.
def weightedRating(dictio, user, similarity = pearsonCoeff):
    # In the first place a dictionary is generated with the similarities
    # of our user with all other users.
    # This dictionary could be stored to avoid recomputing it.
    simils = {x: similarity(dictio[user], dictio[x])
              for x in dictio if x != user}

    # Auxiliary dictionaries {movieId: [rating*users similarity]}
    # and {movieId: [users similarity]} (numerator and denominator
    # of the weighted rating)
    numerator   = {}
    denominator = {}

    # The ratings dictionary is traversed, while filling the auxiliary
    # dictionaries with the values found.
    for userId in simils:
        for movieId in dictio[userId]:
            if not numerator.has_key(movieId):
                numerator  [movieId] = []
                denominator[movieId] = []
            s = simils[userId]
            # PAC1 2014: add the sum of valorations as there are many of them
            numerator  [movieId].append(sum(dictio[userId][movieId])*s)
            denominator[movieId].append(s)

    # Compute and sort weighted ratings    
    result = []
    for movieId in numerator:
        s1 = sum(numerator  [movieId])
        s2 = sum(denominator[movieId])
        if s2 == 0:
            mean = 0.0
        else:
            mean = s1/s2

	# Append the rating only if the user does not have it already
	if not dictio[user].has_key(movieId):
	        result.append((movieId,mean))

    result.sort(key = lambda x: x[1], reverse=True)
    return result
