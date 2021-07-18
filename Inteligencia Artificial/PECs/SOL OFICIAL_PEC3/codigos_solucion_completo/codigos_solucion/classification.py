from random import shuffle
from numpy import mean, std
from naiveBayes import naiveBayes
from decisionTrees import DTs
from adaboost import adaBoost
from sklearn import svm

# warning filter
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 


# function declarations
def valor(x):
   return {'N': 0, 'A': 1, 'P':2}[x]

def kfCityBlock(a, b):
   return 2 * 6 - sum(map(lambda x, y:
                          abs(valor(x) - valor(y)), a, b)) 

def SVMs(train, test):
   trainX = list(map(lambda l: l[0:6], train))
   testX = list(map(lambda l: l[0:6], test))
   trainY = list(map(lambda l: l[6], train))
   testY = list(map(lambda l: l[6], test))

   clf = svm.SVC(kernel='precomputed')
   kernelMatrix = [[kfCityBlock(t1, t2)
                    for t1 in trainX]
                   for t2 in trainX]
   clf.fit(kernelMatrix, trainY)
   kernelMTest = [[kfCityBlock(t1, t2)
                   for t1 in trainX]
                  for t2 in testX]
   
   return clf.score(kernelMTest, testY) * 100

def sets_f_prec(l, i, k, f):
   # training set: 4 of each 5 
   train = list(map(lambda x: x[1],
                    filter(lambda v: v[0] % k != i, enumerate(l))))
   # test set: 1 of each 5
   test = list(map(lambda x: x[1],
                   filter(lambda v: v[0] % k == i, enumerate(l))))
   # application of classifier
   return f(train, test)


# open file
l = list(map(lambda l: (l.strip()).split(','),
             open('Qualitative_Bankruptcy.data.txt', 'r').readlines()))

# examples shuffle
shuffle(l)

# 5 fold cross-validation
k = 5
print(str(k)+'-fold cross-validation')

# Naive Bayes
print('Naive Bayes')
acc = [sets_f_prec(l, i, k, naiveBayes) for i in range(k)]
print('  Accuracy:', round(mean(acc), 1), '+-', round(std(acc), 1), '%')

# DTs
print('Decision Trees')
acc = [sets_f_prec(l, i, k, DTs) for i in range(k)]
print('  Accuracy:', round(mean(acc), 1), '+-', round(std(acc), 1), '%')

# AdaBoost
print('AdaBoost')
acc = [sets_f_prec(l, i, k, adaBoost) for i in range(k)]
print('  Accuracy:', round(mean(acc), 1), '+-', round(std(acc), 1), '%')

# Support Vector Machines
print('Support Vector Machines (CityBlock)')
acc = [sets_f_prec(l, i, k, SVMs) for i in range(k)]
print('  Accuracy:', round(mean(acc), 1), '+-', round(std(acc), 1), '%')
