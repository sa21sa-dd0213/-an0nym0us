contract Reproduction {
    C public vulnerableContract;
    uint8 x = 200;

    constructor(address _vulnerableContract) {
        vulnerableContract = C(_vulnerableContract);
    }

    function exploit() public {
        vulnerableContract.f(x);
    }
}