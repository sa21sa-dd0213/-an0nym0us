//https://github.com/fsainas/contracts-verification-benchmark/blob/main/contracts/crowdfund
// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >= 0.8.2;


/// @custom:version conforming to specification.
contract Crowdfund {
    uint immutable end_donate;    // last block in which users can donate
    uint immutable goal;          // amount of ETH that must be donated for the crowdfunding to be succesful
    address immutable owner;      // receiver of the donated funds
    mapping(address => uint) public donors;

    constructor (address payable owner_, uint end_donate_, uint256 goal_) {
        owner = owner_;
        end_donate = end_donate_;
	    goal = goal_;	
    }
    
    function donate() public payable {
        require (block.number <= end_donate);
        donors[msg.sender] += msg.value;
    }

    function withdraw() public {
        require (block.number > end_donate);
        require (address(this).balance >= goal);

        (bool succ,) = owner.call{value: address(this).balance}("");
        require(succ);
    }
    
    function reclaim() public { 
        require (block.number > end_donate);
        require (address(this).balance < goal);
        require (donors[msg.sender] > 0);

        uint amount = donors[msg.sender];
        donors[msg.sender] = 0;

        (bool succ,) = msg.sender.call{value: amount}("");
        require(succ);
    }
    uint saved;
    bool done;

    function invstore() public {
        require(block.number > end_donate);
        require(!done);

        saved = address(this).balance;
        done = true;
    }

    function invariant(uint choice) public {
        require(block.number > end_donate);
        require(done);

        assert(address(this).balance <= saved);
    }
}