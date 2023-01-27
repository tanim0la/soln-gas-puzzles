// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedDistribute {
    address payable immutable c1;
    address payable immutable c2;
    address payable immutable c3;
    address payable immutable c4;
    uint256 private immutable endTime;

    constructor(address[4] memory _contributors) payable {
        c1 = payable(_contributors[0]);
        c2 = payable(_contributors[1]);
        c3 = payable(_contributors[2]);
        c4 = payable(_contributors[3]);
        endTime = block.timestamp + 1 weeks;
    }

    function distribute() external {
        require(block.timestamp > endTime, "cannot distribute yet");

        address _c1 = c1;
        address _c2 = c2;
        address _c3 = c3;
        address _c4 = c4;

        assembly {
            let amount := shr(2, selfbalance())
            pop(call(gas(), _c1, amount, 0, 0, 0, 0))
            pop(call(gas(), _c2, amount, 0, 0, 0, 0))
            pop(call(gas(), _c3, amount, 0, 0, 0, 0))
            selfdestruct(_c4)
        }
    }
}
