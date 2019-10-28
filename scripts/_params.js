const kovan = {
  network: "kovan",
  memberAddrs: [
    "0xa06b79e655db7d7c3b3e7b2cceeb068c3259d0c9", // outprog
    "0xab6c371B6c466BcF14d4003601951e5873dF2AcA", // xiaoliu
    "0xc9a0554956B0F41c378975892FEF4Cff7158e807", // xiaopang
  ],
  memberNames: [
    "outprog",
    "xiaoliu",
    "xiaopang",
  ],
};

module.exports = function (networkId) {
  if (networkId == 42) {
    return kovan;
  }

  // if (networkId == 1 ) {
  //   return mainnet;
  // }
}

