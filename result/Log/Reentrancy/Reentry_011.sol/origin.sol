//https://github.com/fsainas/contracts-verification-benchmark/blob/main/contracts/call-wrapper
//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.2;

/// @custom:version reentrant `callwrap`.
contract CallWrapper {
    uint data;

    function callwrap(address called) public {
        /// @custom:preghost function callwrap
        uint _balance = address(this).balance;

        called.call("");

        /// @custom:postghost function callwrap
        assert(_balance == address(this).balance);
    }

}