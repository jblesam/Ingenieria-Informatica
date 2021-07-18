###
# A multiple RkNN implementation for feature selection
#********************************************************
# This code is dvideds in two blocks:
#
#1st block: MODEL CONSTRUCTION
##
##Based upon Li S, Harner EJ, Adjeroh DA. Random KNN feature selection algorithm this code
#splits dataset in s subsets of a random features. Then applies knn for each subset and stores tha accuracy and 
#thesubset attributes. By a polling the construction model returns the most representive features
#in dataset ranked from best to worst feature.
#
#2nd block: MODEL TEST
##
#Reduces dimensionality of  a dataset selecting the a features(columns) selected by the model. Then
#applies simple knn to the dataset and print ressults
# Author   : Luis Arribas
# Creation : 24-May-2018
###

from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from random import randint
from time import time
import numpy as np
#######################################
###     DATA ARRANGE FUNCTIONS      ###
#######################################
def prepare_test_data(inputFile, bestAttributes):
    """Prepares the data in for kNN in the model TEST.
    - Data must be previously shuffled
    - First row is skipped
    - Last column is ground truth (i.e. class)
    - Standardization is performed to all data"""
    inputData=np.loadtxt(open(inputFile), delimiter=",", skiprows=1, dtype='float')
    np.random.shuffle(inputData)
    filteredData=np.take(inputData,bestAttributes,1)
    [trainData, testData]= train_test_split(filteredData, test_size=0.75, random_state=42,shuffle=False)
    a=trainData.shape[0]
    #44
    c=inputData.shape[0]
    #178
    #Get ground truth
    trainGT=inputData[0:a,-1]
    #print(trainGT.shape)
    testGT=inputData[a:c,-1]
    # Get means and standard deviations of train data
    theMean=np.mean(trainData,0)
    theStd=np.std(trainData,0)
    # Standardize test and train using train mean and standard deviation
    trainData-=theMean
    trainData/=theStd
    testData-=theMean
    testData/=theStd
    return [trainData,trainGT.astype(int),testData,testGT.astype(int),theMean,theStd] 

def support_poll(ranking):
    "returns a list of keys sorted by their values "
    poll=[]
    ranking.sort(key=lambda list: list[1])
    for x in ranking:
        poll.append(x[0])
    return (poll)  

def create_random_indexes(data, attNum, subsetsNum):
    "returns a set of sets of random indexes"
    indexes= []
    randomSet=[]
    for x in range (0, subsetsNum):
        randomSet=[]
        y=0
        while y< attNum:
            att=randint(0, (data.shape[1]-2))
            if att not in randomSet:
                randomSet.append(att)
                y=y+1
        indexes.append(randomSet)
    return(indexes)

def create_subset(inputData, label):
    "Creates a subset of n attributes"
    data=np.take(inputData, label, 1)
    return (label,data)

def prepare_data(inputFile):
    """Loads and prepares the data for creating random subsets.
    - The file must be CSV
    - First row is skipped
    - Data is shuffled"""
    inputData=np.loadtxt(open(inputFile), delimiter=",", dtype='str')
    labels=np.take(inputData, 0, 0)
    labels=np.take(labels, [0,1,2,3,4,5,6,7,8,9,10,11,12], 0)
    inputData=np.loadtxt(open(inputFile), delimiter=",", skiprows=1, dtype='float')
    np.random.shuffle(inputData)
    return [inputData,labels]

def prepare_subset_data(inputData, shuffleData):
    """Prepares the data in train and test sets for model construcction.
    - Data must be shuffled
    - First row is not skipped
    - Last column is ground truth (i.e. class)
    - Standardization is performed to all data"""
    [trainData, testData]= train_test_split(inputData, test_size=0.75, random_state=42, shuffle=False)
    #set ground truth
    a=trainData.shape[0]
    #44
    c=shuffleData.shape[0]
    #178
    trainGT=shuffleData[0:a,-1]
    #print(trainGT.shape)
    testGT=shuffleData[a:c,-1]
    # Retrieve the samples (all but the last column)
    trainData=trainData[:,:-1]
    testData=testData[:,:-1] 
    # Get means and standard deviations of train dataº
    theMean=np.mean(trainData,0)
    theStd=np.std(trainData,0)
    # Standardize test and train using train mean and standard deviation
    trainData-=theMean
    trainData/=theStd
    testData-=theMean
    testData/=theStd
    # Return the standardized data and the ground truth
    return [trainData,trainGT.astype(int),testData,testGT.astype(int),theMean,theStd]

def prepare_poll_data(inputData):
    """Prepares data input for kNN in the support poll.
    - Data must be previously shuffled
    - Last column is ground truth (i.e. class)
    - Standardization is performed to all data"""
    [trainData, testData]= train_test_split(inputData, test_size=0.75, random_state=42, shuffle=False)
    #set ground truth
    trainGT=trainData[:,-1]
    testGT=testData[:,-1]
    # Get the classes (last column)
    trainData=trainData[:,:-1]
    testData=testData[:,:-1]
    # Get means and standard deviations of train data
    theMean=np.mean(trainData,0)
    theStd=np.std(trainData,0)
    # Standardize test and train using train mean and standard deviation
    trainData-=theMean
    trainData/=theStd
    testData-=theMean
    testData/=theStd
    # Return the standardized data and the ground truth
    return [trainData,trainGT.astype(int),testData,testGT.astype(int),theMean,theStd]


#######################################
###  ###  CLASSIFY    FUNCTIONS ### ###     
#######################################
def knn_1(k, subset, shuffleData):
    """applies kNN to a subsets in order to get its accuracy"""
    [trainData,trainGT,testData,testGT,theMean,theStd]=prepare_subset_data(subset, shuffleData)
    assignedClasses=KNeighborsClassifier(n_neighbors=k).fit(trainData,trainGT).predict(testData)
    return (get_accuracy(assignedClasses, testGT))

def knn_2(k, subset, shuffleData):
    """applies knn to a dataset. Returns whole data for results analisys"""
    [trainData,trainGT,testData,testGT,theMean,theStd]=prepare_subset_data(subset, shuffleData)
    assignedClasses=KNeighborsClassifier(n_neighbors=k).fit(trainData,trainGT).predict(testData)
    return (assignedClasses,testGT,theMean,theStd)
     
#######################################
###  ### ANALISYS   FUNCTIONS ### ###     
#######################################
def select_best_attributes(ranking,labels, shuffleData, k, p, a): 
    """Selects the a(maximum) features and the models accuracy using just those features"""
    maxAccuracy=0
    bestAtributes=[]
    if a>len(ranking):
        a=len(ranking)
    sets=len(ranking)    
    for x in range(1,sets):
        reducedData=np.take(shuffleData, ranking, 1)
        [theClasses,groundTruth,theMean,theStd]=(knn_2(k, reducedData, shuffleData))
        accuracy=get_accuracy(theClasses,groundTruth)
        if accuracy<p:
            if accuracy>=maxAccuracy:
                if x>(sets-a):
                    maxAccuracy=accuracy
                    bestAtributes=list(ranking)
        ranking.pop()
    return(bestAtributes,maxAccuracy)
    
def get_accuracy(theClasses,groundTruth):
    """Computes the accuracy has the ratio between true estimates and total estimates"""
    trueEstimates=np.count_nonzero((theClasses-groundTruth)==0)
    totalEstimates=len(theClasses)
    return float(trueEstimates)/float(totalEstimates)

def count_errors(theClasses,groundTruth):
    "returns errors number"
    q=0
    for item_a, item_b in zip(theClasses,groundTruth):
        if item_a != item_b:
            q=q+1
    return q

#######################################
###     PRINT FUNCTIONS ### ###     ###
#######################################
def print_model_results(bestAttributes,maxAccuracy, elapsedTime,k, p, subsetsNum, attNum, a):
    """Prin tmodel construction results"""
    print('           * * * * * R k N N   F E A T U R E    S E L E C T I O N   R E S U L T S * * * *')
    print('\n')
    print('[MODEL PARAMETERS]')
    print('\n')
    print(' - K= '+str(k))
    print('\n')
    print(' - MAXIUM ACCURACY:'+str(p*100)+'%')
    print('\n')
    print(' - RANDOM SUBSETS GENERATED: '+str(subsetsNum))
    print('\n')
    print(' - ATTRIBUTES PER SUBSET   : '+str(attNum))
    print('\n')
    print(' - MAXIMUM NUMBER OF ATTRIBUTES   : '+str(a))
    print('\n')
    print('[RESULTS]')
    print('\n')
    print(' - MOST REPRESENTATIVE FEATURES      : '+str(bestAttributes))
    print('\n')
    print(' - PREDICTED ACCURACY OF THE MODEL   : '+str(maxAccuracy*100)+'%')
    print('\n')
    print(' - MODEL CONSTRUCTION TIME           : '+str(elapsedTime))
    print('\n')    
    
def print_test_results(theMean,theStd,assignedClasses,testGT, elapsedTime):
    """Print test execution results using the model"""
    print('\n')
    print('           * * * * * R k N N    M O D E L   T E S T    R E S U L T S * * * *')
    print('\n')
    print('[STANDARDIZATION PARAMETERS]')
    print(' - MEAN: '+str(theMean))
    print(' - STD: '+str(theStd))
    print('\n')
    print('[CLASSES]')
    print(' - KNN           : '+str(assignedClasses))
    print(' - GROUND TRUTH  : '+str(testGT))
    print('\n')
    print(' - ACCURACY      : '+str(100*get_accuracy(assignedClasses,testGT))+'%')
    print('\n')
    print(' - TOTAL ERRORS     : '+str(count_errors(assignedClasses, testGT)))
    print('\n')
    print('\n')
    print(' -CONFUSION MATRIX:     :\n\n '+str(confusion_matrix(testGT, assignedClasses, labels=[1, 2, 3])))
    print('\n')
    print(' - MODEL EXECUTION TIME           : '+str(elapsedTime))
    print('\n')    
    
    print('                       * * * * * E N D * * * *')
       
#######################################
### MODEL CONSTRUCTION AND TEST ### ### 
#######################################
def model(k,p,a,subsetsNum, attNum, inputFile):
    """Builds a model of i features form a j features dataset 
    where i<j loosing as less accuracy as possible(best effort)"""
    #set execution parameters
    attNum-=1
    startTime=time()
    subsets=[]
    headers=[]
    accuracy=[]
    ranking=[]
    # Configure numpy print options
    np.set_printoptions(formatter={'float':lambda x: '%.2f'%x})
    #Shuffle data and get labels
    [shuffleData, labels]=prepare_data(inputFile)
    #Create data subsets
    indexes=create_random_indexes(shuffleData,attNum,subsetsNum)
    for x in indexes:
        [heading, subSet]=create_subset(shuffleData, x)
        subsets.append(subSet)
        headers.append(heading)
    #Apply knn for each subset and get accuracy   
    for x in subsets:
        accuracy.append(knn_1(k, x, shuffleData))
    headers=np.asarray(headers)
    accuracy=np.asarray(accuracy)
    #Create a ranking 
    for x in range(0,len(labels)):
        mean=0
        count=0
        sum=0
        i=0
        for y in np.nditer(headers):
            row=i//attNum
            if x==y:
                sum+=accuracy[row] 
                count+=1
            i+=1 
        if count>0:
            mean=sum/count
        ranking.append([x, mean])
    ranking=support_poll(ranking)
    #Select most relevant attributes and models accuracy
    [bestAttributes,maxAccuracy]=select_best_attributes(ranking, labels, shuffleData, k, p, a)
    #elapsed time
    endTime=time()
    elapsedTime=endTime-startTime
    print_model_results(bestAttributes,maxAccuracy, elapsedTime,k, p, subsetsNum, attNum,a)
    return([k, bestAttributes,inputFile])
    
def test(k, bestAttributes,inputFile):
     """Runs the built model with the best features """
     startTime=time()
     [trainData,trainGT,testData,testGT,theMean,theStd]=prepare_test_data(inputFile, bestAttributes)
     assignedClasses=KNeighborsClassifier(n_neighbors=k).fit(trainData,trainGT).predict(testData)
     endTime=time()
     elapsedTime=endTime-startTime
     print_test_results(theMean,theStd,assignedClasses,testGT,elapsedTime)
   
#####################
###     RUN       ###
##################### 
""" run both model construction and afterwards rmodel test with those results"""
#number of closest neiborghs 
k=1
#maximun accuracy allowed. In order to adjust returned feature ranking
p=1
#The a features in the constructed model
a=7
#Number of random subsets generated
s=1000
#Number of subsattributes per dataset split
n=5
#csv file containing the whole dataset
inputFile='wine3c_pract.csv'
#Build the model
[k, bestAttributes,inputFile]=model(k,p,a,s,n, inputFile)
#test the model
test(k, bestAttributes,inputFile)