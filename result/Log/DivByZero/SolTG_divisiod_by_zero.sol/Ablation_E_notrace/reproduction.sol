interface IVulnerable {
    function div(uint256 a, uint256 b) external returns (uint256);
    function mod(uint256 a, uint256 b) external returns (uint256);
}

contract Reproduction {
    IVulnerable public target;
    
    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function setup() public pure returns (uint256, uint256) {
        return (1, 0);
    }

    function triggerDivByZero() public {
        (uint256 a, uint256 b) = setup();
        target.div(a, b);
    }

    function triggerModByZero() public {
        (uint256 a, uint256 b) = setup();
        target.mod(a, b);
    }
}