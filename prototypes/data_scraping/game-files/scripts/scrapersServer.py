import os, zmq, time
from datetime import datetime as dt
from PIL import Image
from bs4 import BeautifulSoup

class DotScraper():
    def __init__(self):
        self.dotURL = 'https://global-mind.org/gcpdot/' # url to the global dot
        self.dotPNGPath = '../data/dot.png'
        self.lastAccess = () # time we last downloaded the dot, no more than once every 5 min

    def __accessTime(self, dateTime): # update the lastAccess time with new dateTime object h:m
        hr = dateTime.hour
        min = dateTime.minute
        self.lastAccess = (hr, min)

    def updateDot(self): # download the new image of the dot, store in ../data/ as dot.png
        page = BeautifulSoup
        self.__accessTime(dt.now())
        pass

    def grabDotRGB(self): # return the rgb value of the center of the dot.png file in ../data/
        dot = Image.open(self.dotPNGPath) # open the image
        size = dot.size # find image size
        pixAccess = dot.load() # load the pixel Access object
        return pixAccess[size[0]/2,size[1]/2][:3] # return tuple with (R, G, B) values


class CityTempScraper():
    def __init__(self):
        self.tempURLs = '' # dict of city names and urls
        pass

    def pullCityNames(self): # return a dict with set number of keys
        pass

    def createCityURL(self, cityName):
        pass

    def grabTemps(self):
        pass


# class JsonEdit():
#     def __init__(self):
#         pass

def main():
    dotInfo = DotScraper()
    tempInfo = CityTempScraper()



    pass

if __name__ == '__main__':
    main()
