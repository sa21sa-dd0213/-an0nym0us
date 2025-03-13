interface ICallWrapper {
    function callwrap(address called) external;
    function modifystorage(uint newdata) external;
}

contract Reproduction {
    ICallWrapper public target;
    uint public reentered = 0;

    constructor(address _target) {
        target = ICallWrapper(_target);
    }

    function setup(uint newdata) public {
        target.modifystorage(newdata);
    }

    function trigger() public {
        target.callwrap(address(this));
    }

    fallback() external payable {
        if (reentered == 0) {
            reentered = 1;
            target.modifystorage(999);
        }
    }
}