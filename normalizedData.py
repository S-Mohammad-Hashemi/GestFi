'''
Created on Apr 26, 2016

@author: incognito
'''
from sklearn import preprocessing
# folders=['J_Push','J_Left','J_Right','J_Up']
folders=['forward','backward','M']
# for folder in folders:
#     for i in xrange(30,31):
#         address=folder+'/'+`i`
#         normAddress=folder+'/n'+`i`
#         file=open(address)
#         normFile=open(normAddress,'w')
#         for line in file:
#             line=line[:-1]
#             tokens=line.split(' ')[:-1]
#             nums=[float(s) for s in tokens]
#             max_num=max(nums)
#             min_num=min(nums)
#             divisor=max_num-min_num
#             for x in nums:
#                 normalized_num=str((x-min_num)/divisor)
#                 normFile.write(normalized_num+' ')
#             normFile.write('\n')
#         file.close()
#         normFile.close()

##### scikit normalization
# for folder in folders:
#     for i in xrange(1,31):
#         address=folder+'/'+`i`
#         normAddress=folder+'/n'+`i`
#         file=open(address)
#         normFile=open(normAddress,'w')
#         for line in file:
#             line=line[:-1]
#             tokens=line.split(' ')[:-1]
#             nums=[[float(s) for s in tokens]]
#             nums_normalized=preprocessing.normalize(nums)
#             for x in nums_normalized[0]:
#                 normFile.write(`x`+' ')
#             normFile.write('\n')
#         file.close()
#         normFile.close()

for folder in folders:
    print folder
    for i in xrange(1,101):
        print i
        address=folder+'/'+`i`
        normAddress=folder+'/n'+`i`
        file=open(address)
        normFile=open(normAddress,'w')
        nums=[]
        for line in file:
            line=line[:-1]
            tokens=line.split(' ')[:-1]
            nums.append([float(s) for s in tokens])
        nums_normalized=preprocessing.scale(nums)
        for line in nums_normalized:
            for x in line:
                normFile.write(`x`+' ')
            normFile.write('\n')
        file.close()
        normFile.close()