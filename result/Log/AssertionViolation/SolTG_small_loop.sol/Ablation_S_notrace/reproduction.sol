contract Reproduction {

    Loop1 loop1;

    constructor() {
        loop1 = new Loop1();
    }

    function triggerVulnerability() public {
        loop1.mini(5);
        loop1.enter();
    }
}