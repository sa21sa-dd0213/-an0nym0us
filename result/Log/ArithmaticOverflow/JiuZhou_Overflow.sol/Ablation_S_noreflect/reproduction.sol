contract Reproduction {
    Overflow public target;

    constructor(address _target) {
        target = Overflow(_target);
    }

    function setup() public {
        target.add(1);
    }

    function triggerOverflow() public {
        target.add(115792089237316195423570985008687907853269984665640564039457584007913129639935);
    }
}