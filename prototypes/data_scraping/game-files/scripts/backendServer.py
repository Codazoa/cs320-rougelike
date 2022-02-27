from bottle import route, run, template
from time import sleep
import threading, sys
from scraperClass import DotScraper, CityWeatherScraper

update = 5
online = True

print('Creating Dot Scraper')
dot = DotScraper(update)
print('Creating Weather Scraper')
weather = CityWeatherScraper(update)

@route('/api/dotrgb')
def dotrgb(): # api to return the current dot color, variable update rates
    rgb = dot.curDotRGB
    return {'r': rgb[0], 'g': rgb[1], 'b': rgb[2]}

@route('/api/mainweather')
def mainWeather(): # api to return the full weather data for a random city
    return weather.getRandMainWeather()

@route('/api/mainweather/temp')
def mainTemp(): # api to return just the tempurature of a random city
    main = weather.getRandMainWeather()
    city = list(main.keys())[0]
    return({city: main[city].get('temp')})

@route('/api/mainweather/pres')
def mainPres(): # api to return just the pressure of a random city
    main = weather.getRandMainWeather()
    city = list(main.keys())[0]
    return({city: main[city].get('pressure')})

@route('/api/mainweather/humidity')
def mainHumid(): # api to return just the humidity of a random city
    main = weather.getRandMainWeather()
    city = list(main.keys())[0]
    return({city: main[city].get('humidity')})

@route('/api/windweather')
def windWeather(): # api to return the wind information of a random city
    return weather.getRandWindWeather()

@route('/api/windweather/speed')
def windweather(): # api to return the wind speed of a random city
    wind = weather.getRandWindWeather()
    city = list(wind.keys())[0]
    return({city: wind[city].get('speed')})

@route('/api/windweather/dir')
def windDir(): # api to return the wind direction of a random city
    wind = weather.getRandWindWeather()
    city = list(main.keys())[0]
    return({city: wind[city].get('deg')})

def runApiServer(): # allow the daemon thread to run the server
    run(host='localhost', port=8080)

def main(argv = sys.argv): # backendServer.py [--offline]
    for arg in argv:
        if arg == '--offline': online = False # update for running offline

    server = threading.Thread(target=runApiServer, daemon=True)
    server.start() # start the daemon server

    sleep(update*60) # sleep for <update> minutes

    while True:
        print('Updating Values')
        dot.updateDot() # update the dot every <update> minutes
        weather.updateCityWeather() # update the weather data every <update> minutes
        sleep(update*60)

if __name__ == '__main__':
    main()
