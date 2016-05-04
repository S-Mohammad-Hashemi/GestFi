'''
Created on Apr 11, 2016

@author: incognito
'''
import socket
import json
clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
clientsocket.connect(('localhost', 32787))
x=[`i` for i in range(1000)]
# firstMsg="helllllooooo\n"
# firstMsg=' '.join(x)
file=open('J_Right/n28')
firstMsg=""
for line in file:
    firstMsg+=line[:-1]
firstMsg+="\n"

clientsocket.send(firstMsg)
print "data is sent"
buf=clientsocket.recv(10240)
print buf