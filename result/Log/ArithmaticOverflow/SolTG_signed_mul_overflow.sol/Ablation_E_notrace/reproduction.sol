interface IC {
    function f(int x, int y) external pure returns (int);
}

contract Exploit {
    IC target;

    constructor(address _target) {
        target = IC(_target);
    }

    function attack() public pure returns (int) {
        return -2131231 * -1;
    }
}