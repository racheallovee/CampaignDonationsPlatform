require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

console.log("WALLET_PRIVATE_KEY:", process.env.WALLET_PRIVATE_KEY);
console.log("ALCHEMY_API_KEY_SEPOLIA:", process.env.ALCHEMY_API_KEY_SEPOLIA);

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY_SEPOLIA}`,
      accounts: [process.env.WALLET_PRIVATE_KEY],
    },
    ethereum: {
      url: `https://eth-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY_MAIN}`,
      accounts: [process.env.WALLET_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.ETHEREUM_SCAN_API_KEY,
    },
  },
};
