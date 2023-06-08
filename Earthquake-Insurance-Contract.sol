Aşağıdaki kod, "EarthquakeInsurance" adlı akıllı sözleşmeyi, bireylerin 1 ETH'lik sigorta kapsamı satın alabildiği ve sözleşme sahibinin deprem etkilenen sigortalılara 100 ETH tutarında ödeme yapabileceği şekilde güncellemektedir. Sözleşme olayları, satın alımları ve ödemeleri kaydetmek için kullanılırken, erişim kontrolleri ve ödenebilir adresler güvenlik ve şeffaflığı sağlar.

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EarthquakeInsurance {
    address public owner; //make owner public for visibility
    uint public premium; //make premium public for visibility
    uint private payoutAmount; 

    struct Insurance {
        address insured;
        uint amount;
        bool active;
    }
    
    mapping(address => Insurance) public insurances;
    
    event InsurancePurchased(address indexed insured, uint amount);
    event PayoutProcessed(address indexed insured, uint amount);
    
    constructor() { 
        owner = msg.sender;
        premium = 1 ether;
        payoutAmount = 100 ether;
    }
    
    function buyInsurance() public payable {
        require(msg.value == premium); 
        insurances[msg.sender] = Insurance(msg.sender, msg.value, true);
        emit InsurancePurchased(msg.sender, msg.value);
    }
    
    function processPayout(address insured) public {
        require(msg.sender == owner); 
        Insurance storage insurance = insurances[insured];
        require(insurance.active); 
        address payable insuredPayable = payable(insured); //cast insured to address payable
        insuredPayable.transfer(payoutAmount);
        insurance.active = false;
        emit PayoutProcessed(insured, payoutAmount);
    }
    
    function withdraw() public {
        require(msg.sender == owner);
        address payable ownerPayable = payable(owner); //cast owner to address payable
        ownerPayable.transfer(address(this).balance);
    } 
}
```
