/* global artifacts */
var TestToken = artifacts.require('./token/TestToken.sol')

module.exports = function (deployer) {
  deployer.deploy(TestToken)
}
