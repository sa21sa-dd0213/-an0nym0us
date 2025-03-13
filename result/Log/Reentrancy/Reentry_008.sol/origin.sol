//https://github.com/fsainas/contracts-verification-benchmark/blob/main/contracts/bank/
//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.2;

/// @custom:version conformant to specification
contract Bank {
    mapping (address => uint) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        /// @custom:preghost function withdraw
        uint old_user_balance = balances[msg.sender];
        require(amount > 0);
        // require(amount <= balances[msg.sender]);

        balances[msg.sender] -= amount;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
        /// @custom:postghost function withdraw
        uint new_user_balance = balances[msg.sender];
        assert(new_user_balance == old_user_balance - amount);
}
}