interface IVulnerableContract {
    function press_A() external;
    function press_B() external;
    function press_C() external;
    function press_D() external;
    function press_E() external;
    function press_F() external;
    function checkInvariant() external;
}

contract ReproductionContract {
    IVulnerableContract public target;

    constructor(address _target) {
        target = IVulnerableContract(_target);
    }

    function triggerBug() public {
        target.press_D();
        target.press_E();
        target.press_A();
        target.press_C();
        target.press_B();
        target.press_F();
        target.checkInvariant();
    }
}