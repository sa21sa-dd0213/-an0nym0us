contract Reproduction {
    C public target;

    constructor(address _target) {
        target = C(_target);
    }

    function triggerOverflow() public pure returns (int) {
        int x = 10000;
        int y = 2;
        return x * y;
    }

    function exploit() public view returns (int) {
        return target.f(10000, 2);
    }
}