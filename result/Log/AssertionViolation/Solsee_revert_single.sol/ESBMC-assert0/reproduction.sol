interface IMain {
    function test(uint x, uint y) external;
    function vul() external;
    function getTotalSupply() external returns (uint);
}

contract Reproduction {
    IMain public target;

    constructor(address _target) {
        target = IMain(_target);
    }

    function setup() public {
        target.test(100, 50); // Ensures totalSupply = 100
    }

    function trigger() public {
        target.vul(); // Calls vul after setting totalSupply to 100
    }

    function exploit() public {
        setup();
        trigger();
    }
}