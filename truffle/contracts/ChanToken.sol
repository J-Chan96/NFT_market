// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "./node_modules/openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";
import "./node_modules/openzeppelin-solidity/contracts/utils/Strings.sol";

contract ChanToken is ERC721Enumerable, Ownable {
    uint constant public MAX_TOKEN_COUNT = 1000;
    uint public mint_price = 1 ether;
    string public metadataURI;
    // 6 1000000000000
    // 0x7E421117F214658D1ba4F3c8DE34ACa085876b70 판매 컨트랜트 CA
    // 0xCA0Ee2E43C1BE189BE076AF777C44E6633746473 ChanToken CA
    // https://gateway.pinata.cloud/ipfs/QmUsEKtVS5Gn4rZWbYfD7D4qLLKPf1YbsBWYaSqtmCPBzf

    constructor(string memory _name, string memory _symbol, string memory _metadataURI) ERC721(_name, _symbol){
        metadataURI = _metadataURI;
    }

    struct TokenData {
        uint Rank;
        uint Type;
    }

    mapping(uint => TokenData) public TokenDatas; // uint -> tokenId
    uint[4][4] public tokenCount;

    function mintToken() public payable {// 함수를 새로 정의
        require(msg.value >= mint_price);
        require(MAX_TOKEN_COUNT > totalSupply());

        uint tokenId = totalSupply() + 1;
        // tokenId가 만들어질때 Rank, type이 지정이 되야한다.

        TokenDatas[tokenId] = getRandomNum(msg.sender, tokenId);
        tokenCount[TokenDatas[tokenId].Rank-1][TokenDatas[tokenId].Type-1] += 1;
    
        payable(Ownable.owner()).transfer(msg.value); // 컨트랙트를 배포한 owner를 나타냄
        _mint(msg.sender, tokenId);
    } 

    function tokenURI(uint _tokenId) public override view returns(string memory) {
        // tokenId를 가져올 때 rank, type을 가져와서 url을 return 해줘야한다.
        // return http://localhost:3000/metadata/1/4.json
        // ipfs : 파일을 블록체인에 저장하는 것 -> 피나타
        // uint Rank = TokenDatas[_tokenId].Rank;
        // uint Type = TokenDatas[_tokenId].Type;
        string memory Rank = Strings.toString(TokenDatas[_tokenId].Rank);
        string memory Type = Strings.toString(TokenDatas[_tokenId].Type);
        // return "http://localhost:3000/medatdata/"+Rank+"/"+Type+".json"; // 여기서 확인할점. Rank,Type은 uint이기 때문에 string 형식으로 불가능
                                                                         // 그래서 return에 저런식으로 스트링 형식이 안됨. 그래서 이놈을 바이트형식으로 바꾸고 string으로 변환을 해야함
                                                                         // 이러한 방식을 위한 라이브러리가 존재함 Strings.sol
        return string(abi.encodePacked(metadataURI,"/",Rank,"/",Type,".json"));
    }

    function getRandomNum(address _owner, uint _tokenId) private pure returns(TokenData memory ) {
        // Random
        // abi.encodePacked(_owner, tokenId); -> 타입과 상관없이 합쳐주는 method _owner와 tokenId는 서로 타입이 다르다. 그래서 합치질 못했는데
        // abi.encodePacked()을 사용하면 타입과 상관없이 합칠 수 있음
        uint randomNum = uint(keccak256(abi.encodePacked(_owner, _tokenId)))%100; // 16진수 내용으로 32byte로 뽑아냄 여기서 우리는 끝자리에서 2자리 숫자만 가져오고싶음

        TokenData memory data; // memory를 쓰는 것은 블록체인에 들어가는 내용이 아닌 임시적으로 사용하겠다는 의미이다.
        /**
        {
            Rank:uint,
            Type:uint
        }
        
         */

         if (randomNum < 5) {
            if (randomNum == 1) {
                data.Rank = 4;
                data.Type = 1;
            } else if (randomNum == 2) {
                data.Rank = 4;
                data.Type = 2;
            } else if (randomNum == 3) {
                data.Rank = 4;
                data.Type = 3;
            } else {
                data.Rank = 4;
                data.Type = 4;
            }
        } else if (randomNum < 13) {
            if (randomNum < 7) {
                data.Rank = 3;
                data.Type = 1;
            } else if (randomNum < 9) {
                data.Rank = 3;
                data.Type = 2;
            } else if (randomNum < 11) {
                data.Rank = 3;
                data.Type = 3;
            } else {
                data.Rank = 3;
                data.Type = 4;
            }
        } else if (randomNum < 37) {
            if (randomNum < 19) {
                data.Rank = 2;
                data.Type = 1;
            } else if (randomNum < 25) {
                data.Rank = 2;
                data.Type = 2;
            } else if (randomNum < 31) {
                data.Rank = 2;
                data.Type = 3;
            } else {
                data.Rank = 2;
                data.Type = 4;
            }
        } else {
            if (randomNum < 52) {
                data.Rank = 1;
                data.Type = 1;
            } else if (randomNum < 68) {
                data.Rank = 1;
                data.Type = 2;
            } else if (randomNum < 84) {
                data.Rank = 1;
                data.Type = 3;
            } else {
                data.Rank = 1;
                data.Type = 4;
            }
        }
        return data;
    }
    
    function setMetadataURI(string memory _uri) public onlyOwner { // onlyOwner => 배포한 사람만 실행시킬수 있다. 
        metadataURI = _uri;
    }

    function getTokenRank(uint _tokenId) public view returns(uint) {
        return TokenDatas[_tokenId].Rank;
    }

    function getTokenType(uint _tokenId) public view returns(uint) {
        return TokenDatas[_tokenId].Type;
    }

    function getTokenCount() public view returns(uint[4][4] memory) {
        return tokenCount;
    }

}