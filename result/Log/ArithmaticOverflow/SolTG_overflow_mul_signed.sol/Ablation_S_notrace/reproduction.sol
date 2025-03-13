
contract Reproduction {
    C public c;

    constructor(address _cAddress) {
        c = C(_cAddress);
    }

    function triggerVulnerability() public returns (uint8) {
        return c.f(0);
    }
}