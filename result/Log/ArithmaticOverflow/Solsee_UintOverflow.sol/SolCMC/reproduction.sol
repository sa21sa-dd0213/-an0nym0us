contract Reproduction {
    address public deployedAddress;

    constructor() public {}

    function deployVulnerable() external {
        _MAIN_ instance = new _MAIN_();
        deployedAddress = address(instance);
    }
}