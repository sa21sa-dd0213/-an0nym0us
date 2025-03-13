interface ICallWrapper {
    function callwrap(address called) external;
    function modifystorage(uint newdata) external;
}

contract Reproduction {
    ICallWrapper public target;
    bool public reentered;

    constructor(address _target) {
        target = ICallWrapper(_target);
    }

    function setup() public {
        target.modifystorage(0);
    }

    function trigger() public {
        target.callwrap(address(this));
    }

    fallback() external payable {
        if (!reentered) {
            reentered = true;
            target.modifystorage(1);
        }
    }
}