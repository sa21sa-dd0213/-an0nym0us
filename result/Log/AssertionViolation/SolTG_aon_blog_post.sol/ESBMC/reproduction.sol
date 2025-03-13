contract Reproduction {
    C public target;

    constructor(address _target) {
        target = C(_target);
    }

    function setupExploit() public {
        target.press_D();
        target.press_E();
        target.press_A();
        target.press_C();
        target.press_B();
        target.press_F();
    }

    function triggerCheck() public {
        target.checkInvariant();
    }
}