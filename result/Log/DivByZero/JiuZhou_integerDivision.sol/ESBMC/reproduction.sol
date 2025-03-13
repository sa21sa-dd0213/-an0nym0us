interface IGetWageNumber {
    function setCoefficient(uint256 _co) external;
    function calculateWage(uint256 dayNumber) external view;
}

contract Reproduction {
    IGetWageNumber public target;

    constructor(address _target) {
        target = IGetWageNumber(_target);
    }

    function setup() external {
        target.setCoefficient(0);
    }

    function trigger() external view {
        target.calculateWage(1);
    }
}