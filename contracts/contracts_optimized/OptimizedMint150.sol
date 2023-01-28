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
        address attacker = msg.sender;
        NotRareToken vic = NotRareToken(victim);
        unchecked {
            uint256 start = vic.balanceOf(vic.ownerOf(1)) + 1;
            uint256 len = 150 + start;
            vic.mint();
            for (uint256 i = start + 1; i < len; i++) {
                vic.mint();
                vic.transferFrom(address(this), attacker, i);
            }
            vic.transferFrom(address(this), attacker, start);
        }
    }
}
