import os, time, random, json
from datetime import datetime as dt
from PIL import Image
from bs4 import BeautifulSoup
from selenium import webdriver
from requests import request
import config # importing config.py for api key


class DotScraper():
    def __init__(self, update):
        self.updateFreq = update # how often in minutes we should update data
        self.dotURL = 'https://global-mind.org/gcpdot/gcp.html' # url to the global dot
        self.dotPNGPath = '../data/dot.png' # path to where we store the dot
        self.lastUpdate = 0 # time we last downloaded the dot, no more than once every <updateInterval> minutes
        self.curDotRGB = () # save the tuple of the current dot rgb values so that we don't have to download again
        self.updateDot()

    def checkUpdateInterval(self): # returns true if beyond update frequency, false if within frequency
        return ((time.time() - self.lastUpdate) > (60*self.updateFreq))

    def updateDot(self): # download the new image of the dot, store as ../data/dot.png
        if self.checkUpdateInterval():
            fireFoxOptions = webdriver.FirefoxOptions() # set up driver options
            fireFoxOptions.headless = True # set the driver to use a headless client
            driver = webdriver.Firefox(options=fireFoxOptions)
            driver.get(self.dotURL) # go to the url that contains the dot
            time.sleep(1) # give the dot time to load

            driver.get_full_page_screenshot_as_file(self.dotPNGPath) # save the dot as a png

            driver.close() # close the webdriver
            self.lastAccess = time.time() # update the access time
            self.updateCurDotRGB() # update the dot so we could return it

    def updateCurDotRGB(self): # return the rgb value of the center of the dot.png file in ../data/
        dot = Image.open(self.dotPNGPath) # open the image
        size = dot.size # find image size
        pixAccess = dot.load() # load the pixel Access object
        self.curDotRGB = pixAccess[size[0]/2,size[1]/2][:3] # set the curDotRGB


class CityWeatherScraper():
    def __init__(self, update):
        self.updateFreq = update # set the update frequency in minutes (api can only be called 60 times in 60 minutes)
        self.cityWeather = dict() # dict of weather data for each city {'city': {'main': {}}, {'wind': {}}}
        self.api = config.api_key # storing api key semi securly
        self.lastUpdate = 0 # for tracking time of updates to dicts
        self.tempCityList = [] # list to hold names of current cities we have data for (changes every 10 min)
        self.cityNames = ['Yamoussoukro', 'Abu Dhabi', 'Abuja', 'Accra', 'Adamstown',
                          'Addis Ababa', "Sana'a", 'Algiers', 'Alofi', 'Amman',
                          'The Hague', 'Andorra la Vella', 'Ankara', 'Antananarivo',
                          'Apia', 'Ashgabat', 'Asmara', 'Asunción', 'Athens', 'Avarua', 'Baghdad',
                          'Baku', 'Bamako', 'Bandar Seri Begawan', 'Bangui', 'Banjul', 'Basseterre',
                          'Beijing', 'Beirut', 'Belgrade', 'Belmopan', 'Berlin', 'Bern',
                          'Bishkek', 'Bissau', 'Pretoria', 'Bogotá', 'Plymouth',
                          'Brasília', 'Bratislava', 'Brazzaville', 'Bridgetown', 'Brussels',
                          'Bucharest', 'Budapest', 'Buenos Aires', 'Cairo', 'Canberra', 'Caracas',
                          'Castries', 'Podgorica', 'Charlotte Amalie', 'Chișinău',
                          'Cockburn Town', 'Sri Jayawardenepura Kotte', 'Conakry',
                          'Copenhagen', 'Porto-Novo', 'Dakar', 'Damascus',
                          'Dodoma', 'Dhaka', 'Dili', 'Djibouti', 'Doha',
                          'Douglas', 'Dublin', 'Dushanbe', 'Tifariti', 'Flying Fish Cove',
                          'Freetown', 'Funafuti', 'Gaborone', 'George Town', 'Georgetown', 'Georgetown',
                          'Gibraltar', 'Bujumbura', 'Guatemala City', 'Gustavia', 'Hagåtña',
                          'Hamilton', 'Hanoi', 'Harare', 'Hargeisa', 'Havana', 'Helsinki', 'Honiara',
                          'Islamabad', 'Jakarta', 'Jamestown', 'Jerusalem', 'Ramallah',
                          'Juba', 'Kabul', 'Kampala', 'Kathmandu', 'Khartoum', 'Kigali', 'King Edward Point',
                          'Kingston', 'Kingston', 'Kingstown', 'Kinshasa', 'Krung Thep Maha Nakhon',
                          'Putrajaya', 'Kuwait City', 'Kyiv',
                          'Sucre', 'Libreville', 'Lilongwe', 'Lima', 'Lisbon', 'Ljubljana',
                          'Mbabane', 'Lomé', 'London', 'Luanda', 'Lusaka', 'Luxembourg',
                          'Madrid', 'Majuro', 'Malabo', 'Malé', 'Managua', 'Manama', 'Manila', 'Maputo',
                          'Mariehamn', 'Marigot', 'Maseru', 'Mata Utu', 'Mexico City', 'Minsk', 'Mogadishu',
                          'Monaco', 'Monrovia', 'Montevideo', 'Moroni', 'Moscow', 'Muscat', 'Nairobi',
                          'Nassau', 'Naypyidaw', "N'Djamena", 'New Delhi', 'Ngerulmud', 'Niamey', 'Nicosia',
                          'Nouakchott', 'Nouméa', 'Nukuʻalofa', 'Nur-Sultan', 'Nuuk', 'Oranjestad', 'Oslo',
                          'Ottawa', 'Ouagadougou', 'Pago Pago', 'Palikir', 'Panama City', 'Papeete',
                          'Paramaribo', 'Paris', 'Philipsburg', 'Phnom Penh', 'Port Louis', 'Port Moresby',
                          'Port of Spain', 'Port Vila', 'Port-au-Prince', 'Prague', 'Praia', 'Pristina',
                          'Pyongyang', 'Quito', 'Rabat', 'Reykjavík', 'Riga', 'Riyadh', 'Road Town', 'Rome',
                          'Roseau', 'Saipan', 'San José', 'San Juan', 'San Marino', 'San Salvador',
                          'Valparaíso', 'Santo Domingo', 'São Tomé', 'Sarajevo', 'Seoul',
                          'Singapore', 'Skopje', 'Sofia', 'South Tarawa', "St. George's", 'St. Helier',
                          "St. John's", 'St. Peter Port', 'St. Pierre', 'Stanley', 'Stepanakert', 'Stockholm',
                          'Sukhumi', 'Suva', 'Taipei', 'Tallinn', 'Tashkent', 'Tbilisi', 'Tegucigalpa',
                          'Tehran', 'Thimphu', 'Tirana', 'Tiraspol', 'Tokyo', 'Tórshavn', 'Tripoli',
                          'Tskhinvali', 'Tunis', 'Ulaanbaatar', 'Vaduz', 'Valletta', 'The Valley',
                          'Vatican City', 'Victoria', 'Vienna', 'Vientiane', 'Vilnius', 'Warsaw',
                          'Washington, D.C.', 'Wellington', 'West Island', 'Willemstad', 'Windhoek', 'Yaoundé',
                          'Yaren', 'Yerevan', 'Zagreb']
        self.updateCityWeather()

    def checkUpdateInterval(self): # returns true if beyond update frequency, false if within frequency
        return ((time.time() - self.lastUpdate) > (60*self.updateFreq))

    def updateCityWeather(self): # update the city weather with <updateFreq> new entries (this should only happen every <updateFreq> min)
        self.cityWeather.clear() # clear the weather information
        self.tempCityList.clear() # clear the city list information
        if(self.checkUpdateInterval()): # only update if we are past the update frequency
            for _ in range(self.updateFreq):
                city = self.__getRandCity(self.cityNames) # pick a random city name
                self.cityWeather[city] = self.retrieveWeatherData(city) # add that city and its weather to the dict
                self.tempCityList.append(city)
                self.lastUpdate = time.time() # update access time

    def __getRandCity(self, cityList): # return a random city from the cityList
        random.seed(time.time()) # reset random seed
        return random.choice(cityList) # return a random city name

    def __createApiUrl(self, city): # returns the usable api url
        return f'https://api.openweathermap.org/data/2.5/weather?q={city}&units=metric&appid={self.api}'

    def retrieveWeatherData(self, city): # retrieves weather data for a particular city
        assert city in self.cityNames # be sure that city exists in the list
        rawData = request("GET", self.__createApiUrl(city)) # get the raw json from the api
        jsonData = json.loads(rawData.text) # so we can parse the json returned

        dataDict = dict() # dict to hold the main and wind weather information

        # set main and wind in dict
        dataDict['main'] = jsonData.get('main')
        dataDict['wind'] = jsonData.get('wind')

        return dataDict

    def getRandMainWeather(self): # get the main weather data of a random city
        city = self.__getRandCity(self.tempCityList)
        return {city: self.cityWeather.get(city).get('main')}

    def getRandWindWeather(self): # get the wind (m/s) of a random city
        city = self.__getRandCity(self.tempCityList)
        return {city: self.cityWeather.get(city).get('wind')}
