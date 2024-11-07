// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT_Contracts is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    constructor() ERC721("NFT_Contracts", "NFT_C") Ownable(msg.sender) {}

    function mintNFT(string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIDs.increment();

        uint256 newItemID = _tokenIDs.current();
        _mint(msg.sender, newItemID);
        _setTokenURI(newItemID, tokenURI);

        return newItemID;
    }

    function approve(address to, uint256 tokenID) public virtual override {
        address owner = ERC721.ownerOf(tokenID);
        //유효성 검사 : operator(to)의 주소와 토큰의 owenr가 동일인인지 확인
        require(to != owner, "ERC721: approval to current owner");
        //유효성 검사 : approve 함수를 호출한 사람과 토큰의 owner가 동일한지 확인
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner nor apporved for all"
        );

        _approve(to, tokenID);
    }

    function _approve(address to, uint256 tokenID) internal virtual {
        //_tokenApprovals 변수에 tokenID와 approve된 operator의 주소와 매핑
        _tokenApprovals[tokenID] = to;
        emit Approval(ERC721.ownerOf(tokenID), to, tokenID);
    }
}