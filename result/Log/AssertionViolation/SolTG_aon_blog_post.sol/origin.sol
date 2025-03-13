contract C {
    bool a;
    bool b;
    bool c;
    bool d;
    bool e;
    bool f;

    function press_A() public {
        if (e) {
            a = true;
        } else {
            reset();
        }
    }

    function press_B() public {
        if (c) {
            b = true;
        } else {
            reset();
        }
    }

    function press_C() public {
        if (a) {
            c = true;
        } else {
            reset();
        }
    }

    function press_D() public {
        d = true;
    }

    function press_E() public {
        if (d) {
            e = true;
        } else {
            reset();
        }
    }

    function press_F() public {
        if (b) {
            f = true;
        } else {
            reset();
        }
    }

    function reset() internal {
        a = false;
        b = false;
        c = false;
        d = false;
        e = false;
        f = false;
    }

    function checkInvariant() public {
        assert(!f);
    }
}
