contract ReproductionC {
    int private storedX;
    int private storedY;

    function setValues(int x, int y) public {
        storedX = x;
        storedY = y;
    }

    function triggerMultiplication() public view returns (int) {
        return multiply(storedX, storedY);
    }

    function multiply(int x, int y) internal pure returns (int) {
        return x * y; // Potential overflow/underflow vulnerability
    }
}