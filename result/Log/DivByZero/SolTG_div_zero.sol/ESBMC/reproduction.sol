contract Reproduction {
    function setup() public {
        new C();
    }

    function trigger() public {
        this.setup();
    }
}