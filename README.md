<h1>
  Hello!
  <img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="30px"/>
</h1>

**Description:**

Key Protocol is a smart contract system that allows the NFT collection owners to assure their users by insuring their ERC721 tokens against ETH tokens.
This assures users that the project is legitimate and the floor price of the collection will not drop to zero and if that happens they still can get some insured ETH tokens against their ERC721 token but to do that they have to burn that token. The ability to lock tokens to an NFT and require the NFT to be burned in order to claim those tokens creates a built-in mechanism for maintaining the floor price of the NFT. This could be particularly useful for NFTs associated with projects or platforms that have a high level of uncertainty or volatility.

<h1>
  Contracts:
</h1>

<h2>
  KeyProtocol Contract:
</h2>

The KeyProtocol contract is the main contract. It allows anyone to create new vaults for ERC721 tokens, deposit ETH into the vaults, and make claims for compensation in case of loss.

<h2>
  nftVault Contract:
</h2>

The nftVault contract is a helper contract that is used by the KeyProtocol contract to create new vaults for ERC721 tokens. The nftVault contract enforces a minimum waiting period before the user can claim the ETH that has been deposited into the vault.

<h2>
  Creating a new vault for respective ERC721 token:
</h2>

To create a new vault for an ERC721 token, call the createVault function on the KeyProtocol contract and pass in the address of the ERC721 contract as an argument. This will create a new nftVault contract that is linked to the specified ERC721 contract.

<h2>
  Depositing ETH into a vault:
</h2>

To deposit ETH into a vault, call the deposit function on the KeyProtocol contract and pass in the address of the vault contract as an argument. You must also send the amount of ETH that you want to deposit along with the transaction.

<h2>
  Making a claim:
</h2>

To make a claim for compensation, call the claim function on the KeyProtocol contract and pass in the address of the vault contract, the address of the ERC721 contract, and the ID of the token as arguments. You must also be the owner of the token or approval from the ERC721 contract to burn the token.


Deployed Contract Address: 0x7ad2Ca6DcF9EDf6c798574cc4F2615a065368c26
<br>
Blockchain Explorer Link:  https://blockscout.scroll.io/address/0x7ad2Ca6DcF9EDf6c798574cc4F2615a065368c26
