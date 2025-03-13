interface IVulnerable {
    function test(uint x, uint y) external;
    function getTotalSupply() external returns (uint);
    function vul() external;
}

contract Reproduction {
    IVulnerable public target;

    constructor(address _target) {
        target = IVulnerable(_target);
    }

    function setupState() public {
        target.test(100, 50); // Ensure totalSupply = 100
    }

    function triggerBug() public {
        target.vul(); // Triggers assertion failure
    }

    function executeExploit() public {
        setupState();
        triggerBug();
    }
}