const kovan = {
  network: "kovan",
  activityID: 201911,
  reward: '1', // ETH
  kms: [5910, 66, 1092, 1170, 112, 122, 1],
  memberAddrs: [
    "0xDc19464589c1cfdD10AEdcC1d09336622b282652", // outprog
    "0x82ee9EFc6d35FbFa0342FA00C0dd12b39Ab528bA", // haibin
    "0xbf85870b162B2A25a17d68e66eaC31a82F459B36", // Yiqun
    "0x670AB48968A5dA83221beBDd04667E603d0dFF5f", // Weli
    "0x006016cED2484bdc1E78bbdC0Ca95fA021cA5ba6", // 郭涛，童在！
    "0xE5B8988C90Ca60D5f2A913cb3BD35A781aE7F242", // Simon
    "0x865eADB12Bf29CD141A0De88FD29716e2c169a86", // longhai
  ],
  memberNames: [
    "outprog",
    "haibin",
    "Yiqun",
    "Weli",
    "郭涛，童在！",
    "Simon",
    "longhai",
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

