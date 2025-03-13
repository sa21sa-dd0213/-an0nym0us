
contract Reproduction {
    _MAIN_ private target;

    constructor(address _target) {
        target = _MAIN_(_target);
    }

    function triggerVulnerability() public {
        target.set();
        target.check();
    }
}