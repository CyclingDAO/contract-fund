const Web3 = require('web3')
const web3 = new Web3('')

const HDWalletProvider = require('truffle-hdwallet-provider');

const fs = require('fs');
const prvKey = fs.readFileSync(".secret").toString().trim();

const kovanProvider = new HDWalletProvider(prvKey, `https://kovan.infura.io/`)
const mainnetProvider = new HDWalletProvider(prvKey, `https://mainnet.infura.io/v3/92bbc76799c64b1398c2f2222bd7bf7d`)

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */


  networks: {
    mainnet: {
      provider: mainnetProvider,
      network_id: '1',
      gas: 5000000,
      gasPrice: web3.utils.toWei('10.1', 'gwei'),
      skipDryRun: true,
    },
    kovan: {
      provider: kovanProvider,
      network_id: '42',
      gas: 7000000,
      gasPrice: web3.utils.toWei('1', 'gwei'),
      skipDryRun: true,
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.5.12",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
}
