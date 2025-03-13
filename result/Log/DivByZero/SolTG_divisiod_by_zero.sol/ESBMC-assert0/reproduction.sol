interface IVulnerable {
    function div(uint256 a, uint256 b) external returns (uint256);
    function mod(uint256 a, uint256 b) external returns (uint256);
}

contract Reproduction {
    IVulnerable public target;

    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function triggerDivByZero() public {
        target.div(1, 0);
    }

    function triggerModByZero() public {
        target.mod(1, 0);
    }
}