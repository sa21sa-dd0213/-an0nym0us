contract Reproduce {
    C target;

    constructor(address _target) {
        target = C(_target);
    }

    function trigger() public view returns (int) {
        int x = type(int).max;
        int y = 1;
        return target.f(x, y);
    }
}