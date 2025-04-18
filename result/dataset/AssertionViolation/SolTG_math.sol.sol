pragma solidity ^0.8.0;

contract  Math {


    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) public pure returns (uint256) {
        if(a >= b){
            assert(a>=b);
            return a;
        } else {
            assert(b>a);
            return b;
        }
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) public pure returns (uint256) {
        if(a < b){
            assert(a<b);
            return a;
        } else {
            assert(b>a);
            return b;
        }
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) public pure returns (uint256) {

        assert(((a & b) + (a ^ b) / 2)*2 == a+b);
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) public pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a / b + (a % b == 0 ? 0 : 1);
    }
}
