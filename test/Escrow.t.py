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
    