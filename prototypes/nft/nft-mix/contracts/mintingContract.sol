// Ronny - Valtonen
// SPDX-License-Identifier: <SPDX-License>: UNLICENSED

pragma solidity ^0.8.4; // Use 0.8.4 to not break everything

// Import a few things, ERC721 contract and Ownable contract
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

// Create the contract, inherits ERC721 and Ownable
contract playerMintContract is ERC721, Ownable {
    uint256 public mintPrice = 0.01 ether; // Define cost int of the ERC721 token
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

    function checkForMint() external onlyOwner { // Whoever deploys, is the only one that can run this function
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


