contract Reproduction {
    cs6 public vulnerableContract;

    constructor(address _vulnerableAddress) {
        vulnerableContract = cs6(_vulnerableAddress);
    }

    function setup() public {
        for (uint i = 0; i < 10; i++) {
            vulnerableContract.f();
        }
    }

    function triggerVulnerability() public {
        vulnerableContract.g(false);
    }
}