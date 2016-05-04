'''
Created on Apr 24, 2016

@author: incognito
'''

"""
pca bayad rooye 30 ta sub carrier bezanam to be 4 bod tabdilesh konam. 
yani baraye har gesture mishe 4*5000 bejaye 30*5000
"""

from sklearn.decomposition.pca import PCA
import matlab.engine
# x1=[1,5,45,55,7,73,221,13]
# x2=[2,3,345,7,7,32,23,6]
# x3=[15,16,17,18,-23,-3434,33,99]
# l=[x1,x2,x3]
# print l
# eng = matlab.engine.start_matlab()
X=[]
for i in xrange(1,30):
    file=open('J_Left/'+`i`)
    mylist=[]
    x=0
    for line in file:
        line=line[:-1]
        temp=line.split(' ')
        for i in range(len(temp)-1):
#             print temp[i]
            mylist.append(float(temp[i]))
    mylist=mylist+[0]*(5000*9-len(mylist))
    X.append(mylist)
print 'len of X',len(X)
pca=PCA(n_components=4)
t=pca.fit_transform(X)
l=[]
for v in t:
    arr=[]
    for e in v:
        f=float(e)
        arr.append(f)
    l.append(arr)
# ret = eng.moh_pca(l)

print l
print type(l)
print 'len of t',len(t)

