contract Reproduction {
    function deployVulnerableContract() public {
        new C();
    }

    function trigger() public {
        this.deployVulnerableContract();
    }
}