# Earthquake Insurance Smart Contract

Solidity prototype for a simple earthquake insurance policy flow. Users can buy
coverage by paying a fixed premium, and the contract owner can process payouts
for active policy holders.

## Contract

`Earthquake-Insurance-Contract.sol` defines `EarthquakeInsurance`.

## Policy Flow

1. The deployer becomes the contract owner.
2. A user calls `buyInsurance` and pays the fixed `premium` of `1 ether`.
3. The policy is stored in `insurances`.
4. The owner calls `processPayout(address insured)` when a payout is approved.
5. The policy is marked inactive after payout.

## Main Values

- `premium`: `1 ether`
- `payoutAmount`: `100 ether`

## Safety Checks

- `buyInsurance` requires the exact premium.
- Owner-only functions use the `onlyOwner` modifier.
- Payouts require an active policy.
- Payouts require the contract balance to cover the payout amount.

## Events

- `InsurancePurchased`
- `PayoutProcessed`

## Notes

This is a learning prototype. Insurance logic, funding policy, oracle inputs,
claim verification, and audits would be required before production use.
