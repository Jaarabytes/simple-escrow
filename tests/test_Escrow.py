#Test functionality of Escrow contract
import pytest
from brownie import Token, accounts

@pytest.fixture
def token():
    return accounts[0].deploy(Token, "Test Token" , "TST", 18, 1000)

def test_transfer(token):
    token.transfer(accounts[1], 100, {"from": accounts[1]})
    assert token.balanceOf(accounts[0]) == 900