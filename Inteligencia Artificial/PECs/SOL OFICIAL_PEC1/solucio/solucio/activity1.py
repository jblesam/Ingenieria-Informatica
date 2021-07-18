#! /usr/bin/env python
# -*- coding: utf-8 -*-

# Vector with the maximum valuations of each aspect considered
MAX_VALUATIONS = [10.0, 5.0, 5.0, 5.0, 10.0, 5.0, 10.0, 5.0]

# Auxiliary function that receives a list of valuations as read
# from the file and returns it scaled to 0..1
def scaleVals(vals):
    return [(float(vals[i])-1)/(MAX_VALUATIONS[i]-1) for i in range(len(vals))]
    

# Reads hotels.data and returns a dictionary of user valuations as:
# {user: {hotel:[list of valuations]}}
def readUserValuations(filename):
    myfile = file(filename)
    
    lines = [(l.strip()).split("\t") for l in myfile.readlines()]
    # l[1] is the user id
    dictio = {int(l[1]) : {}  for l in lines}
    for l in lines:
        # l[0] is the hotel id, l[2..9] are the user's valuations.
        # Discard valuations with out of range values
        valuations = scaleVals(l[2:])
        if min(valuations)>=0 and max(valuations)<=1:
            dictio[int(l[1])][int(l[0])] = valuations
    return dictio


# Reads hotels.data and returns a dictionary of hotel valuations as:
# {hotel: {user:[list of valuations]}}
def readHotelValuations(filename):
    myfile = file(filename)
    
    lines = [(l.strip()).split("\t") for l in myfile.readlines()]
    # l[0] is the hotel id
    dictio = {int(l[0]) : {}  for l in lines}
    for l in lines:
        # l[1] is the user id, l[2..9] are the user's valuations.
        # Discard valuations with out of range values
        valuations = scaleVals(l[2:])
        print valuations
        if min(valuations)>=0 and max(valuations)<=1:
            dictio[int(l[0])][int(l[1])] = valuations
    return dictio
    
readHotelValuations('hotels.data')
