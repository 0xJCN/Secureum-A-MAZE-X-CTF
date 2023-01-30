# @version ^0.3.7

owner: immutable(address)

@external
@payable
def __init__():
    owner = tx.origin

@external
@payable
def __default__():
    assert tx.origin == owner, "!owner"
    msg_data: Bytes[32] = slice(msg.data, 0, 32)
    addr: address = extract32(msg_data, 0, output_type=address)
    selfdestruct(addr)
