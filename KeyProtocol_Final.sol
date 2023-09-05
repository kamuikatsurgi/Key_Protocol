// SPDX-License-Identifier: MIT
import {ERC721Burnable, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

pragma solidity 0.8.19;

contract Vault{

    error NotAuthorized();
    error NotEnoughBalance();
    error NotEnoughTimePassed();

    uint256 private constant minTime = 60 * 1 days;    
    uint256 private immutable initTime;
    uint256 private immutable tokenID;
    address private immutable parent;
    address private immutable nftContractAddress;

    constructor(address _nftContractAddress, uint256 _tokenID){
        initTime = block.timestamp;
        tokenID = _tokenID;
        parent = msg.sender;
        nftContractAddress = _nftContractAddress;
    }

    function claim(address payable recipient) external payable{
        if(msg.sender!= parent) revert NotAuthorized();
        if(address(this).balance == 0) revert NotEnoughBalance();
        if(block.timestamp - initTime < minTime) revert NotEnoughTimePassed();
        (bool success, ) = recipient.call{value: address(this).balance}("");
        require(success,"Transaction Failed");
    }

    receive() external payable{}
}

contract KeyProtocol{

    event VaultCreated(uint256 time, address nftContractAddress, address vaultAddress);
    event Deposited(address vaultAddress, uint256 amount);
    event Claimed(address nftContractAddress, uint256 tokenID, address recipient);

    Vault[] private vaults;
    mapping(address => mapping(uint256 => address)) vaultToNFT;

    function createVault(address nftContractAddress, uint256 tokenID) external{
        Vault vault = new Vault(nftContractAddress, tokenID);
        vaults.push(vault);
        vaultToNFT[nftContractAddress][tokenID] = address(vault);
        emit VaultCreated(block.timestamp, nftContractAddress, address(vault));
    }

    function deposit(address payable vaultAddress) external payable{
        (bool success, )  = vaultAddress.call{value: msg.value}("");
        require(success,"Transaction Failed!");
        emit Deposited(vaultAddress, msg.value);
    }

    function claim(address nftContractAddress, uint256 tokenID) external {
        address owner = _returnOwnerAddress(nftContractAddress, tokenID);
        require(owner == msg.sender);
        require(_burnToken(nftContractAddress, tokenID));
        address payable vaultAddress = payable(getVaultAddress(nftContractAddress, tokenID));
        address payable recipient = payable(msg.sender);
        Vault vault = Vault(vaultAddress);
        vault.claim(recipient);
        emit Claimed(vaultAddress, tokenID, recipient);
    }

    function getVaultAddress(address nftContractAddress, uint256 tokenID) public view returns(address){
        return vaultToNFT[nftContractAddress][tokenID];
    }

    function _returnOwnerAddress(address nftContractAddress, uint tokenID) internal view returns(address){
        ERC721 token = ERC721(nftContractAddress);
        return token.ownerOf(tokenID);
    }

    function _burnToken(address nftContractAddress, uint256 tokenID) internal returns(bool){
        ERC721Burnable token = ERC721Burnable(nftContractAddress);
        require(token.getApproved(tokenID) == address(this), "Contract not approved to burn token");
        token.burn(tokenID);
        return true;
    }
}