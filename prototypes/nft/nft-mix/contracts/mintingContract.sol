// Ronny - Valtonen
// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4; // Use 0.8.4 to not break everything

// Import a few things, ERC721 contract and Ownable contract
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "remix_tests.sol"; 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// Import the minting contract to run off of.
import "remix_accounts.sol";


// This is the Base64 library, not written by me, has MIT license.

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides functions for encoding/decoding base64
library Base64 {
    string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
                                            hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
                                            hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
                                            hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';

        // load the table into memory
        string memory table = TABLE_ENCODE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
                // read 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // write 4 characters
                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }

        return result;
    }

    function decode(string memory _data) internal pure returns (bytes memory) {
        bytes memory data = bytes(_data);

        if (data.length == 0) return new bytes(0);
        require(data.length % 4 == 0, "invalid base64 decoder input");

        // load the table into memory
        bytes memory table = TABLE_DECODE;

        // every 4 characters represent 3 bytes
        uint256 decodedLen = (data.length / 4) * 3;

        // add some extra buffer at the end required for the writing
        bytes memory result = new bytes(decodedLen + 32);

        assembly {
            // padding with '='
            let lastBytes := mload(add(data, mload(data)))
            if eq(and(lastBytes, 0xFF), 0x3d) {
                decodedLen := sub(decodedLen, 1)
                if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
                    decodedLen := sub(decodedLen, 1)
                }
            }

            // set the actual output length
            mstore(result, decodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 4 characters at a time
            for {} lt(dataPtr, endPtr) {}
            {
               // read 4 characters
               dataPtr := add(dataPtr, 4)
               let input := mload(dataPtr)

               // write 3 bytes
               let output := add(
                   add(
                       shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
                       shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
                   add(
                       shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
                               and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
                    )
                )
                mstore(resultPtr, shl(232, output))
                resultPtr := add(resultPtr, 3)
            }
        }

        return result;
    }
}




// Create the contract, inherits ERC721 and Ownable
contract playerMintContract is ERC721, Ownable {

    uint256 public mintPrice = 1 ether; // Define cost int of the ERC721 token
    uint256 public totalSupply; // Define the current number of supply
    uint256 public maxSupply; // Define the maximum supply
    bool public isMintEnabled; // Determines if people can mint the token, default to False
    mapping(uint256 => string) private _tokenURIs; // Map the token URIs so we can grab the metadata
    mapping(address => uint256) public mintedWallets; // Create a dictionary to keep track of the number of mints
    bool public isPlayerNameEmpty;
    string public playerName = "_"; // This holds the player key, to pull information from later

    // Make sure everything is correct before moving the token
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721) {
            super._beforeTokenTransfer(from, to, tokenId);
        }

    // Set the tokens URI for metadata storage
    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual {
            require(_exists(tokenId), "Non existant"); // Unit test
            _tokenURIs[tokenId] = _tokenURI;
        }

    // Burn existing tokens on the network
    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }
        
    // Runs as soon as this gets deployed
    constructor() payable ERC721("Player Zero", "PLAY0") {
        maxSupply = 1; // Each player is distinct
        // Number of variable changes matters WAY more than loops (time wise), unlike other languages.
    }

    // @Author Artur Chmaro
    // @Title How to store NFT metadata and SVG image completely on-chain
    function uint2str(uint _i) internal pure returns (string memory _uinstAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // @Author Ronny Valtonen
    // @Game character contract project
    // Struct to store the player data
    mapping(uint256 => Player) public attributes;
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
    // Get the token URI
    function tokenURI(uint256 tokenId) public view
        override(ERC721) returns (string memory) {
            string memory json = Base64.encode(
                bytes(string(
                    abi.encodePacked(
                    '{"name": "', attributes[tokenId].name, '",',
                    '"image_data": "', getSvg(tokenId), '",',
                    '"attributes": [{"trait_type": "Name", "value": "', attributes[tokenId].name, '"},',
                    '{"trait_type": "Play Date", "value": "', attributes[tokenId].playDate, '"},',
                    '{"trait_type": "# Connected Parts", "value": "', attributes[tokenId].connectedParts, '"},',
                    '{"trait_type": "# Of Deaths", "value": "', attributes[tokenId].numberOfDeaths, '"}',
                    ']}'
                    )
                ))
            );
            return string(abi.encodePacked('data:application/json;base64,', json));
        }

    // Runs when minted
    function mint(
        uint256 tokenId,
        int _empid,
        string memory _name,
        string memory _playDate,
        string memory _connectedParts,
        string memory _numberOfDeaths) public payable {
        // Unit tests for user, exception is thrown
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
        // uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId); // Distributes NFT correctly

        attributes[tokenId] = Player(_empid, _name, _playDate, _connectedParts, _numberOfDeaths);
    }

    function getSvg(uint tokenId) private view
        returns (string memory) {
            string memory svg;
            svg = "<svg width='24px' height='24px' viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'> <path fill='none' stroke='#000' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2,8 L2,22 L22,22 L22,9 M11,4 L7,8 M2,4 L2,8 L17,8 L21,4 L2,4 Z M16,4 L12,8'/> </svg>";
            return svg;
        }




    //Unit testing

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

    // When a new contract is minted, test that when we branch to a new contract the supply also increases.
    function testMintBranching() public {
        Assert.equal(totalSupply, totalSupply++, "Supply should increase when minted");
    }

    // Test the success of the mint
    function checkSuccess() public{
        // Use 'Assert' methods
        Assert.ok(totalSupply == 1, "should be true"); // After minting, the supply should be 1 of 1.
        Assert.ok(isPlayerNameEmpty == !isPlayerNameEmpty, "should be true");
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
