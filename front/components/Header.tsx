import { Box, Button, Flex } from "@chakra-ui/react";
import Link from "next/link";
import React from "react";
import { FC, ReactNode } from "react";
import useAccount from "../hooks/useAccounts";

const Header: FC = () => {
  const { account } = useAccount();
  return (
    <Flex
      position="fixed"
      w="full"
      bg="white"
      justifyContent="space-between"
      px="12"
      py="2"
    >
      <Box>Logo</Box>
      <Box>
        <Link href="/">
          <Button size="sm" variant="ghost">
            Home
          </Button>
        </Link>
        <Link href="/mypage">
          <Button size="sm" variant="ghost">
            나의 NFT
          </Button>
        </Link>
      </Box>
      <Box>{account}</Box>
    </Flex>
  );
};

export default Header;
