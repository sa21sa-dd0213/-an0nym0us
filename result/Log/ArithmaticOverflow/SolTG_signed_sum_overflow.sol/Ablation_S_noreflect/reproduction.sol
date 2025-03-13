contract Reproduction {
    C public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = C(_vulnerableContract);
    }

    function triggerOverflow() public view returns (int) {
        int x = -57896044618658097711785492504343953926634992332820282019728792003956564819968;
        int y = -1;
        return vulnerableContract.f(x, y);
    }
}