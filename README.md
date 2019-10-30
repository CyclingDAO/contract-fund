# CyclingDAO Fund

[白皮书](./whitepaper.md)

## Deploy Address

### Mainnet

CyclingFund: TBD

### Kovan

CyclingFund: [0xfA636f22a75b5bAffbE4EE9D00674981511A618d](https://etherscan.io/address/0xfA636f22a75b5bAffbE4EE9D00674981511A618d)

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
