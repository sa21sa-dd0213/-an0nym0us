pragma solidity ^0.8.11;

contract _MAIN_ {
    uint public a;
    uint public b;

    function set() public {
        a = 3;
        b = 0;
    }

    function check() public {
        uint _a = 0;
        set();
        _a = this.a();

        require(_a == 3);

        assert(_a == 4);
    }
}