pragma solidity ^0.8.0;

contract A8 {
	int public x;
	constructor() { x = 1; }
    function get8() public returns (int) {
		return x;
	}
    function set8(int _x) public{
		x = _x;
	}
}

contract B8 {
    A8 a;
    int y;
	constructor(){
        a = new A8();
        a.set8(2);
	}

	function f8() public {
        int tmp = a.get8();
        y = 0;
		if(tmp > 2){
			y = y + 10;
		}else{y = y - 1;}
		assert(y > 0);
	}

}