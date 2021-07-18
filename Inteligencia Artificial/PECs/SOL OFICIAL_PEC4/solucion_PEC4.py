# -*- coding: utf-8 -*-

from numpy import array
from sklearn import preprocessing
import warnings
import random

###############################################################################
# Question 1: data loading and creation of validation tests
warnings.filterwarnings('ignore')
    
# Load data file and normalize values
values = list(map(lambda l: [int(x) for x in (l.strip()).split()],
             open("mfeat-fac.txt", 'r').readlines() ))
values = preprocessing.scale(array(values))

# Data labels: first 200 samples are 0's, next 200 are 1's, and so on    
labels = [x//200 for x in range(2000)]


# Make train, test and validation sets. Set a random seed so results are repeatable
random.seed(723)
# Shuffle indices. Samples per class should be balanced, this should be checked
indices = range(2000)
random.shuffle(indices)

# Take 60% train, 20% test, 20% validation
ind1 = int(2000*0.6)
ind2 = ind1 + int(2000*0.2)

xTrain = [values[i] for i in indices[:ind1]]
xTest  = [values[i] for i in indices[ind1:ind2]]
xValid = [values[i] for i in indices[ind2:]]
yTrain = [labels[i] for i in indices[:ind1]]
yTest  = [labels[i] for i in indices[ind1:ind2]]
yValid = [labels[i] for i in indices[ind2:]]


# Classifier parameter ranges. Gamma ranges depends on the range of the data,
# as we have scaled them they are small and so is gamma
MIN_C = 1e-4
MAX_C = 1e4
MIN_GAMMA = 1e-4
MAX_GAMMA = 1


###############################################################################
# Question 2: objective function

# The objective function has to be related with the performance of the 
# classifier. In this case, we take the score value given by sklearn
# (actually 1 - score so the function has to be minimized to 0)

from sklearn.svm import SVC
import math

def objectiveFunc(solution):
    svc = SVC(C=solution[0], gamma=solution[1])
    svc.fit(xTrain, yTrain)
    score = svc.score(xTest, yTest)
    return 1 - score
    

# This function does the same but on the validation data
def validate(solution):
    svc = SVC(C=solution[0], gamma=solution[1])
    svc.fit(xTrain, yTrain)
    score = svc.score(xValid, yValid)
    return 1 - score
    
    
    
###############################################################################
# Question 3: simulated annealing optimization

# Generate neighbour: multiply or divide by 1.1 one of the parameters and stay in the range
def generateNeighbour(state):
    if random.choice(['C', 'gamma']) == 'C':
        newC     = state[0]*random.choice([1.1, 1/1.1])
        if newC < MIN_C:
            newC = MIN_C
        if newC > MAX_C:
            newC = MAX_C
        newState = [newC, state[1]]
    else:
        newGamma = state[1]*random.choice([1.1, 1/1.1])
        if newGamma < MIN_GAMMA:
            newGamma = MIN_GAMMA
        if newGamma > MAX_GAMMA:
            newGamma = MAX_GAMMA
        newState = [state[0], newGamma]

    return newState

# Accept a new state or not
def accept(energy, newEnergy, iterations, factor):
   
    if newEnergy < energy:
        return True
    else:
        value = math.exp((energy-newEnergy)/
                         (iterations*factor))
        return random.random() < value

# Apply simulated annealing to a SVC configuration with a given tolerance
def simulAnnealing(initialState, tolerance, iterations):
    
    factor = tolerance / float(iterations)
    
    # Compute the objective function (classif error) of the initial state
    state = initialState[:]    
    currentError = objectiveFunc(state)    
    
    # Store the best state found and iterate
    best = state[:]
    bestError = currentError
    
    for i in range(iterations):
        newState = generateNeighbour(state)
        newError = objectiveFunc(newState)
        
        if accept(currentError, newError, i+1, factor):
            state = newState
            currentError = newError
            
            if newError < bestError:
                best = state[:]
                bestError = currentError
                
    return best
        

# Call the optimizer with an arbitrary initial state [1.,.1]
# Note that the tolerance depends on the scale of the objective function output
#bestConfig = simulAnnealing([1.,.1], 0.1, 50)

#print("Best result (test data): ", bestConfig, 1-objectiveFunc(bestConfig))
#print("Best result (validation data): ", bestConfig, 1-validate(bestConfig))


###############################################################################
# Question 4: genetic algorithms
from random import random, uniform, sample, choice

# Generates a random individual (configuration) in the given range
def generateIndividual():
    C = uniform(MIN_C, MAX_C)
    gamma = uniform(MIN_GAMMA, MAX_GAMMA)
    return [C, gamma]

# Cross two individuals; the strategy cannot be other than mixing one's C
# with the other's gamma. It crosses the two individuals at the given positions
def cross(population, positions):
    return [population[positions[0]][0], population[positions[1]][1]]

# Mutate a given individual by multiplying one of its parameters (and 
# checking it remains in the range)
def mutate(individual, rate):
    if random() < rate:
        if choice(['C', 'gamma']) == 'C':
            newC     = individual[0]*choice([1.1, 1/1.1])
            if newC < MIN_C:
                newC = MIN_C
            if newC > MAX_C:
                newC = MAX_C
            newIndiv = [newC, individual[1]]
        else:
            newGamma = individual[1]*choice([1.1, 1/1.1])
            if newGamma < MIN_GAMMA:
                newGamma = MIN_GAMMA
            if newGamma > MAX_GAMMA:
                newGamma = MAX_GAMMA
            newIndiv = [individual[0], newGamma]
    
        return newIndiv
    else:
        return individual[:]
    


# Evolves the population for a number of generations
def evolve(population, generations):

    # Sorts the population by classification ratio (first worst classifiers,
    # that is the reason for the minus sign)
    population.sort(key=lambda x:-objectiveFunc(x))    

    # Some values
    N           = len(population)
    mutationRate = 0.01
    
    # Generates a list of the form [0,1,1,2,2,2,...] with the probabilities
    # of each individual to reproduce
    reproductionChances = [x for x in range(N) for y in range(x+1)]

    for i in range(generations):
        # Generate N-1 descendants by crossing
        descendants = [cross(population,sample(reproductionChances,2)) for x in range(N-1)]

        # Apply mutations with a given probability
        descendants = [mutate(x, mutationRate) for x in descendants]
        
        # Elitism: keep the best individual (to avoid dropping results)
        descendants.append(population[-1])
        population = descendants

        # Sort individuals by classif ratio
        population.sort(key=lambda x:-objectiveFunc(x))
            

    # Finally return the best individual
    return population[-1]


# Create a initial population
POP_SIZE = 10
GENERATIONS = 50
population = [generateIndividual() for i in range(POP_SIZE)]

# Apply the genetic algorithm

best = evolve(population, GENERATIONS)
print(best, 1-objectiveFunc(best))                    

print(best, 1-validate(best))