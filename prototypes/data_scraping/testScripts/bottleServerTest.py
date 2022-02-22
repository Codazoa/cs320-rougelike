from bottle import route, run, template
import time
import threading
from PIL import Image

dot = {'r':0,'g':0,'b':0}

@route('/dotColor')
def dotColor():
    dot = Image.open('../game-files/data/dot.png')
    size= dot.size
    print(size)
    pixAccess = dot.load()
    rgb = pixAccess[size[0]/2,size[1]/2][:3]
    return {'r':0,'g':0,'b':0}

def hostServer():
    time.sleep(1)
    run(host='localhost', port=8080)

if __name__ == '__main__':
    x = threading.Thread(target=hostServer, daemon=True)
    x.start()

    for i in range(10):
        time.sleep(1)
        print("Loop")
