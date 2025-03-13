interface IC {
    function r(uint i) external view returns (uint);
}

contract Exploit {
    IC target;

    constructor(address _target) {
        target = IC(_target);
    }

    function trigger() public view returns (uint) {
        return target.r(0);
    }
}