interface C {
    function f(int x, int y) external pure returns (int);
}

contract Reproduction {
    IC public target;

    constructor(address _target) {
        target = IC(_target);
    }

    function trigger() public view returns (int) {
        return target.f(
            -57896044618658097711785492504343953926634992332820282019728792003956564819968,
            -1
        );
    }
}