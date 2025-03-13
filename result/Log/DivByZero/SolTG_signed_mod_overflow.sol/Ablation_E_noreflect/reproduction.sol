contract Reproduction {
    C private target;

    constructor(address _target) {
        target = C(_target);
    }

    function trigger(uint x) public view returns (uint) {
        return target.f(x, 0);
    }
}