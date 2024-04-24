// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Script, console} from "forge-std/Script.sol";
import "../src/Escrow.sol";


contract CounterScript is Script {
    Escrow public escrow;
    
    function setUp() public {
        address buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address seller = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;
        uint256 amount = 1 ether;
        escrow = new Escrow(buyer, seller, amount);
    }

    function run() public {
        
        vm.broadcast();
    }
}
