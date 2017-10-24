/* global artifacts */
var MultiSigWallet = artifacts.require('./multisig/MultiSigWallet.sol')

module.exports = function (deployer, network, accounts) {
  deployer.deploy(MultiSigWallet, [accounts[0], accounts[1], accounts[2]], 2)
}
