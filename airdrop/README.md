# Airdrop Smart Contract

A Clarity smart contract for managing token airdrops with features for whitelist management, NFT-based eligibility, and batch distribution capabilities.

## Features

- Whitelist management for eligible addresses
- NFT-based eligibility verification
- Individual token allocation management
- Batch airdrop functionality
- Claim functionality with various safety checks
- Toggle mechanism for enabling/disabling claims
- Comprehensive error handling

## Contract Constants

| Constant | Description | Error Code |
|----------|-------------|------------|
| err-owner-only | Only contract owner can perform this action | u100 |
| err-already-claimed | Address has already claimed tokens | u101 |
| err-not-eligible | Address is not eligible for claiming | u102 |
| err-no-allocation | No allocation found for address | u103 |
| err-claim-disabled | Claiming is currently disabled | u104 |
| err-invalid-address | Invalid address provided | u105 |
| err-invalid-amount | Invalid amount specified | u106 |

## Public Functions

### Whitelist Management

```clarity
(add-to-whitelist (address principal))
```
- Adds an address to the whitelist
- Only callable by contract owner
- Returns: (ok true) on success

```clarity
(remove-from-whitelist (address principal))
```
- Removes an address from the whitelist
- Only callable by contract owner
- Returns: (ok true) on success

### NFT Eligibility

```clarity
(set-nft-eligibility (address principal) (eligible bool))
```
- Sets NFT-based eligibility for an address
- Only callable by contract owner
- Returns: (ok true) on success

### Token Allocation

```clarity
(set-allocation (address principal) (amount uint))
```
- Sets token allocation for a specific address
- Only callable by contract owner
- Amount must be greater than 0 and less than total tokens
- Returns: (ok true) on success

### Claiming

```clarity
(claim)
```
- Allows eligible addresses to claim their allocated tokens
- Requires:
  - Claiming must be enabled
  - Address must be eligible (whitelisted and NFT eligible)
  - Address must not have claimed before
- Returns: (ok allocation) on success

### Batch Operations

```clarity
(batch-airdrop (addresses (list 200 principal)) (amounts (list 200 uint)))
```
- Performs batch airdrop to multiple addresses
- Only callable by contract owner
- Maximum 200 addresses per batch
- All amounts must be greater than 0
- Returns: (ok true) on success

### Administrative Functions

```clarity
(toggle-claim)
```
- Toggles the claim status (enable/disable)
- Only callable by contract owner
- Returns: (ok true) on success

## Read-Only Functions

```clarity
(get-allocation (address principal))
```
- Returns the allocation amount for an address
- Returns: uint

```clarity
(is-claimed (address principal))
```
- Checks if an address has claimed their tokens
- Returns: bool

```clarity
(check-eligibility (address principal))
```
- Checks if an address is eligible for claiming
- Returns: bool

```clarity
(get-claim-status)
```
- Returns the current claim status
- Returns: bool

```clarity
(get-total-tokens)
```
- Returns the total token amount configured
- Returns: uint

## Implementation Notes

1. The contract uses a combination of whitelist and NFT-based eligibility for determining claim eligibility
2. Token transfer logic needs to be implemented based on the specific token contract being used
3. Batch operations are limited to 200 addresses per transaction
4. The contract includes safety checks to prevent:
   - Double claiming
   - Unauthorized access
   - Invalid allocations
   - Claims when disabled

## Security Considerations

1. Only the contract owner can:
   - Manage whitelist
   - Set NFT eligibility
   - Set token allocations
   - Perform batch airdrops
   - Toggle claim status

2. Built-in protections:
   - Prevention of double claims
   - Validation of addresses and amounts
   - Eligibility verification
   - Contract owner cannot be added to whitelist

## Getting Started

1. Deploy the contract
2. Configure whitelist using `add-to-whitelist`
3. Set NFT eligibility using `set-nft-eligibility`
4. Set token allocations using `set-allocation`
5. Enable claims using `toggle-claim`
6. Users can claim tokens using `claim`

## Development

To modify this contract:
1. Ensure you have a Clarity development environment set up
2. Test thoroughly before deployment
3. Consider gas costs when performing batch operations
4. Implement appropriate token transfer logic
