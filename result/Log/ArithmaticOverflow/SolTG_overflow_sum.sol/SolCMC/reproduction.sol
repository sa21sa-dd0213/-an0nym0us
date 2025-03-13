interface IVulnerable {
    function f(uint8 x) external pure returns (uint8);
}

contract Reproduction {
    IVulnerable public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerable(_vulnerableContract);
    }

    function triggerVulnerability() external {
        uint8 x = 255;
        vulnerableContract.f(x);
    }
}