interface IVulnerable {
    function f(uint8 x) external pure returns (uint8);
}

contract Reproduce {
    function trigger(address target) public view returns (uint8) {
        return IVulnerable(target).f(1);
    }
}