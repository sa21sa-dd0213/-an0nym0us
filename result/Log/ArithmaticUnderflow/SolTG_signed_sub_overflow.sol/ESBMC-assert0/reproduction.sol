contract Reproduction {
    C public target;

    constructor(address _target) {
        target = C(_target);
    }

    function triggerOverflow() public view returns (int) {
        return target.f(type(int).min, 1);
    }
}