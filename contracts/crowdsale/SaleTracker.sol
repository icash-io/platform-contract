pragma solidity ^0.4.15;
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
/*
 This is a simple contract that is used to track incoming payments.
 As soon as a payment is received, an event is triggered to log the transaction.
 All funds are immediately forwarded to the owner.
 The sender must include a payment code as a payload and the contract can conditionally enforce the
 sending address matches the payment code.
 The payment code is the first 8 bytes of the keccak/sha3 hash of the address that the user has specified in the sale.
*/
contract SaleTracker is Pausable {
  using SafeMath for uint256;

  // Event to allow monitoring incoming payments
  event PurchaseMade (address indexed _from, bytes8 _paymentCode, uint256 _value);

  // Tracking of purchase total in wei made per sending address
  mapping(address => uint256) public purchases;

  // Tracking of purchaser addresses for lookup offline
  address[] public purchaserAddresses;

  // Flag to enforce payments source address matching the payment code
  bool public enforceAddressMatch;

  // Constructor to start the contract in a paused state
  function SaleTracker(bool _enforceAddressMatch) {
    enforceAddressMatch = _enforceAddressMatch;
    pause();
  }

  // Setter for the enforce flag - only updatable by the owner
  function setEnforceAddressMatch(bool _enforceAddressMatch) onlyOwner public {
    enforceAddressMatch = _enforceAddressMatch;
  }

  // Purchase function allows incoming payments when not paused - requires payment code
  function purchase(bytes8 paymentCode) whenNotPaused public payable {

    // Verify they have sent ETH in
    require(msg.value != 0);

    // Verify the payment code was included
    require(paymentCode != 0);

    // If payment from addresses are being enforced, ensure the code matches the sender address
    if (enforceAddressMatch) {

      // Get the first 8 bytes of the hash of the address
      bytes8 calculatedPaymentCode = bytes8(sha3(msg.sender));

      // Fail if the sender code does not match
      require(calculatedPaymentCode == paymentCode);
    }

    // Save off the existing purchase amount for this user
    uint256 existingPurchaseAmount = purchases[msg.sender];

    // If they have not purchased before (0 value), then save it off
    if (existingPurchaseAmount == 0) {
      purchaserAddresses.push(msg.sender);
    }

    // Add the new purchase value to the existing value already being tracked
    purchases[msg.sender] = existingPurchaseAmount.add(msg.value);    

    // Transfer out to the owner wallet
    owner.transfer(msg.value);

    // Trigger the event for a new purchase
    PurchaseMade(msg.sender, paymentCode, msg.value);
  }

  // Allows owner to sweep any ETH somehow trapped in the contract.
  function sweep() onlyOwner public {
    owner.transfer(this.balance);
  }

  // Get the number of addresses that have contributed to the sale
  function getPurchaserAddressCount() public constant returns (uint) {
    return purchaserAddresses.length;
  }

}
