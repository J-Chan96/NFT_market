const ChanToken = artifacts.require("ChanToken");
const SaleToken = artifacts.require("SaleToken");

module.exports = async (deployer) => {
  await deployer.deploy(ChanToken, "test", "test", "http://localhost:3500");
  const ChanTokenInstance = await ChanToken.deployed();

  await deployer.deploy(SaleToken, ChanTokenInstance.address);
};
