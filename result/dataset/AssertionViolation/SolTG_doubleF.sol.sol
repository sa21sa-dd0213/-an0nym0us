pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.20;



contract doubleF{
    uint256 x;
    function f() public  {
        x++;
    }

    function g() public view returns (uint256) {
        assert(true);
        if(x > 2){
            assert(false);
        }
        return 1;
    }
}
