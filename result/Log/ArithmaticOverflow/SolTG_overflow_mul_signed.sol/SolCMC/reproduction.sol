contract Reproduction {
    C public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = C(_vulnerableContract);
    }

    function exploit() public {
        vulnerableContract.f(100);
    }
}