'''
Created on Apr 14, 2016

@author: incognito
'''
import os
import sys
from PyQt4 import QtGui, QtCore
from time import sleep
import threading
import matlab.engine
import svmTrain
from sklearn import preprocessing
import socket
def ping():
    sleep(1)
    # 10.0.0.1 : comcast modem in home
    command=("SUDO_ASKPASS=~/ps sudo -A timeout 8s "
            "ping -S2000000 -n -c5000 -i 0.0 -w2 -l2000000 -s1 10.201.28.1 -a -q"
            )
    x=os.system(command)
    print "ping reteruned",x

def logJincao(counter):
    filename="test"
    command=("SUDO_ASKPASS=~/ps sudo -A timeout 2s "
             "~/linux-80211n-csitool-supplementary/netlink/log_to_file "+filename+
            " | grep wrotke"
            )
    x=os.system(command)
#     print "here we goooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
#     print x
    
def log(counter):
#     filename="home"+`counter`
    filename="test"
    command=("SUDO_ASKPASS=~/ps sudo -A timeout 8s "
             "~/linux-80211n-csitool-supplementary/netlink/log_to_file "+filename+
            " | grep wrote"
            )
    x=os.system(command)
    print "here we goooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
    print x
    


    
# print "hello"
# trainOneSample(1)

class Example(QtGui.QWidget):



    def trainOneSample(self,counter):
#         t1=threading.Thread(target=log,args=(counter,))
#         t2=threading.Thread(target=ping)
#         t1.start()
#         t2.start()
#         t1.join()
#         t2.join()
        logJincao(counter)
#         print "end of trainOneSample"
#         ret = self.eng.triarea(self.counter,5.0)
        ret=self.eng.moh_test_vector()
#         print type(ret)
#         print 'i',len(ret),'j',len(ret[0])
#         print ret[0]
#         test_x=[[]]
############################# For Creating train feature files
        print "counter is >>>>>> ",counter
        vecFile=open(`counter`,'w')
        for j in range(len(ret[0])):
            for i in range(len(ret)):
                vecFile.write(`ret[i][j]`+' ')
            vecFile.write('\n')
        vecFile.close()
##############################         for testing
#         test_x=[[]]
#         sample=[]
#         for j in range(len(ret[0])):
#             sample.append([])
#             for i in range(len(ret)):
#                 sample[j].append(ret[i][j])
# #         print 'si',len(sample),'sj',len(sample[0])
#         nums_normalized=preprocessing.scale(sample)
#         msg=""
#         for line in nums_normalized:
#             for x in line:
# #                 print "x isssss: ",x
#                 msg+=str(x)+" "
#                 test_x[0].append(x)
#         print 'testing...',len(test_x[0])
#         clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#         clientsocket.connect(('localhost', 32787))
# #         msg=' '.join(nums_normalized)
#         msg+='\n'
#         clientsocket.send(msg)
#         print "data is sent"
#         buf=clientsocket.recv(1024)
#         print buf


#         test_x=[[]]
#         sample=[]
#         for j in range(len(ret[0])):
#             sample.append([])
#             for i in range(len(ret)):
#                 sample[j].append(ret[i][j])
#         nums_normalized=preprocessing.scale(sample)
#         for line in nums_normalized:
#             for x in line:
# #                 msg+=str(x)+" "
#                 test_x[0].append(x)
# 
#         result=self.clf.predict(test_x)
#         labels=['forward','backward','M']
#         print "Label is >>>>>>>",labels[result[0]]

#         labels=['Push','Right','Up','Left']
#         print "Label is",labels[]

    def __init__(self):
        self.clf=svmTrain.trainModel()
        self.eng = matlab.engine.start_matlab()
        super(Example, self).__init__()
        self.initUI()
        self.counter=1

    def mousePressEvent(self, QMouseEvent):
        print QMouseEvent.pos()
        self.trainOneSample(self.counter)
        self.counter+=1

    def initUI(self):               

        self.setGeometry(0, 0, 400, 500)
        self.setWindowTitle('Quit button')    
        #self.connect("clicked", self.test)
        self.show()
    def test(self):
        print "test"

def main():

    app = QtGui.QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
