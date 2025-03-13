contract Reproduction {
    Math public mathContract;

    constructor(address _mathAddress) {
        mathContract = Math(_mathAddress);
    }

    function triggerVulnerability() public view returns (uint256) {
        uint256 a = 5;
        uint256 b = 5;

        return mathContract.min(a, b);
    }
}