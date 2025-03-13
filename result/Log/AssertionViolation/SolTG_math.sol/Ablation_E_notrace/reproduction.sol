interface IMath {
    function max(uint256 a, uint256 b) external pure returns (uint256);
    function min(uint256 a, uint256 b) external pure returns (uint256);
    function average(uint256 a, uint256 b) external pure returns (uint256);
    function ceilDiv(uint256 a, uint256 b) external pure returns (uint256);
}

contract ReproduceMathVuln {
    IMath public math;

    constructor(address mathAddress) {
        math = IMath(mathAddress);
    }

    function triggerOverflow() public view returns (uint256) {
        uint256 a = type(uint256).max;
        uint256 b = 1;
        return math.average(a, b);
    }

    function forceAssertionFailure() public view returns (uint256) {
        return math.average(2**255, 2**255 - 1);
    }

    function callMax() public view returns (uint256) {
        return math.max(0, 0);
    }

    function callMin() public view returns (uint256) {
        return math.min(type(uint256).max, 0);
    }

    function callCeilDiv() public view returns (uint256) {
        return math.ceilDiv(type(uint256).max, 2);
    }
}