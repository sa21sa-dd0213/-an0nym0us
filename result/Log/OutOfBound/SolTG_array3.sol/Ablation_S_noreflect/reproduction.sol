contract Reproduction {
    C public vulnerableContract;

    constructor(address _vulnerableAddress) {
        vulnerableContract = C(_vulnerableAddress);
    }

    function triggerOutOfBounds() public view returns (uint) {
        return vulnerableContract.r(0);
    }
}