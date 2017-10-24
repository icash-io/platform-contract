/* global artifacts */
var SaleTracker = artifacts.require('./crowdsale/SaleTracker.sol')

module.exports = function (deployer) {
  deployer.deploy(SaleTracker, false)
}
