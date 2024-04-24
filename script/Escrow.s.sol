// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Script, console} from "forge-std/Script.sol";
import "../src/Escrow.sol";


contract CounterScript is Script {
    address public buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public amountToDeposit = 3 ether;
    uint256 public amountToWithdraw = 1 ether;
    address public seller = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;
    function setUp() public {
        Escrow escrow = new Escrow(buyer, seller, amountToDeposit); 
    }

    function run() public {
        vm.broadcast();
    }
}
