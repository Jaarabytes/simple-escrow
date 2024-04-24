// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Test, console} from "forge-std/Test.sol";
import "../src/Escrow.sol";


contract EscrowTest is Test {
    address public buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public amountToDeposit = 3 ether;
    uint256 public amountToWithdraw = 1 ether;
    address public seller = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;
    Escrow escrow = new Escrow(buyer, seller, amountToDeposit);
    

    function testDepositFunction () public {
        console.log("The buyers balance is: %e", buyer.balance);
        assertEq(buyer.balance, 10000 ether);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        assertEq(address(escrow).balance, 3 ether);
        console.log("Escrow's balance is: %e", address(escrow).balance);
    }

    function testWithdrawFunction () public {
        uint256 initialSellerBalance = seller.balance;
        console.log("The seller's balance is: %e", seller.balance);
        assertEq(seller.balance, 10000 ether);
    
        
        vm.deal(buyer, amountToDeposit); //Try to deposit as escrow if tests fail!
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        uint256 initialEscrowBalance = address(escrow).balance;
        console.log("Escrow's balance after depositing is: %e", address(escrow).balance);

        // Acting as the seller so as to withdraw funds
        vm.prank(seller);
        escrow.withdraw();
        uint256 finalSellerBalance = seller.balance;
        uint256 finalEscrowBalance = address(escrow).balance;
        console.log("The seller's balance after withdrawal is: ", finalSellerBalance);
        console.log("Escrow's balance after withdrawal is: ", finalEscrowBalance);
        assertLt(finalEscrowBalance, initialEscrowBalance, "Escrow's balance should decrease!");
        assertGt(finalSellerBalance, initialSellerBalance, "Seller's balance should increase!");
    }
}
