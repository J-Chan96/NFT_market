import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalCloseButton,
  ModalFooter,
  Button,
  ModalBody,
  Text,
} from "@chakra-ui/react";
import { FC, useEffect } from "react";
import useAccount from "../hooks/useAccounts";
import useWeb3 from "../hooks/useWeb3";
import TokenData from "../interface/tokendata.interface";
import { useMetaData } from "../hooks/useMetaData";
import TokenCard from "./TokenCard";

interface MingtingModalProps {
  isOpen: boolean;
  onClose: () => void;
  getRemain: () => Promise<void>;
  getTokenTable: () => Promise<void>;
}

const MintingModal: FC<MingtingModalProps> = ({
  isOpen,
  onClose,
  getRemain,
  getTokenTable,
}) => {
  const { account } = useAccount();
  const { web3, ChanToken, saleToken } = useWeb3();
  const { metadata, getMetadata } = useMetaData();

  const handleClick = async () => {
    try {
      if (!account || !web3 || !ChanToken || !saleToken) return;

      const response = await ChanToken.methods.mintToken().send({
        from: account,
        value: web3.utils.toWei("1", "ether"),
      });

      console.log(response);

      if (response.status) {
        // 내가 민팅한 내역을 볼수있게 해줘야함 => 내가 가지고 있는 토큰 중에 최신토큰을 나타내게 해야함
        const latestToken: TokenData = await saleToken.methods
          .getlatestToken(account)
          .call();

        //  https://gateway.pinata.cloud/ipfs/QmPwjnvWYN4etA5eW4yAbWCTy2ukEC1Jj5417VLGyH5XpU/1/1.json
        const tokenURI: string = await ChanToken.methods
          .tokenURI(latestToken.tokenId)
          .call();

        getMetadata(tokenURI);
        getRemain();
        getTokenTable();
      }
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    if (!metadata) return;
  });

  return (
    <>
      <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Minting</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            {metadata ? (
              <TokenCard metadata={metadata} />
            ) : (
              <Text>민팅시 1 Eth가 소모됩니다.</Text>
            )}
          </ModalBody>

          <ModalFooter>
            <Button mr={3} colorScheme="green" onClick={handleClick}>
              민팅
            </Button>
            <Button colorScheme="blue" mr={3} onClick={onClose}>
              Close
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </>
  );
};

export default MintingModal;
