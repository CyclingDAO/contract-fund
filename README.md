# CyclingDAO Fund

[白皮书](./whitepaper.md)

## Deploy Address

### Mainnet

CyclingFund: [0x203D290196081738efAF988801ea85b47184e1a4](https://etherscan.io/address/0x203D290196081738efAF988801ea85b47184e1a4)

### Kovan

CyclingFund: [0xE3c02E78BbD3CDc7A2850bB19721f3D8D2aE48Ce](https://kovan.etherscan.io/address/0xE3c02E78BbD3CDc7A2850bB19721f3D8D2aE48Ce)

## Development

### Install

```
git clone https://github.com/CyclingDAO/contract-fund.git
cd contract-fund
npm install -g truffle@5.0.40
npm install
```

### Test

```
truffle test
```

### Deploy

deploy to kovan network

```
truffle deploy --network kovan
```

### Scripts

use scripts operator contract

```
truffle exec --network kovan ./scripts/startActivity.js
```
