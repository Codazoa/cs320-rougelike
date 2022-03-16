// Ronny - Valtonen
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4; // Use 0.8.4 to not break everything

// Import a few things, ERC721 contract and Ownable contract
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import "remix_tests.sol"; 

// Import the minting contract to run off of.
import "remix_accounts.sol";


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
    // Before all, black-box testing
    // Make payable to check for the msg and sender..
    function beforeAll() public {
        // Instantiate contract
        uint expected = 1;
        Assert.lesserThan(maxSupply, expected, "max supply bought must be less than the total supply");

        // Verify that minting was enabled, if not, no reason to proceed with future testing.
        // Required tests must be put in a beforeAll() function to test these 'before' going on.
        assert(isMintEnabled == true);

    }

    function checkSuccess() public{
        // Use 'Assert' methods
        Assert.ok(totalSupply == 1, "should be true"); // After minting, the supply should be 1 of 1.
    }


    // Custom Transaction Test
    // #sender: account-1
    // #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
}
