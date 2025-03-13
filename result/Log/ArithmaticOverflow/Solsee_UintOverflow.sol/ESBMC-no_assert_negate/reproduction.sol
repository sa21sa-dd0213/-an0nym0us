interface IMain {
    function triggerOverflow() external;
}

contract Reproduction is IMain {
    address public target;

    constructor() public {
    }

    function setup() public {
        target = address(new _MAIN_());
    }

    function triggerOverflow() external override {
        _MAIN_ vuln = new _MAIN_();
    }
}