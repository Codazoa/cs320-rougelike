from selenium import webdriver
import mouse
import pyautogui
import time

#pip3 install selenium
#pip3 install mouse

def main():
    # Open the remix IDE
    driver = webdriver.Firefox(executable_path = r'C:\Users\ronny\Desktop\Automation\Automation\geckodriver.exe')
    driver.get('https://remix.ethereum.org')

    time.sleep(1.25)
    while (True):
        # Make a new tab to put code into
        pyautogui.hotkey('ctrl', 't')
        time.sleep(0.5)
        pyautogui.write('https://www.editpad.org/')
        time.sleep(0.5)
        pyautogui.press('enter')
        mouse.move(394,329, absolute = True, duration = 0.25)
        time.sleep(0.20)
        mouse.click(button = 'left')
        time.sleep(0.20)
        # Type in my code
        pyautogui.write('''
// Ronny - Valtonen
// SPDX-License-Identifier: <SPDX-License>: UNLICENSED

pragma solidity ^0.8.4; // Use 0.8.4 to not break everything

// Import a few things, ERC721 contract and Ownable contract
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

// Create the contract, inherits ERC721 and Ownable
contract playerMintContract is ERC721, Ownable {
    uint256 public mintPrice = 1 ether; // Define cost int of the ERC721 token
    uint256 public totalSupply; // Define the current number of supply
    uint256 public maxSupply; // Define the maximum supply
    bool public isMintEnabled; // Determines if people can mint the token, default to False
    mapping(address => uint256) public mintedWallets; // Create a dictionary to keep track of the number of mints
    bool public isPlayerNameEmpty;
    string public playerName = "test_ID"; // This holds the player key, to pull information from later

    // Runs as soon as this gets deployed
    constructor() payable ERC721('Player Zero', 'PLAY0') {
        maxSupply = 1; // Each player is distinct
        // Number of variable changes matters WAY more than loops (time wise), unlike other languages.
    }

    // Struct to store the player data
    struct Player {
        // State variables
        int empid;
        string name;
        string playDate;
        string connectedParts;
        string numberOfDeaths;
    }

    Player []emps;

    // Function to add player details
    function addPlayer(
        int empid, string memory name,
        string memory playDate,
        string memory connectedParts,
        string memory numberOfDeaths
    ) public {
        Player memory e
            = Player(empid, 
            name, 
            playDate, 
            connectedParts, 
            numberOfDeaths);
        emps.push(e);
    }

    // Function to get player details
    function getPlayer(int empid) public view returns(
        string memory,
        string memory,
        string memory,
        string memory) 
        {
            uint i;
            for (i=0; i<emps.length; i++) {
                Player memory e
                    = emps[i];

                    // Look for a matching player ID
                    if (e.empid==empid) {
                        return (e.name,
                            e.playDate,
                            e.connectedParts,
                            e.numberOfDeaths);
                    }
            }
            // If the player ID doesn't exist, state so.
            return('Not Found', 
                'Not Found', 
                'Not Found',
                'Not Found');
        }

    function enableMinting() external onlyOwner { // Whoever deploys, is the only one that can run this function
        isMintEnabled = !isMintEnabled; // When ran, change to True.
    }

    function newSupply(uint256 maxSupply_) external onlyOwner {
        maxSupply = maxSupply_;
    }

    // Runs when minted
    function mint() external payable {
        require(isMintEnabled, 'You cannot mint token'); // "If isMintEnabled is False, print error message"
        require(mintedWallets[msg.sender] < 1, 'Exceeds the max supply'); // Each wallet can only mint one token
        require(msg.value == mintPrice, 'Wrong price'); // Check value of transaction, (0.01)
        require(maxSupply > totalSupply, 'No more tokens in supply'); // Tracks supply to prevent too many NFT's
        
        // Check if the name is empty
        bytes memory tempString = bytes(playerName);
                if (tempString.length == 0) {
            // String is empty
            isPlayerNameEmpty = isPlayerNameEmpty;
        } else {
            // String is not empty
            isPlayerNameEmpty = !isPlayerNameEmpty;
        }

        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId); // Distributes NFT correctly
    }
}        
        ''')
        time.sleep(3)
        # Copy the code
        pyautogui.hotkey('ctrl', 'a')
        pyautogui.hotkey('ctrl', 'c')

        # Get into remix IDE
        mouse.move(178, 27, absolute = True, duration = 0.20)
        mouse.click(button = 'left')
        mouse.move(791, 504, absolute = True, duration = 0.5)
        time.sleep(0.5)
        mouse.click(button = 'left')
        mouse.move(329,125, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(142,242, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.right_click()
        mouse.move(164,257, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        time.sleep(0.25)
        pyautogui.write('characterNFT.sol')
        pyautogui.press('enter')
        mouse.move(535, 142, absolute = True, duration = 0.25)
        mouse.right_click()
        mouse.move(535, 145, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        # Paste the code
        pyautogui.hotkey('ctrl', 'v')
        time.sleep(0.20)
        pyautogui.hotkey('ctrl', 's')
        mouse.move(35, 262, absolute = True, duration = 0.25)
        time.sleep(3)
        mouse.click(button = 'left')
        mouse.move(175, 477, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(196, 791, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(137, 525, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(86, 766, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(134, 931, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(153, 406, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write('1000000000000000000')
        # Mint the NFT
        mouse.move(125, 982, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        mouse.move(328, 826, absolute = True, duration = 0.25)
        mouse.click(button = 'left')

        # Read metadata of character
        file = open('metadata.txt')
        content = file.readlines()

        # Enter empID
        mouse.move(294, 855, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write(content[0])

        # Enter name
        mouse.move(294, 891, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write(content[1])

        # Enter playDate
        mouse.move(294, 930, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write(content[2])

        # Enter connectedParts
        mouse.move(294, 960, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write(content[3])

        # Enter numberOfDeaths
        mouse.move(294, 990, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write(content[4])

        # Transact into the blockchain
        mouse.move(294, 1029, absolute = True, duration = 0.25)
        mouse.click(button = 'left')

        # Scroll down a bit
        mouse.move(374, 1029, absolute = True, duration = 0.25)
        mouse.click(button = 'left')

        # Get player information using the function
        mouse.move(200, 901, absolute = True, duration = 0.25)
        mouse.click(button = 'left')
        pyautogui.write(content[0])
        mouse.move(116, 901, absolute = True, duration = 0.25)
        mouse.click(button = 'left')

        # Scroll down
        mouse.move(365, 964, absolute = True, duration = 0.25)
        mouse.click(button = 'left')




        time.sleep(3)
        print(mouse.get_position())
        return False




if __name__ == '__main__':
    main()

print("Done")