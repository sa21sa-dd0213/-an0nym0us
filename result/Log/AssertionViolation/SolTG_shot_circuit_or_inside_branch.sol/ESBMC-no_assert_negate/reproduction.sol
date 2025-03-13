contract Reproduction {
    cs6 public vulnerableContract;

    constructor(address _vulnerableAddress) {
        vulnerableContract = cs6(_vulnerableAddress);
    }

    function setup() public {
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
        vulnerableContract.f();
    }

    function triggerVulnerability() public {
        vulnerableContract.g(false);
    }
}