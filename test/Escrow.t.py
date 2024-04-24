# Test Escrow contract


from eth_tester import EthereumTester
from eth_utils import to_wei

from vyper.compiler import compile_code


# Compile the contract code
bytecode, abi = compile_code(filepath='src/Escrow.vy')

#Create an ethereum tester instance
tester = EthereumTester()

#Deploy the contract
contract = tester.deploy(bytecode, abi, args = [accounts[0], accounts[1], to_wei(10 , "ether")])

#Test deposit functionality

def test_deposit():
    #Send deposit from buyer
    contract.deposit(to_wei(5, "ether"), transact={"from": accounts[0]})

    #Check buyer balance
    assert contract.deposits(accounts[0]) == to_wei(5 , "ether")

def test_withdraw():
    #Bypass time requirement
    tester.time_travel(block.timestamp + 21600)

    #Seller withdraws funds
    contract.withdraw(transact={"from": accounts[1]})

    #Check seller's balance
    assert test.get_balance(accounts[1]) == to_wei(9.5, "ether")