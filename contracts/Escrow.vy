#pragma version 0.3.10

# Author: Jaarabytes 
# Understanding this contract: The buyer deposits money in me (the contract) and the 
# seller (receiver) can only withdraw when agreements are met. 

# Basic agreement is the funds stay in me (contract) for 6 hours and seller can
# only withdraw 95% of the funds. Amen!

#Define variables
buyer: public(address)
seller: public(address)
amount: public(uint256)
is_withdrawing: bool
terms_agreed: bool


# 6 hours as seconds
MINIMUM_TIME: public(uint256)
depositTime: public(uint256)
deposits: public(HashMap[address, uint256])

#events for deposit, agreement and withdrawal
event Deposit:
    buyer: indexed(address)
    amount: uint256
event Terms_agreed:
    terms_agreed: bool
event Withdrawal:
    seller: indexed(address)
    amount: uint256


@external
def __init__(buyer: address, seller: address, amount: uint256):
    self.buyer = buyer
    self.seller = seller
    self.amount = amount
    self.depositTime = block.timestamp
    self.is_withdrawing = False

@external
def deposit(amount: uint256) -> bool:
    # Only buyer can deposit funds
    assert msg.sender == self.buyer, "Only buyer can deposit funds!"
    assert self.buyer != empty(address), "Buyer address must be a valid address"
    assert amount > 0, "Deposit should be greater than zero"
    self.deposits[self.buyer] += amount

    #emit successful deposit
    log Deposit(self.buyer, self.amount)
    return True


@payable
@external
def withdraw() -> bool:

    # Only seller can withdraw funds
    assert msg.sender == self.seller, "Only seller can withdraw funds!"
    assert self.seller != empty(address), "Seller address must be a valid address"
    assert block.timestamp >= self.depositTime + self.MINIMUM_TIME, "Minimum time (6 hours) has not yet passed"

    #emit succesful term agreement
    log Terms_agreed(self.terms_agreed)

    # Calculate withdrawable amount
    self.MINIMUM_TIME = 21600
    withdrawableAmount: uint256 = (self.amount * 95) / 100

    # Prevent re-entrancy attacks
    assert not self.is_withdrawing , "Withdrawal in progress!"
    self.is_withdrawing = True

    #Withdrawal process
    self.amount -= withdrawableAmount
    send(msg.sender, withdrawableAmount)
    self.is_withdrawing = False

    #emit successful withdrawal
    log Withdrawal(self.seller, msg.value)
    return True

