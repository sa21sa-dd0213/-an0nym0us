contract Reproduction {
    B8 public b8;
    A8 public a;

    constructor() {
        b8 = new B8();
        a = new A8();
    }

    function setup() public {
        a.set8(2);
    }

    function triggerVulnerability() public {
        b8.f8();
    }
}