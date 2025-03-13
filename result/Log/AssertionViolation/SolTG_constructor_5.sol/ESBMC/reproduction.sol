contract Reproduction {
    C5 public vulnerableContract;

    constructor(uint a, uint b) {
        vulnerableContract = new C5(a, b);
    }

    function triggerVulnerability() public {
        // First interaction to set x to a large value
        vulnerableContract.g5(1099511627776, 0);

        // Trigger the vulnerability by calling f5
        vulnerableContract.f5(1099511627776);
    }
}