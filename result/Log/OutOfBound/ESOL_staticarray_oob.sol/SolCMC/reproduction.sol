contract Reproduction {
    MyContract public vulnerable;

    constructor(address _vulnerable) public {
        vulnerable = MyContract(_vulnerable);
    }

    function triggerVulnerability() public {
        vulnerable.func_array_loop();
    }
}