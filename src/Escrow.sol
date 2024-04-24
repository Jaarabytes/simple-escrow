// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// Author: Jaarabytes 
// Understanding this contract: The buyer deposits money in me (the contract) and the 
// seller (receiver) can only withdraw when certain conditions are met. 

// / This is not that easy for me to implement but I have to try. 
// LET'S GOOOO!!!
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Escrow {
    address public buyer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public seller = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;
    bool private _entered;
    uint256 public totalAmount = 3 ether;
    uint256 public amountDeposited;
    uint16 public percentage = 95;
    uint256 public constant MINIMUM_TIME = 4 days;
    bool private termsAgreed;
    uint256 public depositTime;
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public withdrawals;

    event DepositMade(address indexed buyer, uint256 amount);
    event WithdrawalMade(address indexed seller);


    // Modifier to prevent reentrancy attacks
    modifier nonReentrant {
        require(!_entered, "Function has already been entered.");
        _entered = true;
        _;
        _entered = false;
    }

    // @modifier: checks if either the buyer and sender have agreed to their respective terms
    modifier agreeToTerms {
        require(msg.sender == seller || msg.sender == buyer, "Only buyer or seller can initiate this contract!");
        // require(block.timestamp >= depositTime + MINIMUM_TIME, "Minimum time (4 days) has not yet reached");
        termsAgreed = true;
        _;
    }

    constructor(address _buyer, address _seller, uint256 _totalAmount) {
        _buyer = buyer;
        _seller = seller;
        _totalAmount = totalAmount;
        _entered = false;
    }

    // Function for buyer to deposit Ether into the escrow
    function deposit(uint256 amount) public payable nonReentrant {
        require(buyer != address(0), "Buyer address must be set");
        require(msg.value > 0, "Deposit amount must be greater than zero");
        require(msg.value >= amount, "Insufficient deposit amount");
        depositTime = block.timestamp;
        deposits[buyer] += amount;
        amountDeposited += amount;

        emit DepositMade(buyer, amount);
    }

    // Function for withdrawing the ether after the terms and agreements have been reached
    function withdraw () public payable nonReentrant agreeToTerms {
        require(msg.sender == seller , "Only seller can withdraw!");
        require(seller != address(0), "Seller address should be a valid address!");
        uint256 withdrawableAmount = (percentage * amountDeposited)/ 100;

        require(msg.value <= withdrawableAmount, "Cannot withdraw more than the balance");


        payable(seller).transfer(withdrawableAmount);
        withdrawals[seller] += withdrawableAmount;

        
        emit WithdrawalMade(seller);
    }
}
