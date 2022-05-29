// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract GhostApe is Ownable, ERC721, ERC721Enumerable, ERC721Royalty, EIP712, ERC721Votes {
    string private _baseTokenURI;

    address payable public payee;

    uint256 public maxSupply = 2000;
    uint256 public price = 500 ether;

    event BaseURIUpdated(string previousValue, string value);

    event PayeeUpdated(address previousValue, address value);

    event MaxSupplyUpdated(uint256 previousValue, uint256 value);
    event PriceUpdated(uint256 previousValue, uint256 value);

    constructor(address payable payee_) ERC721("Ghost Ape", "GAPE") EIP712("Ghost Ape", "1") {
        require(payee_ != address(0), "GhostApe::constructor: payee cannot be zero address");

        payee = payee_;

        _setDefaultRoyalty(payee_, 1000);
    }

    receive() external payable {
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable, ERC721Royalty) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function setBaseURI(string memory value) external onlyOwner {
        string memory previousValue = _baseTokenURI;
        _baseTokenURI = value;
        emit BaseURIUpdated(previousValue, value);
    }

    function setPayee(address payable value) external onlyOwner {
        address previousValue = payee;
        payee = value;
        emit PayeeUpdated(previousValue, value);
    }

    function setMaxSupply(uint256 value) external onlyOwner {
        uint256 previousValue = maxSupply;
        maxSupply = value;
        emit MaxSupplyUpdated(previousValue, value);
    }

    function setPrice(uint256 value) external onlyOwner {
        uint256 previousValue = price;
        price = value;
        emit PriceUpdated(previousValue, value);
    }

    function setDefaultRoyalty(address recipient, uint96 fraction) external onlyOwner {
        _setDefaultRoyalty(recipient, fraction);
    }

    function deleteDefaultRoyalty() external onlyOwner {
        _deleteDefaultRoyalty();
    }

    function setTokenRoyalty(uint256 tokenId, address recipient, uint96 fraction) external onlyOwner {
        _setTokenRoyalty(tokenId, recipient, fraction);
    }

    function safeMint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }

    function batchMint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "GhostApe::batchMint insufficient supply");

        for(uint256 i = 0; i < amount; i++) {
            _safeMint(to, totalSupply());
        }
    }

    function mint() external payable {
        require(msg.value >= price, "GhostApe::mint: insufficient payment");
        require(totalSupply() < maxSupply, "GhostApe::mint: insufficient supply");

        _safeMint(_msgSender(), totalSupply());

        Address.sendValue(payee, address(this).balance);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Votes) {
        super._afterTokenTransfer(from, to, tokenId);
    }
}