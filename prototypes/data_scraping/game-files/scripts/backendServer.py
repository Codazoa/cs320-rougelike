from bottle import route, run, template
from time import sleep
import threading
from scraperClass import DotScraper, CityWeatherScraper

def runApiServer():
    run(host='localhost', port=8080)

def main():
    update = 5 # time in minutes to wait for updating values
    dot = DotScraper(update)
    weather = CityWeatherScraper(update)

    server = threading.Thread(target=runApiServer, daemon=True)

    sleep(update*60)

    while True:
        dot.updateDot()
        weather.updateCityWeather()
        sleep(update*60)

if __name__ == '__main__':
    main()
