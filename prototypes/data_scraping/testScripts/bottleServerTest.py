from bottle import route, run, template
from PIL import Image

@route('/dotColor')
def dotColor():
    dot = Image.open('../game-files/data/dot.png')
    size= dot.size
    print(size)
    pixAccess = dot.load()
    rgb = pixAccess[size[0]/2,size[1]/2][:3]
    return {'r':rgb[0],'g':rgb[1],'b':rgb[2]}

run(host='localhost', port=8080)
