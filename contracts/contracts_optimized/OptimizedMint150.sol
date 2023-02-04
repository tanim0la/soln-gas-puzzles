//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721('NotRareToken', 'NRT') {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

contract OptimizedAttacker {
    constructor(address victim) {
        NotRareToken vic = NotRareToken(victim);
        unchecked {
            uint256 start = vic.balanceOf(vic.ownerOf(1)) + 1;
            uint256 len = 150 + start;
            assembly {
                // stores function selector "mint()" in memory postion 0x00
                mstore(
                    0x00,
                    0x1249c58b00000000000000000000000000000000000000000000000000000000
                )

                /* 
                    `call` opcode returns a value that get pop out of the stack using the
                    `pop` opcode
                */
                pop(call(gas(), vic, 0, 0x00, 0x04, 0, 0))
            }

            for (uint256 i = start + 1; i < len; i++) {
                assembly {
                    /* 
                        `call` opcode returns a value that get pop out of the stack using the
                        `pop` opcode
                    */
                    pop(call(gas(), vic, 0, 0x00, 0x04, 0, 0))
                }
                vic.transferFrom(address(this), msg.sender, i);
            }
            vic.transferFrom(address(this), msg.sender, start);
        }
    }
}
