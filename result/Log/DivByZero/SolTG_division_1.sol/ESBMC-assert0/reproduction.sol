contract Reproduction {
    C private target;

    constructor(address _target) {
        target = C(_target);
    }

    function trigger() public view returns (uint) {
        return target.f(1, 0);
    }
}