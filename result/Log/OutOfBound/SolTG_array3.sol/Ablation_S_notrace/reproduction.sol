contract Exploit {
    C target;

    constructor(address _target) {
        target = C(_target);
    }

    function trigger() public view returns (uint) {
        return target.r(0);
    }
}