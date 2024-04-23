// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Test, console} from "forge-std/Test.sol";
import "../src/Escrow.sol";


contract EscrowTest is Test {
    Escrow escrow = new Escrow();
    address public buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public amountToDeposit = 3 ether;
    uint256 public amountToWithdraw = 1 ether;
    address public seller = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    function testDepositFunction () public {
        console.log("The buyers balance is: %e", buyer.balance);
        assertEq(buyer.balance, 10000 ether);
        escrow.deposit{value: amountToDeposit}(buyer, amountToDeposit);
        assertEq(address(escrow).balance, 3 ether);
        console.log("Escrow's balance is: %e", address(escrow).balance);
    }

    function testWithdrawFunction () public {
        console.log("The seller's balance is: %e", seller.balance);
        assertEq(seller.balance, 10000 ether);
        escrow.deposit{value: amountToDeposit}(buyer, amountToDeposit);
        console.log("Escrow's balance is: %e", address(escrow).balance);
        escrow.withdraw{value: amountToWithdraw}(seller);
        console.log("The seller's balance is now: ", seller.balance);
        console.log("Escrow's balance is now: ", address(escrow).balance);
        assertLt(address(escrow).balance, 3 ether);
        assertGt(seller.balance, 10000 ether);
    }
}
