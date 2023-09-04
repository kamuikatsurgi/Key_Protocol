// SPDX-License-Identifier: MIT
import {ERC721Burnable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

pragma solidity 0.8.19;

contract Vault{

    error NotAuthorized();
    error NotEnoughBalance();
    error NotEnoughTime();

    uint256 private minTime = 60 * 1 days;    
    uint256 private initTime;
    uint256 private tokenID;
    address private parent;
    address private nftContractAddress;

    constructor(address _nftContractAddress, uint256 _tokenID){
        initTime = block.timestamp;
        tokenID = _tokenID;
        parent = msg.sender;
        nftContractAddress = _nftContractAddress;
    }

    function claim(address payable recipient) external payable{
        if(msg.sender!= parent) revert NotAuthorized();
        if(address(this).balance == 0) revert NotEnoughBalance();
        if(block.timestamp - initTime < minTime) revert NotEnoughTime();
        (bool success, ) = recipient.call{value : address(this).balance}("");
        require(success,"Transaction Failed");
    }

    receive() external payable{}
}

contract KeyProtocol{

    event VaultCreated(uint256 time, address nftContractAddress, address vaultAddress);

    Vault[] private vaults;
    mapping(address => address) vaultToContract;

    function createVault(address nftContractAddress, uint256 tokenID) external{
        Vault vault = new Vault(nftContractAddress, tokenID);
        vaults.push(vault);
        vaultToContract[nftContractAddress] = address(vault);
        emit VaultCreated(block.timestamp, nftContractAddress, address(vault));
    }

    function deposit(address payable vaultAddress) external payable{
        (bool success, )  = vaultAddress.call{ value : msg.value}("");
        require(success,"Transaction Failed!");
    }

    function claim(address nftContractAddress, 
                   uint256 tokenID) external {
        address insuree = returnOwnerAddress(nftContractAddress, tokenID);
        require(insuree == msg.sender);
        require(burnToken(nftContractAddress, tokenID));
        address payable vaultAddress = payable(getVaultAddress(nftContractAddress));
        address payable recipient = payable(msg.sender);
        Vault vault = Vault(vaultAddress);
        vault.claim(recipient);
    }

    function getVaultAddress(address nftContractAddress) public view returns(address){
        return vaultToContract[nftContractAddress];
    }

    function returnOwnerAddress(address nftContractAddress, uint tokenID) internal view returns(address){
        ERC721 token = ERC721(nftContractAddress);
        return token.ownerOf(tokenID);
    }

    function burnToken(address nftContractAddress, uint256 tokenID) internal returns(bool){
        ERC721Burnable token = ERC721Burnable(nftContractAddress);
        require(token.getApproved(tokenID) == address(this), "Contract not approved to burn token");
        token.burn(tokenID);
        return true;
    }
}