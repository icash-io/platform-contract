pragma solidity ^0.4.15;
import "zeppelin-solidity/contracts/token/StandardToken.sol";

// Simple Token Contract
contract TestToken is StandardToken {
    // Public variables
    string constant public name = "Test Token"; 
    string constant public symbol = "TST";
    uint constant public decimals = 18;
    
    // Constants for creating 100 million tokens
    uint constant MILLION = 10 ** 6;
    uint constant BASE_UNITS = 10 ** decimals;    
    uint constant INITIAL_SUPPLY = 100 * MILLION * BASE_UNITS;

    // Initialize the token and set the account that created this contract as the owner of all tokens.
    function TestToken() {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}