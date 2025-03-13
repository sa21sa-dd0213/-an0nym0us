
interface IBank {
    function test() external;
}

contract Reproduction {
    IBank public bank;

    constructor(address _bankAddress) {
        bank = IBank(_bankAddress);
    }

    function triggerVulnerability() public {
        bank.test();
    }
}