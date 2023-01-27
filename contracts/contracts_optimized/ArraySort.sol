// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract OptimizedArraySort {
    function sortArray(uint256[] calldata data)
        external
        pure
        returns (uint256[] memory _data)
    {
        _data = data;
        uint256 len = _data.length;
        uint256 temp1;
        uint256 temp2;
        unchecked {
            for (uint256 i; i < len; i++) {
                for (uint256 j = i + 1; j < len; j++) {
                    temp1 = _data[i];
                    temp2 = _data[j];
                    if (temp1 > temp2) (_data[j], _data[i]) = (temp1, temp2);
                }
            }
        }
        return _data;
    }
}
