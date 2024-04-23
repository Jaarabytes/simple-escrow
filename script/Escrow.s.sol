// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Script, console} from "forge-std/Script.sol";
import "../src/Escrow.sol";


contract CounterScript is Script {
    function setUp() public {
        Escrow escrow = new Escrow(); 
    }

    function run() public {
        vm.broadcast();
    }
}
