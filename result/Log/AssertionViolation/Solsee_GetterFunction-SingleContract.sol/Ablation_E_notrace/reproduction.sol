interface VulnerableContract {
    function set() external;
    function check() external;
}

contract ReproduceExploit {
    VulnerableContract public target;

    constructor(address _target) {
        target = VulnerableContract(_target);
    }

    function trigger() public {
        target.check();
    }
}