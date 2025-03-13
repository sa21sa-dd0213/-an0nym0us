
// Original contract under test.
contract C {
    function f(int x, int y) public pure returns (int) {
        return x + y;
    }
}

// Reproduction contract for formal verification.
contract CReproduction {
    C c;

    // Deploy a new instance of contract C.
    constructor() {
        c = new C();
    }

    // Calls C.f with the given inputs and verifies that the result equals x + y.
    function reproduceAndVerify(int x, int y) public view returns (int) {
        int result = c.f(x, y);
        // Formal verification: ensure that the returned value is exactly x + y.
        // In a formal verification setting, the assertion below can be used to prove the function's correctness.
        assert(result == x + y);
        return result;
    }
}