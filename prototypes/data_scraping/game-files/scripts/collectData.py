import sys

def main():
    getDot = scp.DotScraper()
    print(getDot.grabDotRGB())

    print(getDot.lastAccess)

    getDot.updateDot()

    print(getDot.lastAccess)
    pass

if __name__ == '__main__':
    main()
