'''
Created on Mar 2, 2016

@author: incognito
'''
import random
def load_data_test(folder,label,X,Y,test_x,test_y):
    for k in xrange(1,31):
        name=folder+"/"+str(k)
        file=open(name,'r')
        mylist=[]
        x=0
        for line in file:
#             print x
#             x+=1
            line=line[:-1]
            temp=line.split(' ')
            for i in range(len(temp)-1):
#                 print temp[i]
                mylist.append(float(temp[i]))
        mylist=mylist+[0]*(5000*9-len(mylist))
#         print len(mylist)
#         if k%5!=0:
#             X.append(mylist)
#             Y.append(label)
#         else:
        test_x.append(mylist)
        test_y.append(label)
#     print len(test_x),len(test_y),len(X),len(Y)
    
    
    
def load_data(folder,label,X,Y,test_x,test_y):
    for k in xrange(1,101):
        name=folder+"/"+str(k)
        file=open(name,'r')
        mylist=[]
        x=0
        for line in file:
#             print x
#             x+=1
            line=line[:-1]
            temp=line.split(' ')
            for i in range(len(temp)-1):
#                 print temp[i]
                mylist.append(float(temp[i]))
        mylist=mylist+[0]*(5000*9-len(mylist))
#         print len(mylist)
        if k%110!=0:
            X.append(mylist)
            Y.append(label)
        else:
            test_x.append(mylist)
            test_y.append(label)
#     print len(test_x),len(test_y),len(X),len(Y)
    
def trainModel():
    from sklearn import svm
    X=[]
    Y=[]
    test_x=[]
    test_y=[]
#     push,right,up: accuracy: 95.5%
#     push,right,left,up: accuracy: 88.24%
    load_data("forward", 0, X, Y,test_x,test_y)
    load_data("backward", 1, X, Y,test_x,test_y)
    load_data("M", 2, X, Y,test_x,test_y)
    
    
    load_data_test("forward_test", 0, X, Y,test_x,test_y)
    load_data_test("backward_test", 1, X, Y,test_x,test_y)
    load_data_test("M_test", 2, X, Y,test_x,test_y)
#     load_data("J_Left", 3, X, Y,test_x,test_y)
#     load_data("prev", 3, X, Y,test_x,test_y)
#     load_data("ff", 4, X, Y,test_x,test_y)
#     load_data("ff2", 5, X, Y,test_x,test_y)
#     load_data("rewind", 6, X, Y,test_x,test_y)
#     load_data("rewind2", 7, X, Y,test_x,test_y)
#     load_data("like", 8 , X, Y,test_x,test_y)
#     load_data("unlike", 9, X, Y,test_x,test_y)
    combined = zip(X, Y)
    random.shuffle(combined)
    X[:], Y[:] = zip(*combined)
#     print Y
    print "start learning..."
    print len(test_x[0])
# ('linear', 0, 0, 0.17)
    for kk, dd, gg, cc in [('linear', 0, 0, 0.17),
                                ('poly', 1, 0, 5),
                                ('poly', 2, 0, 5),
                                ('poly', 3, 0, 5),
                                ('rbf', 0, 2000, 0),
                                ('rbf', 0, 100, 0)]:
        # Fit the model
        clf = svm.SVC(kernel=kk, degree=dd, coef0=cc, gamma='auto')
        clf.fit(X, Y)
        
        y_predict=clf.predict(test_x)
        correct=0
        for i in range(len(y_predict)):
            if y_predict[i]==test_y[i]:
                correct+=1
#             else:
#                 print y_predict[i],test_y[i]
        accuracy=(correct+0.0)/len(y_predict)
        accuracy=accuracy*100
        print kk, accuracy
#         return clf
              
trainModel()