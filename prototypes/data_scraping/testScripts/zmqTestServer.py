import time
from datetime import datetime as dt
import zmq

class SomeClass():
    def __init__(self):
        self.lastAccess = 0
        self.__accessTime(dt.now())

    def __accessTime(self, dateTime): # update the lastAccess time with new dateTime object h:m
        hr = dateTime.hour
        min = dateTime.minute
        self.lastAccess = (hr, min)

def methodSwitch(message):
    print(message)
    switcher = {
    b'getDotRGB': getDotRGB(),
    b'access' : wrongFunc()
    }
    return switcher.get(message, "invalid")

def wrongFunc(socket):
    socket.send_string('Wrong!')

def getDotRGB(socket):
    dict = {'r':23,'g':34,'b':55}
    socket.send(dict)

def main():
    # set up socket and port listening
    context = zmq.Context()
    socket = context.socket(zmq.REP)
    socket.bind("tcp://*:5555")

    # run the server loop
    while True:
        message = socket.recv()
        print(message)

        # simulate work
        time.sleep(1)

        switcher = {
        b'getDotRGB': getDotRGB(socket),
        b'wrong': wrongFunc(socket)
        }


if __name__ == '__main__':
    main()
