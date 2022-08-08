import { useState, useEffect } from "react";
import Web3 from "web3";
import { Contract } from "web3-eth-Contract";
import { AbiItem } from "web3-utils";

const useWeb3 = () => {
  const [web3, setWeb3] = useState<Web3 | undefined>(undefined);
  const [ChanToken, setChanToken] = useState<Contract>();
  const [saleToken, setSaleToken] = useState<Contract>();

  const getWeb3 = () => {
    try {
      if (window.ethereum) {
        setWeb3(new Web3(window.ethereum as any));
      }
    } catch (e) {
      console.error(e);
    }
  };

  const getChanToken = (networkId: number) => {
    if (!web3) return;
    const ChanTokenJSON = require("../contracts/ChanToken.json");
    const abi = ChanTokenJSON.abi;
    const ca = ChanTokenJSON.networks[networkId]?.address;

    const instance = new web3.eth.Contract(abi, ca);
    setChanToken(instance);
  };

  const getSaleToken = (networkId: number) => {
    if (!web3) return;
    const saleTokenJSON = require("../contracts/SaleToken.json");
    const abi: AbiItem = saleTokenJSON.abi;
    const ca: string = saleTokenJSON.networks[networkId]?.address;

    const instance = new web3.eth.Contract(abi, ca);
    setSaleToken(instance);
  };

  useEffect(() => {
    getWeb3();
  }, []);

  useEffect(() => {
    (async () => {
      if (!web3) return;
      const networkId: number = await web3.eth.net.getId();
      getChanToken(networkId);
      getSaleToken(networkId);
    })();
  }, [web3]);

  return {
    web3,
    ChanToken,
    saleToken,
  };
};

export default useWeb3;

// 배포된 스마트컨트랙트 인스턴스를 가져올 때 필요한 인자값이 2개가 있다 ->abi , ca
