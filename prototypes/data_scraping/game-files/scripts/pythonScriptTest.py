import unittest
from time import time, sleep
import scraperClass
import requests
import json

class TestScraperMethods(unittest.TestCase):

    # branch coverage
    # def updateCityWeather(self): # update the city weather with <updateFreq> new entries (this should only happen every <updateFreq> min)
    #     self.cityWeather.clear() # clear the weather information
    #     self.tempCityList.clear() # clear the city list information
    #     if(self.checkUpdateInterval()): # only update if we are past the update frequency
    #         for _ in range(self.updateFreq):
    #             city = self.__getRandCity(self.cityNames) # pick a random city name
    #             self.cityWeather[city] = self.retrieveWeatherData(city) # add that city and its weather to the dict
    #             self.tempCityList.append(city)
    #             self.lastUpdate = time.time() # update access time

    def testCityWeather(self): # check that the weather scraper initializes correctly
        weather = scraperClass.CityWeatherScraper(1)
        city = list(weather.cityWeather.keys())[0]
        oldWeather = weather.cityWeather.get(city)['main']
        self.assertTrue(city in weather.cityNames)
        self.assertTrue(oldWeather)
        weather.updateCityWeather()
        self.assertTrue(weather.cityWeather.get(city)['main'] == oldWeather)

    # integration test
    # testing server api access and dot rgb color scraping
    # big bang
    def testServerDotApi(self):
        rgb = requests.get("localhost:8080/api/dotrgb").text
        self.assertTrue(type(rgb) == type(dict()))
        rgbJson = json.loads(rgb)
        self.assertTrue(rgbJson['r'] in range(0,255) and rgbJson['g'] in range(0,255) and rgbJson['b'] in range(0,255))

    # acceptance test
    def testDotCheckUpdateTime(self):
        dot = scraperClass.DotScraper(1)
        dot.lastUpdate = time()
        sleep(1)
        self.assertFalse(dot.checkUpdateInterval())

    # branch coverage with testDotAccessTimeAfterUpdate
    # def checkUpdateInterval(self): # returns true if beyond update frequency, false if within frequency
    #     return ((time.time() - self.lastUpdate) > (60*self.updateFreq))
    def testDotAccessTimeBeforeUpdate(self):
        dot = scraperClass.DotScraper(1)
        dot.lastUpdate = time()
        sleep(2)
        self.assertFalse(dot.checkUpdateInterval())

    # branch coverage with above
    def testDotAccessTimeAfterUpdate(self):
        dot = scraperClass.DotScraper(0.1)
        dot.lastUpdate = time()
        sleep(10)
        self.assertTrue(dot.checkUpdateInterval())

    # acceptance test
    def testDotUpdate(self):
        dot = scraperClass.DotScraper(1)
        oldRgb = dot.curDotRGB
        sleep(5)
        dot.updateDot()
        newRgb = dot.curDotRGB
        self.assertTrue(oldRgb[0] != newRgb[0] or oldRgb[1] != newRgb[1] or oldRgb[2] != newRgb[2])

if __name__ == '__main__':
    unittest.main()
