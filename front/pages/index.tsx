import {
  Box,
  Button,
  Flex,
  useDisclosure,
  Text,
  TableContainer,
  Table,
  Thead,
  Tr,
  Td,
  Tbody,
} from "@chakra-ui/react";
import MintingModal from "../components/MintingModal";
import type { NextPage } from "next";
import useAccount from "../hooks/useAccounts";
import useWeb3 from "../hooks/useWeb3";
import { useEffect, useState } from "react";

const Home: NextPage = () => {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { account } = useAccount();
  const { web3, ChanToken, saleToken } = useWeb3();

  const [remain, setRemain] = useState<number>(0);
  const [tokenTable, setTokenTable] = useState<string[][] | undefined>(
    undefined
  );

  const getTokenTable = async () => {
    try {
      if (!ChanToken) return;

      const response = await ChanToken.methods.getTokenCount().call();
      console.log(response);
      setTokenTable(response);
    } catch (e) {
      console.error(e);
    }
  };

  const getRemain = async () => {
    try {
      if (!ChanToken) return;

      await ChanToken?.methods.totalSupply().call();
      await ChanToken.methods.MAX_TOKEN_COUNT().call();

      const [totalsupply, MAX_TOKEN_COUNT] = await Promise.all([
        ChanToken.methods.totalSupply().call(), // 4초
        ChanToken.methods.MAX_TOKEN_COUNT().call(), // 5초
      ]);
      // 위에 2개가 총 걸리는 시간 5초

      setRemain(parseInt(MAX_TOKEN_COUNT) - parseInt(totalsupply));
    } catch (e) {
      console.error(e);
    }
  };

  useEffect(() => {
    console.log(account);
    console.log(web3);
    console.log(ChanToken);
    console.log(saleToken);
    getRemain();
    getTokenTable();
  }, [ChanToken]);
  return (
    <>
      <Flex
        bg="red.100"
        minH="100vh"
        justifyContent="center"
        alignItems="center"
        direction="column"
      >
        <TableContainer>
          <Table>
            <Thead>
              <Tr>
                <Td>Rank/Type</Td>
                <Td>1</Td>
                <Td>2</Td>
                <Td>3</Td>
                <Td>4</Td>
              </Tr>
            </Thead>
            <Tbody>
              {/*
                [
                  [1,2,3,5],
                  [52,2,3,4],
                  [4,1,2,3],
                  [23,1,23,5]
                ]
                */}
              {tokenTable?.map((v, i) => {
                return (
                  <>
                    <Tr>
                      <Td key={i}>{i + 1}</Td>
                      {v.map((j, w) => {
                        return <Td key={w}>{j}</Td>;
                      })}
                    </Tr>
                  </>
                );
              })}
            </Tbody>
          </Table>
        </TableContainer>
        <Text mb={4}>남은 NFR 갯수 : {remain}</Text>
        <Button colorScheme="blue" onClick={onOpen}>
          민팅하기
        </Button>
      </Flex>
      <MintingModal
        isOpen={isOpen}
        onClose={onClose}
        getRemain={getRemain}
        getTokenTable={getTokenTable}
      />
    </>
  );
};

export default Home;
