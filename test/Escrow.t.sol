// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {Test, console} from "forge-std/Test.sol";
import "../src/Escrow.sol";


contract EscrowTest is Test {
    
    Escrow public escrow;
    address public buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public seller = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;
    uint256 public amountToDeposit = 3 ether;
    uint256 public amountToWithdraw = 1 ether;
    uint256 public depositTime;
    
    function setUp() public {
        escrow = new Escrow(buyer, seller, amountToDeposit);
    }

    function testDepositFunction () public {
        uint256 initialBuyerBalance = buyer.balance;
        console.log("The buyers balance is: %e", initialBuyerBalance);
        assertEq(initialBuyerBalance, 10000 ether);


        vm.startPrank(buyer);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        vm.stopPrank();

        
        assertEq(address(escrow).balance, 3 ether);
        console.log("Escrow's balance is: %e", address(escrow).balance);
    }

    function testWithdrawFunction () public {
        uint256 initialSellerBalance = seller.balance;
        console.log("The seller's balance is: %e", seller.balance);
        assertEq(seller.balance, 10000 ether);
    
        
        vm.deal(buyer, amountToDeposit); //Try to deposit as escrow if tests fail!
        vm.startPrank(buyer);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        vm.stopPrank();
        uint256 initialEscrowBalance = address(escrow).balance;
        console.log("Escrow's balance after depositing is: %e", address(escrow).balance);

        // Acting as the seller so as to withdraw funds
        vm.startPrank(seller);
        // Bypassing the withdrawal time limit
        vm.warp(block.timestamp + 6 hours);
        escrow.withdraw();
        uint256 finalSellerBalance = seller.balance;
        uint256 finalEscrowBalance = address(escrow).balance;
        console.log("The seller's balance after withdrawal is: ", finalSellerBalance);
        console.log("Escrow's balance after withdrawal is: ", finalEscrowBalance);
        assertLt(finalEscrowBalance, initialEscrowBalance, "Escrow's balance should decrease!");
        assertGt(finalSellerBalance, initialSellerBalance, "Seller's balance should increase!");
        vm.stopPrank();
    }

    function test_buyerDeposit () public {
        // Another user who is not buyer trying to deposit
        vm.expectRevert("Only buyer can deposit!");
        escrow.deposit{value: amountToDeposit}(amountToDeposit);


        // Only buyer can deposit
        vm.startPrank(buyer);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        vm.stopPrank();
    }

    function test_sellerWithdraw () public {
        // Another user who is not buyer trying to deposit
        vm.expectRevert("Only buyer or seller can initiate this contract!");
        escrow.withdraw();

        // Only buyer can deposit
        vm.startPrank(seller);
        vm.warp(block.timestamp + 6 hours);
        escrow.withdraw();
        vm.stopPrank();
    }

    function testWithdrawBeforeTime () public {
        vm.deal(buyer, amountToDeposit);
        vm.startPrank(buyer);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        vm.stopPrank();


        //Time limit is not yet reached
        vm.startPrank(seller);
        depositTime = block.timestamp;
        vm.warp(depositTime + 5 hours);
        vm.expectRevert("Minimum time (6 hours) has not yet reached");
        escrow.withdraw();
        vm.stopPrank();
        console.log("Insufficient time test passed!");
    }

    function testWithdrawAtTime () public {
        vm.deal(buyer, amountToDeposit);
        vm.startPrank(buyer);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);

        vm.stopPrank();

        //Time limit is exact
        vm.startPrank(seller);
        depositTime = block.timestamp;
        vm.warp(depositTime + 6 hours);
        escrow.withdraw();
        vm.stopPrank();
        console.log("Exact time test passed!");
    }

    function testWithdrawPastTime () public {
        vm.deal(buyer, 100 ether);
        vm.startPrank(buyer);
        escrow.deposit{value: amountToDeposit}(amountToDeposit);
        vm.stopPrank();
        console.log("Buyer's balance is: %e", buyer.balance);
        console.log("Buyer's balance is:", buyer.balance);

        //Time limit is passed
        vm.startPrank(seller);
        depositTime = block.timestamp;

        console.log("Escrow balance is: %e", address(escrow).balance);
        console.log("Escrow balance is:", address(escrow).balance);
        vm.warp(depositTime + 7 hours);
        escrow.withdraw();
        vm.stopPrank();
        console.log("Extra time test passed!");
    }
}
