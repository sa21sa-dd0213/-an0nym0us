interface IVulnerable {
    function f(uint8 x) external pure returns (uint8);
}

contract Reproduction {
    IVulnerable public vulnerableContract;
    uint8 x = 100;

    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerable(_vulnerableContract);
    }

    function exploit() public {
        vulnerableContract.f(x);
    }
}