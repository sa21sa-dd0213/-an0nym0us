
interface IBase {
    function div_zero() external;
}

contract Reproducer {
    IBase base;

    constructor(address _baseAddress) {
        base = IBase(_baseAddress);
    }

    function trigger() public {
        base.div_zero();
    }
}