/* global artifacts, contract, it, assert */
var TestToken = artifacts.require('./token/TestToken.sol')

contract('TestToken', (accounts) => {
  // A Sample Test
  it('should deploy', () => {
    return TestToken.deployed()
    .then((instance) => {
      assert.notEqual(instance, null, 'Instance should not be null')
    })
  })
})
