from bottle import route, run, template
import time
import threading
from PIL import Image

dot = {'r':0,'g':0,'b':0}

class Server():
    def __init__(self):
        pass

    @route('/dotColor')
    def dotColor(self):
        dot = Image.open('../game-files/data/dot.png')
        size= dot.size
        print(size)
        pixAccess = dot.load()
        rgb = pixAccess[size[0]/2,size[1]/2][:3]
        return

    def run(self):
        time.sleep(1)
        run(host='localhost', port=8080)


if __name__ == '__main__':

    server = Server()
    x = threading.Thread(target=server.run, daemon=True)
    x.start()

    while True:
        pass
