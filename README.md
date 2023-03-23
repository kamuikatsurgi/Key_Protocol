<h1>
  hey there
  <img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="30px"/>
</h1>

**Description:**

Key Protocol is a smart contract system that allows users to insure their ERC721 tokens and receive compensation in ETH in case of loss or theft of their tokens.

**Contracts**

**KeyProtocol**

The KeyProtocol contract is the main contract of the system. It allows users to create new vaults for their ERC721 tokens, deposit ETH into the vaults, and make claims for compensation in case of loss or theft of their tokens.

**nftVault**

The nftVault contract is a helper contract that is used by the KeyProtocol contract to create new vaults for ERC721 tokens. The nftVault contract enforces a minimum waiting period before the creator of the vault can claim the ETH that has been deposited into the vault.

**Creating a new vault**

To create a new vault for an ERC721 token, call the createVault function on the KeyProtocol contract and pass in the address of the ERC721 contract as an argument. This will create a new nftVault contract that is linked to the specified ERC721 contract.

**Depositing ETH into a vault**

To deposit ETH into a vault, call the deposit function on the KeyProtocol contract and pass in the address of the vault contract as an argument. You must also send the amount of ETH that you want to deposit along with the transaction.

**Making a claim**

To make a claim for compensation, call the claim function on the KeyProtocol contract and pass in the address of the vault contract, the address of the ERC721 contract, and the ID of the token that was lost or stolen as arguments. You must also be the owner of the token and have approval from the ERC721 contract to burn the token.
