// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./ChanToken.sol";

contract SaleToken {
    ChanToken public Token;

    constructor(address _tokenAddress){
        Token = ChanToken(_tokenAddress);
    }

    struct TokenInfo {
        uint tokenId;
        uint Rank;
        uint Type;
        uint price;
    }

    // 토큰 가격 맵핑
    mapping(uint => uint) public tokenPrices; 
    // 판매 토큰 배열
    uint[] public SaleTokenList;

    //판매등록   함수 인자값 : 내가 팔 토큰, 토큰가격
    function SalesToken(uint _tokenId, uint _price) public {
        address tokenOwner = Token.ownerOf(_tokenId); // 토큰 아이디의 소유자

        require(tokenOwner == msg.sender);
        require(_price > 0);
        // Opensea isapprovedForAll : 이 CA(contract address)가 token Owner의 대리인인가를 확인하는 검증을 해야함
        require(Token.isApprovedForAll(msg.sender, address(this)), "Error: 1231312");

        tokenPrices[_tokenId] = _price;
        SaleTokenList.push(_tokenId);
    }

    // 구매 구매자 -> CA -> 판매자  해석: 구매자는 CA에게 tokenId를 사면서 돈을 주고 CA는 돈을 받은 것을 판매자에게 준다.
    function PurchaseToken(uint _tokenId) public payable {
        address tokenOwner = Token.ownerOf(_tokenId);
        require(tokenOwner != msg.sender);
        require(tokenPrices[_tokenId] > 0); // 가격이 있어야지만 판매중인 tokenId라는 것을 확인하기 위해
        require(tokenPrices[_tokenId] <= msg.value);

        payable(tokenOwner).transfer(msg.value);

        // 실행하는 판매 컨트랙트 CA가 실행하는 것
        Token.transferFrom(tokenOwner, msg.sender, _tokenId);
        tokenPrices[_tokenId] = 0;
        popSaleToken(_tokenId);
    }
    
    function cancelSaleToken(uint _tokenId) public {
        address tokenOwner = Token.ownerOf(_tokenId);
        require(tokenOwner == msg.sender);
        require(tokenPrices[_tokenId] > 0);

        tokenPrices[_tokenId] = 0;
        popSaleToken(_tokenId);
    }


    function popSaleToken(uint _tokenId) private returns(bool){
        for(uint i = 0; i < SaleTokenList.length; i++){
            if (SaleTokenList[i] == _tokenId) {
                // i == tokenId의 인덱스값
                SaleTokenList[i] = SaleTokenList[SaleTokenList.length -1];
                SaleTokenList.pop();
                return true; 
            }
        }
        return false;
    }

    // 전체 판매리스트 view 함수
    function getSaleTokenList() public view returns(TokenInfo[] memory) {
        require(SaleTokenList.length > 0);

        TokenInfo[] memory list = new TokenInfo[](SaleTokenList.length);
        // new Array(SaleToken.length)

        for(uint i = 0; i < SaleTokenList.length; i++){
            uint tokenId = SaleTokenList[i];
            uint Rank = Token.getTokenRank(tokenId);
            uint Type = Token.getTokenType(tokenId);
            uint price = tokenPrices[tokenId];
            list[i] = TokenInfo(tokenId, Rank, Type, price);
        }
        return list;
    }

    // 내가 소유하고있는 토큰 리스트
    function getOwnerTokens(address _tokenOwner) public view returns(TokenInfo[] memory) {
        // tokenOfOwnerByIndex
        // balanceOf

        uint balance = Token.balanceOf(_tokenOwner);
        require(balance != 0);

        TokenInfo[] memory list = new TokenInfo[](balance);

        for(uint i = 0; i < balance; i++){
            uint tokenId = Token.tokenOfOwnerByIndex(_tokenOwner, i);
            uint Rank = Token.getTokenRank(tokenId);
            uint Type = Token.getTokenType(tokenId);
            uint price = tokenPrices[tokenId];

            list[i] = TokenInfo(tokenId, Rank, Type, price);
        }
        return list;
    }

    // 내가 소유하고있는 토큰 리스트

    // 내가 소유하고있는 마지막 토큰
    function getlatestToken(address _tokenOwner) public view returns(TokenInfo memory) {
        uint balance = Token.balanceOf(_tokenOwner);
        uint tokenId = Token.tokenOfOwnerByIndex(_tokenOwner, balance-1);
        uint Rank = Token.getTokenRank(tokenId);
        uint Type = Token.getTokenType(tokenId);
        uint price = tokenPrices[tokenId];

        return TokenInfo(tokenId, Rank, Type, price);

    }
}