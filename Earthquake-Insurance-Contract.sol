// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EarthquakeInsurance {
    address public owner;
    uint256 public premium;
    uint256 private payoutAmount;

    struct Insurance {
        address insured;
        uint256 amount;
        bool active;
    }

    mapping(address => Insurance) public insurances;

    event InsurancePurchased(address indexed insured, uint256 amount);
    event PayoutProcessed(address indexed insured, uint256 amount);

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

        address payable insuredPayable = payable(insured);
        insuredPayable.transfer(payoutAmount);
        insurance.active = false;

        emit PayoutProcessed(insured, payoutAmount);
    }

    function withdraw() public {
        require(msg.sender == owner);
        address payable ownerPayable = payable(owner);
        ownerPayable.transfer(address(this).balance);
    }
}
