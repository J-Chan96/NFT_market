# NFT 민팅

- mint
  NFT 생성해주는 친구
  오픈제플린 활용

1. 이더를 주면서 NFT를 발급받기
   : Account1 -> Smart Contract에게 적절한 ETH를 주고 Account1에게 NFT를 주는 행위

2. NFT를 받을 때 사진 혹 내용이 랜덤으로 줌

3. Account들끼리 구매 판매 할 수 있는 Contract

```
contracts 디렉토리 안에 들어가서
npm init

npm install openzeppelin-solidity
```

# tokenURI

우리는 opensea를 통해서 우리가 배포한 NFT를 확인할 수 있었다. tokenURI 반환값을 실제 작동될 수 있는 메타데이터(json)를 넣으니 NFT에 이미지가 생긴 것을 확인할 수 있었다.

contracts
remixd -s . --remix-ide https://remix.ethereum.org

# Front Next / TypeScript

npx create-next-app@latest --typescript front

## chakra-ui

https://chakra-ui.com

```front
위에 링크에 들어가서 next.js를 클릭하면 installation에 있는 명령어를 복사해서 설치
npm i @chakra-ui/react @emotion/react@^11 @emotion/styled@^11 framer-motion@^6
```

pages/\_app.tsx 이게 먼저 실행이 되고 아래가 실행됨

pages/index.tsx
pages/board.tsx => http://localhost:3000/board
pages/list.tsx => http://localhost:3000/list

- chakra 사용방법
  \_app.tsx에 들어가서
  Component에 <ChakraProvider>로 감싼다.

## window.ethereum

npm install @metamask/providers

# next-env.d.ts

```typescript
import { MetaMaskInpageProvider } from "@metamask/providers";

declare global {
  interface Window {
    ethereum?: MetaMaskInpageProvider;
  }
}
```

acc
0x5DEBBd50Eb024849129Cc7e62Ac4eA8906f029b2
0x6D36a3D82Ae8Bd49BAb6868bb9094Ae4c4B5f473
0xf4D2CED7fA1d98bc144De4B2c0c1cAFB6E02ca1B

priv
0x25e3d6aaf7d33c4cef45646b36f0767db6a07105a3d05f91beac083866261b66
0xeabc6598a2a9aeaff6d46d28107ef244899ab6cb95557ddd5eb988ea901d2d86
0xc0e6675ded93e9c58b3deeba458fc59f7061540175c19ef283bb4a26220363f4
