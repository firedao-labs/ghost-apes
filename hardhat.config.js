require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");

require("dotenv").config();

module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
        },
        localhost: {
            url: "http://127.0.0.1:8545"
        },
        polygon: {
            url: "https://polygon-rpc.com/",
            chainId: 137,
            accounts: { mnemonic: process.env.MNEMONIC }
        },
        mumbai: {
            url: "https://rpc-mumbai.matic.today",
            chainId: 80001,
            accounts: { mnemonic: process.env.MNEMONIC }
        }
    },
    etherscan: {
        apiKey: {
            polygon: "",
            polygonMumbai: ""
        }
    },
    solidity: {
        version: "0.8.12",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
};
