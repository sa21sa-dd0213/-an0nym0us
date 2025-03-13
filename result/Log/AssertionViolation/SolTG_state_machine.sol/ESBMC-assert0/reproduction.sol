contract Reproduction {
    Csma public vulnerableContract;

    constructor(address _vulnerableAddress) {
        vulnerableContract = Csma(_vulnerableAddress);
    }

    function setup() public {
        vulnerableContract.f(); // Set x to 1
    }

    function trigger() public {
        vulnerableContract.h(); 
        vulnerableContract.h();
        vulnerableContract.h();
        vulnerableContract.h();
        vulnerableContract.h();
        vulnerableContract.h();
        vulnerableContract.j(); 
    }

    function verify() public view {
        vulnerableContract.i(); // Assertion failure when x >= 9
    }
}