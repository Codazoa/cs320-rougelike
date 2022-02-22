import os, zmq, time, random, json
from datetime import datetime as dt
from PIL import Image
from bs4 import BeautifulSoup

import config

class DotScraper():
    def __init__(self):
        self.dotURL = 'https://global-mind.org/gcpdot/' # url to the global dot
        self.dotPNGPath = '../data/dot.png'
        self.lastAccess = () # time we last downloaded the dot, no more than once every 5 min

    def __accessTime(self, dateTime): # update the lastAccess time with new dateTime object h:m
        hr = dateTime.hour
        min = dateTime.minute
        self.lastAccess = (hr, min)
        return((hr, min))

    def updateDot(self): # download the new image of the dot, store in ../data/ as dot.png
        # page = BeautifulSoup
        self.__accessTime(dt.now())
        pass

    def grabDotRGB(self): # return the rgb value of the center of the dot.png file in ../data/
        dot = Image.open(self.dotPNGPath) # open the image
        size = dot.size # find image size
        pixAccess = dot.load() # load the pixel Access object
        return pixAccess[size[0]/2,size[1]/2][:3] # return tuple with (R, G, B) values


class CityTempScraper():
    def __init__(self):
        self.tempData = dict() # dict of weather data for each lat,long {(lat,lon): int}
        self.api = config.api_key
        self.generateTempData()
        pass

    def __createApiUrl(self, lat, lon):
        return f'api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&units=metric&appid={self.api}'

    def generateTempData(self):
        self.tempData.clear()
        random.seed(time.time())
        for i in range(5): # only grab 60
            lon = random.choice(range(360))-180
            lat = random.choice(range(180))-90
            temp = random.choice(range(30))
            self.tempData[(lat,lon)] = temp

    def pullCityNames(self): # return a dict with set number of keys
        pass

    def grabTemps(self):
        pass


class JsonEdit():
    def __init__(self):
        pass

def main():
    dotInfo = DotScraper()
    tempInfo = CityTempScraper()

    while True:
        pass
    pass

if __name__ == '__main__':
    main()
