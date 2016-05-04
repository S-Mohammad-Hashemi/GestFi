'''
Created on Apr 19, 2016

@author: incognito
'''
import matlab.engine
import os
import sys
from PyQt4 import QtGui, QtCore

# eng.triarea(nargout=0)




class Example(QtGui.QWidget):

    def __init__(self):
        self.eng = matlab.engine.start_matlab()
        super(Example, self).__init__()
        self.initUI()
        self.counter=10

    def mousePressEvent(self, QMouseEvent):
        print QMouseEvent.pos()
        self.counter+=1
        ret = self.eng.triarea(self.counter,5.0)
        print(ret)

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