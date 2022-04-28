from lib2to3.pgen2 import token
from time import sleep
import pyautogui
import time

# pip install pyautogui

def main():

    token_id = '001'
    print("Automation starting")
    # Move to the search bar
    pyautogui.moveTo(1238, 13)
    pyautogui.click()

    # Type in REMIX
    pyautogui.write('Remix IDE')

    # Click the application
    pyautogui.moveTo(445, 258)
    time.sleep(1) # Make sure you click the right app
    pyautogui.click()
    # Wait for Remix to open
    time.sleep(15)

    # Go full scren
    pyautogui.moveTo(375, 167)
    time.sleep(3)
    pyautogui.click()

    # Open smart contract
    pyautogui.moveTo(111, 614)
    time.sleep(2)
    pyautogui.click()
    pyautogui.moveTo(111, 669)
    time.sleep(0.5)
    pyautogui.click()
    pyautogui.moveTo(111, 803)
    time.sleep(0.5)
    pyautogui.click()
    pyautogui.moveTo(117, 842)
    time.sleep(0.5)
    pyautogui.click()
    pyautogui.moveTo(122, 862)
    time.sleep(0.5)
    pyautogui.click()
    # Scroll down
    pyautogui.moveTo(364, 856)
    time.sleep(0.1)
    pyautogui.click()

    # Smart contract
    pyautogui.moveTo(164, 337)
    time.sleep(0.1)
    pyautogui.click()

    # Save smart contract
    with pyautogui.hold('command'):
        pyautogui.press(['s'])

    # Deploy smart contract
    pyautogui.moveTo(22, 211)
    time.sleep(5)
    pyautogui.click()

    # Start Ganache blockchain
    pyautogui.moveTo(1228, 0)
    time.sleep(0.2)
    pyautogui.click()
    # pyautogui.moveTo(0, 35)
    # time.sleep(1)
    # pyautogui.moveTo(16, 35)
    # time.sleep(0.1)
    # pyautogui.click()
    pyautogui.write('Ganache')
    pyautogui.press(['enter'])

    # Start ganache
    pyautogui.moveTo(549, 659)
    time.sleep(10)
    pyautogui.click()

    # Connect ganache to remix IDE
    time.sleep(5)
    pyautogui.moveTo(1190, 859)
    pyautogui.click()

    time.sleep(0.5)
    pyautogui.moveTo(182, 102)
    time.sleep(0.1)
    pyautogui.click()

    pyautogui.moveTo(174, 219)
    time.sleep(0.1)
    pyautogui.click()

    pyautogui.moveTo(711, 234)
    time.sleep(2)
    
    pyautogui.click()
    pyautogui.press(['backspace'])
    pyautogui.press(['backspace'])
    pyautogui.press(['backspace'])
    pyautogui.press(['backspace'])

    time.sleep(0.2)
    pyautogui.write('7545')

    pyautogui.moveTo(871, 295)
    time.sleep(0.1)
    pyautogui.click()

    # Set smart contract deployment
    pyautogui.moveTo(188, 387)
    time.sleep(0.5)
    pyautogui.click()
    pyautogui.moveTo(188, 685)
    time.sleep(0.2)
    pyautogui.click()

    pyautogui.moveTo(282, 315)
    time.sleep(0.5)
    pyautogui.click()
    pyautogui.moveTo(276, 386)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.moveTo(168, 316)
    pyautogui.click()
    pyautogui.write('1')
    pyautogui.moveTo(122, 433)
    pyautogui.click()

    # Mint contract
    pyautogui.moveTo(80, 659)
    time.sleep(2)
    pyautogui.click()

    # Add player
    pyautogui.moveTo(330, 721)
    time.sleep(2)
    pyautogui.click()

    # Open the player data file
    data = []

    with open('/Users/ronnyvaltonen/Desktop/player.txt') as meta_data:
        data = meta_data.readlines()

    print(data)

    pyautogui.moveTo(305, 753)
    time.sleep(0.1)
    pyautogui.click()

    empid = data[0].strip()
    name = data[1].strip()
    play_date = data[2].strip()
    connected_parts = data[3].strip()
    number_of_deaths = data[4]

    # Enter the data
    pyautogui.write(empid)
    pyautogui.moveTo(286, 787)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.write(name)
    pyautogui.moveTo(292, 825)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.write(play_date)
    pyautogui.moveTo(229, 858)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.write(connected_parts)
    pyautogui.moveTo(269, 892)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.write(number_of_deaths)


    # Transact the data
    pyautogui.moveTo(365, 354)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.moveTo(277, 127)
    pyautogui.click()

    # Enable minting
    pyautogui.moveTo(124, 358)
    pyautogui.click()

    # Mint
    time.sleep(0.3)
    pyautogui.moveTo(331, 405)
    pyautogui.click()
    time.sleep(0.1)
    pyautogui.moveTo(272, 438)
    pyautogui.click()
    pyautogui.write(token_id)
    pyautogui.moveTo(287, 473)
    pyautogui.click()
    pyautogui.write(empid)
    pyautogui.moveTo(282, 508)
    pyautogui.click()
    pyautogui.write(name)
    pyautogui.moveTo(267, 543)
    pyautogui.click()
    pyautogui.write(play_date)
    pyautogui.moveTo(275, 582)
    pyautogui.click()
    pyautogui.write(connected_parts)
    pyautogui.moveTo(264, 615)
    pyautogui.click()
    pyautogui.write(number_of_deaths)

    # Transact
    pyautogui.moveTo(275, 650)
    time.sleep(0.1)
    pyautogui.click()

    pyautogui.moveTo(364, 646)
    time.sleep(1)
    pyautogui.click()
    time.sleep(5)

    pyautogui.click()
    pyautogui.moveTo(236, 833)
    time.sleep(0.1)
    pyautogui.click()
    pyautogui.write(token_id)

    pyautogui.moveTo(126, 826)
    time.sleep(0.1)
    pyautogui.click()


    time.sleep(10)

    
    x, y = pyautogui.position()
    print(x, y)

if __name__ == "__main__":
    main()