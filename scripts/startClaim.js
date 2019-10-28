module.exports = () => {
  async function run() {
    const networkId = await web3.eth.net.getId();
    const params = require('./_params')(networkId);

    const fund = await artifacts.require('Fund').deployed();

    await fund.startClaim();
  }

  run().then(() => {
    process.exit();
  }).catch(e => {
    console.log(e);
    process.exit();
  });
}
