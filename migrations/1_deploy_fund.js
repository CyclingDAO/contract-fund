const Fund = artifacts.require("Fund");

module.exports = function(deployer) {
  deployer.deploy(Fund);
};
