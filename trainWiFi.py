'''
Created on Apr 14, 2016

@author: incognito
'''
import os
import sys
from PyQt4 import QtGui, QtCore
from time import sleep

def ping():
    sleep(1)
    command=("SUDO_ASKPASS=~/ps sudo -A timeout 8s "
            "ping -S2000000 -n -c5000 -i 0.0 -w2 -l2000000 -s1 10.0.0.1 -a -q"
            )
    x=os.system(command)
    print "ping reteruned",x
def log(counter):
    filename="home"+`counter`
    command=("SUDO_ASKPASS=~/ps sudo -A timeout 10s "
             "~/linux-80211n-csitool-supplementary/netlink/log_to_file "+filename+
            " | grep wrote & sleep 1;"
            )
    x=os.system(command)
    print "here we goooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
    print x
    


def trainOneSample(counter):
    filename="home"+`counter`
    command=("SUDO_ASKPASS=~/ps sudo -A timeout 10s "
             "~/linux-80211n-csitool-supplementary/netlink/log_to_file "+filename+
            " | grep wrote & sleep 1;"
            "SUDO_ASKPASS=~/ps sudo -A timeout 8s "
            "ping -S2000000 -n -c5000 -i 0.0 -w2 -l2000000 -s1 10.0.0.1 -a -q"
            )
    x=os.system(command)
    print "here we goooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
    print x
    
# print "hello"
# trainOneSample(1)

class Example(QtGui.QWidget):

    def __init__(self):
        super(Example, self).__init__()
        self.initUI()
        self.counter=10

    def mousePressEvent(self, QMouseEvent):
        print QMouseEvent.pos()
        trainOneSample(self.counter)
        self.counter+=1

    def initUI(self):               

        self.setGeometry(0, 0, 200, 200)
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
