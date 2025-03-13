contract Reproduction {
    C private target;

    constructor(address _target) {
        target = C(_target);
    }

    function prepare() public pure returns (uint, uint) {
        return (0, 0);
    }

    function trigger() public view returns (uint) {
        (uint x, uint y) = prepare();
        return target.f(x, y);
    }
}