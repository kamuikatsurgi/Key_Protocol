// SPDX-License-Identifier: MIT
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Burnable.sol"; 

pragma solidity ^0.8.0;

contract nftVault{
    
    address public nft_contract_address; 
    uint256 public nft_tokenID;
    uint256 min_time = 60 * 1 days;
    uint256 public creation_time;
    address creator;

    constructor(address _nft_contract_address, uint256 _nft_tokenID){
        nft_contract_address = _nft_contract_address;
        nft_tokenID = _nft_tokenID;
        creation_time = block.timestamp;
        creator = msg.sender;
    }

    fallback() external payable{}
    receive() external payable{}

    function vault_claim(address payable recipient) external payable{
        
        require(msg.sender == creator, "You can't call this function as it can only be called from KeyProtocol contract");
        require(address(this).balance > 0, "Vault is empty");
        require(block.timestamp - creation_time >= min_time, "The vault can only be accessed after two months from date of creation");
        uint amount = address(this).balance;
        (bool success, )  = recipient.call{value:amount}("");
        require(success,"Transaction Failed");
    }

    function getCreator() public view returns(address){
        return creator;
    }
}

contract KeyProtocol{

    uint256 private i=0;

    nftVault[] public _nftvaults;

    event VaultCreated(
        uint date,
        address vault_addr,
        address nft_addr
    );

    mapping(address=> uint) public tracker;

    function createVault(address nftcontract_addr, uint256 _nft_tokenid) public{
        nftVault vault = new nftVault(nftcontract_addr, _nft_tokenid);
        _nftvaults.push(vault);
        i++;
        emit VaultCreated(block.timestamp,address(vault),nftcontract_addr);
        tracker[nftcontract_addr] = i;
    }

    function deposit(address payable vault_contract_address) payable public{
        uint amount = msg.value;
        (bool success, )  = vault_contract_address.call{value:amount}("");
        require(success,"Transaction Failed");
    }

    function claim(address payable vault_contract_addr, 
                   address nft_cont_address, 
                   uint _token_ID) public {
        address insuree = return_ownerAddress(nft_cont_address, _token_ID);
        require(insuree == msg.sender, "You don't have permission.");
        require(burnToken(nft_cont_address, _token_ID), "Your claim was not successful.");
        address payable recipient = payable(msg.sender);
        nftVault vault = nftVault(vault_contract_addr);
        vault.vault_claim(recipient);
    }

    function return_ownerAddress(address nft_cont_address, uint _tokenID) public view returns(address){
        ERC721 instant = ERC721(nft_cont_address);
        return instant.ownerOf(_tokenID);
    }

    function burnToken(address _nft_cont_address,uint256 _tokenId) internal returns(bool){
        ERC721Burnable tokenContract = ERC721Burnable(_nft_cont_address);
        // check if the token exists
        // check if the contract is approved to burn the token
        require(tokenContract.getApproved(_tokenId) == address(this), "Contract not approved to burn token");
        // burn the token
        tokenContract.burn(_tokenId);
        return true;
    }
}
