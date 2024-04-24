# Author: Jaarabytes 
# Understanding this contract: The buyer deposits money in me (the contract) and the 
# seller (receiver) can only withdraw when agreements are met. 

# This is not that easy for me to implement but I have to try. 
# LET'S GOOOO!!!
# Escrow contract in Vyper

contract Escrow:
    # Define variables
    buyer: public(address)
    seller: public(address)
    amount: public(uint256)
    percentage: public(uint8) = 95

    # 6 hours as seconds
    MINIMUM_TIME: public(uint256) = 21600
    depositTime: public(uint256)
    deposits: public(map(address, uint256))
    withdrawals: public(map(address, uint256))

    def __init__(buyer: address, seller: address, amount: uint256):
        self.buyer = buyer
        self.seller = seller
        self.amount = amount
        self.depositTime = block.timestamp

    @external
    def deposit(amount: uint256) -> bool:
        # Only buyer can deposit funds
        assert msg.sender == self.buyer, "Only buyer can deposit funds!"
        assert self.buyer != address(0), "Buyer address must be a valid address"
        assert amount > 0, "Deposit should be greater than zero"
        self.deposits[self.buyer] += amount
        return True

    @external
    def withdraw() -> bool:
        # Calculate withdrawable amount
        withdrawableAmount: uint256 = (self.amount * self.percentage) // 100

        # Only seller can withdraw funds
        assert msg.sender == self.seller, "Only seller can withdraw funds!"
        assert self.seller != address(0), "Seller address must be a valid address"

        # Check if minimum time has passed and proceed with withdrawal
        if block.timestamp >= self.depositTime + self.MINIMUM_TIME:
            self.seller.transfer(withdrawableAmount)
            return True
        else:
            return False
