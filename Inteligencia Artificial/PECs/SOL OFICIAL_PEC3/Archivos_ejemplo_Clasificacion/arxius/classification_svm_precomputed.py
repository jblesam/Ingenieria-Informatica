from random import shuffle
from sklearn import svm
from sklearn import preprocessing
from numpy import mean, std
from math import exp

from sys import exit

# warning filter
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning) 

# function declarations

def classify(kf, train, test):
   trainX = list(map(lambda l: list(map(float, l[0:4])), train))
   testX = list(map(lambda l: list(map(float, l[0:4])), test))
   trainY = list(map(lambda l: l[4], train))
   testY = list(map(lambda l: l[4], test))
   # Standardization
   scaler = preprocessing.StandardScaler().fit(trainX)
   trainXScaled = scaler.transform(trainX)
   testXScaled = scaler.transform(testX)
   
   clf = svm.SVC(kernel='precomputed')
   kernelMatrix = [[kf(t1, t2)
                    for t1 in trainXScaled]
                   for t2 in trainXScaled]
   clf.fit(kernelMatrix, trainY)
   kernelMTest = [[kf(t1, t2)
                   for t1 in trainXScaled]
                  for t2 in testXScaled]
   #predictions = clf.predict(kernelMTest)
   #return sum(map(lambda x, y: x == y, predictions, testY)) / len(testY) * 100
   return clf.score(kernelMTest, testY) * 100

def sets_svm_prec(kf, l, i, k):
   # training set: 4 of each 5 
   train = list(map(lambda x: x[1],
                    filter(lambda v: v[0] % k != i, enumerate(l))))
   # test set: 1 of each 5
   test = list(map(lambda x: x[1],
                   filter(lambda v: v[0] % k == i, enumerate(l))))
   # application of svm
   return classify(kf, train, test)
   
# open file
l = list(map(lambda l: (l.strip()).split(','),
             open('iris.data.txt', 'r').readlines()))
# delete head
#del(l[0])

# examples shuffle
shuffle(l)

# kernel
def KPoly2(a, b):
   return (sum(map(lambda x, y: x*y, a, b)) + 1) ** 2

def KPoly2RBF(a, b, gamma=1):
   return exp(-gamma * (KPoly2(a, a) - 2 * KPoly2(a, b) + KPoly2(b, b)))

kf = KPoly2RBF

# single validation
acc = sets_svm_prec(kf, l, 0, 5)
# Precision
print('Single validation')
print('Accuracy:', round(acc, 1), '%')

# 5 fold cross-validation
k = 5
acc = [sets_svm_prec(kf, l, i, k) for i in range(k)]
# Accuracy
#print(acc)
print(str(k)+'-fold cross-validation')
print('Accuracy:', round(mean(acc), 1), '+-', round(std(acc), 2), '%')
