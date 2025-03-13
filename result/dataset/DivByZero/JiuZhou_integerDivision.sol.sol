pragma solidity ^0.8.2;

contract getWageNumber {
    uint256 public coefficient;
    uint256 public DailyWage;
    address public boss;
    
    constructor() public{
        DailyWage = 100;
        coefficient = 3;
        boss = msg.sender;
    }
    
    
    function setDailyWage(uint256 _wage) external {
		require(msg.sender == boss);
        DailyWage = _wage;
    }
    
    function setCoefficient(uint256 _co) external {
		require(msg.sender == boss);
        coefficient = _co;
    }
    
    function calculateWage(uint256 dayNumber) external view returns (uint256) {
        require(msg.sender == boss);
		uint256 baseWage = DailyWage / coefficient;
        return baseWage * dayNumber;
    }
}