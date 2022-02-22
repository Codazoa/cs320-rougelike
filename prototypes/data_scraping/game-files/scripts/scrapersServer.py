import os, zmq, time, random, json
from datetime import datetime as dt
from PIL import Image
from bs4 import BeautifulSoup
import requests

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
        self.tempData = dict() # dict of weather data for each city {'city': int}
        self.api = config.api_key
        self.city_names = ['Yamoussoukro (official)', 'Abu Dhabi', 'Abuja', 'Accra', 'Adamstown',
                          'Addis Ababa', "Sana'a (de jure)", 'Algiers', 'Alofi', 'Amman',
                          'The Hague (de facto)', 'Andorra la Vella', 'Ankara', 'Antananarivo',
                          'Apia', 'Ashgabat', 'Asmara', 'Asunción', 'Athens', 'Avarua', 'Baghdad',
                          'Baku', 'Bamako', 'Bandar Seri Begawan', 'Bangui', 'Banjul', 'Basseterre',
                          'Beijing', 'Beirut', 'Belgrade', 'Belmopan', 'Berlin', 'Bern (de facto)',
                          'Bishkek', 'Bissau', 'Pretoria (executive)', 'Bogotá', 'Plymouth (official)',
                          'Brasília', 'Bratislava', 'Brazzaville', 'Bridgetown', 'Brussels',
                          'Bucharest', 'Budapest', 'Buenos Aires', 'Cairo', 'Canberra', 'Caracas',
                          'Castries', 'Podgorica (official)', 'Charlotte Amalie', 'Chișinău',
                          'Cockburn Town', 'Sri Jayawardenepura Kotte (official)', 'Conakry',
                          'Copenhagen', 'Porto-Novo (official)', 'Dakar', 'Damascus',
                          'Dodoma (official, legislative)', 'Dhaka', 'Dili', 'Djibouti', 'Doha',
                          'Douglas', 'Dublin', 'Dushanbe', 'Tifariti (de facto)', 'Flying Fish Cove',
                          'Freetown', 'Funafuti', 'Gaborone', 'George Town', 'Georgetown', 'Georgetown',
                          'Gibraltar', 'Bujumbura (de facto)', 'Guatemala City', 'Gustavia', 'Hagåtña',
                          'Hamilton', 'Hanoi', 'Harare', 'Hargeisa', 'Havana', 'Helsinki', 'Honiara',
                          'Islamabad', 'Jakarta', 'Jamestown', 'Jerusalem (disputed)', 'Ramallah (de facto)',
                          'Juba', 'Kabul', 'Kampala', 'Kathmandu', 'Khartoum', 'Kigali', 'King Edward Point',
                          'Kingston', 'Kingston', 'Kingstown', 'Kinshasa', 'Krung Thep Maha Nakhon',
                          'Putrajaya (administrative and judicial)', 'Kuwait City', 'Kyiv',
                          'Sucre (constitutional)', 'Libreville', 'Lilongwe', 'Lima', 'Lisbon', 'Ljubljana',
                          'Mbabane (administrative)', 'Lomé', 'London', 'Luanda', 'Lusaka', 'Luxembourg',
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
                          'Valparaíso (legislative)', 'Santo Domingo', 'São Tomé', 'Sarajevo', 'Seoul',
                          'Singapore', 'Skopje', 'Sofia', 'South Tarawa', "St. George's", 'St. Helier',
                          "St. John's", 'St. Peter Port', 'St. Pierre', 'Stanley', 'Stepanakert', 'Stockholm',
                          'Sukhumi', 'Suva', 'Taipei', 'Tallinn', 'Tashkent', 'Tbilisi', 'Tegucigalpa',
                          'Tehran', 'Thimphu', 'Tirana', 'Tiraspol', 'Tokyo', 'Tórshavn', 'Tripoli',
                          'Tskhinvali', 'Tunis', 'Ulaanbaatar', 'Vaduz', 'Valletta', 'The Valley',
                          'Vatican City', 'Victoria', 'Vienna', 'Vientiane', 'Vilnius', 'Warsaw',
                          'Washington, D.C.', 'Wellington', 'West Island', 'Willemstad', 'Windhoek', 'Yaoundé',
                          'Yaren (de facto)', 'Yerevan', 'Zagreb']
        self.generateTempData()
        pass

    def __createApiUrl(self, city):
        return f'https://api.openweathermap.org/data/2.5/weather?q={city}&units=metric&appid={self.api}'

    def generateTempData(self):
        self.tempData.clear()
        random.seed(time.time())
        for i in range(10): # only grab 30 to not get rate limited
            city = random.choice(self.city_names)
            apiUrl = self.__createApiUrl(city)

            rawData = request("GET", apiUrl)
            jsonData = json.loads(rawData.text)
            temp = jsonData.get('main').get('temp')

            self.tempData[city] = temp

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
