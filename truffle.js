require("dotenv").config();

var HDWalletProvider = require("truffle-hdwallet-provider");

const providerWithMnemonic = (mnemonic, rpcEndpoint) =>
  new HDWalletProvider(mnemonic, rpcEndpoint);

const infuraProvider = network =>
  providerWithMnemonic(
    process.env.MNEMONIC || "",
    `https://${network}.infura.io/v3/${process.env.INFURA_API_KEY}`
  );

module.exports = {
  networks: {
    mainnet: {
      provider: infuraProvider("mainnet"),
      network_id: 1
    },
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    ropsten: {
      provider: infuraProvider("ropsten"),
      network_id: 3
    },
    rinkeby: {
      provider: infuraProvider("rinkeby"),
      network_id: 4
    },
    kovan: {
      provider: infuraProvider("kovan"),
      network_id: 42
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
