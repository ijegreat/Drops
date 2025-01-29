# Airdrop Smart Contract

A Clarity smart contract for managing token airdrops with NFT-based eligibility and whitelisting functionality.

## Features

- Token allocation management
- Whitelist functionality
- NFT-based eligibility verification
- Batch airdrop capabilities
- Comprehensive user status checking
- Claim status toggling
- Owner-only administrative functions

## Contract Constants

| Constant | Description | Error Code |
|----------|-------------|------------|
| `err-owner-only` | Only contract owner can perform this action | u100 |
| `err-already-claimed` | User has already claimed their tokens | u101 |
| `err-not-eligible` | User is not eligible for the airdrop | u102 |
| `err-no-allocation` | No allocation found for the user | u103 |
| `err-claim-disabled` | Claiming is currently disabled | u104 |
| `err-invalid-address` | Invalid address provided | u105 |
| `err-invalid-amount` | Invalid amount specified | u106 |

## Data Storage

### Variables
- `total-tokens`: Maximum tokens available for airdrop (uint)
- `is-claim-enabled`: Global switch for enabling/disabling claims (bool)

### Maps
- `allocations`: Maps user addresses to their token allocation
- `claimed`: Tracks whether a user has claimed their tokens
- `eligibility-nft`: Tracks NFT-based eligibility
- `whitelist`: Tracks whitelisted addresses

## Public Functions

### Administrative Functions (Owner Only)

```clarity
(add-to-whitelist (address principal))
```
Adds an address to the whitelist.

```clarity
(remove-from-whitelist (address principal))
```
Removes an address from the whitelist.

```clarity
(set-nft-eligibility (address principal) (eligible bool))
```
Sets NFT-based eligibility for an address.

```clarity
(set-allocation (address principal) (amount uint))
```
Sets token allocation for an address.

```clarity
(batch-airdrop (addresses (list 200 principal)) (amounts (list 200 uint)))
```
Performs batch airdrop to multiple addresses.

```clarity
(toggle-claim)
```
Toggles global claim status.

### User Functions

```clarity
(claim)
```
Allows eligible users to claim their allocated tokens.

### Read-Only Functions

```clarity
(get-allocation (address principal))
```
Returns the token allocation for an address.

```clarity
(is-claimed (address principal))
```
Checks if an address has claimed their tokens.

```clarity
(check-eligibility (address principal))
```
Checks if an address is eligible for the airdrop.

```clarity
(get-claim-status)
```
Returns the global claim status.

```clarity
(get-total-tokens)
```
Returns the total tokens available for airdrop.

```clarity
(get-user-status (address principal))
```
Returns comprehensive status information for a user, including:
- Token allocation
- Claim status
- Eligibility status
- Whitelist status
- NFT eligibility status
- Current ability to claim

## Usage Example

1. Contract deployment:
   - Deploy the contract
   - Initial claim status will be disabled
   - Contract deployer becomes the owner

2. Setup phase:
   ```clarity
   ;; Add addresses to whitelist
   (add-to-whitelist 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
   
   ;; Set NFT eligibility
   (set-nft-eligibility 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 true)
   
   ;; Set token allocation
   (set-allocation 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 u1000)
   ```

3. Enable claiming:
   ```clarity
   (toggle-claim)
   ```

4. Users can check their status:
   ```clarity
   (get-user-status 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
   ```

5. Eligible users can claim:
   ```clarity
   (claim)
   ```

## Security Considerations

1. Only the contract owner can:
   - Modify the whitelist
   - Set NFT eligibility
   - Set token allocations
   - Toggle claim status
   - Perform batch airdrops

2. Users cannot:
   - Claim more than their allocation
   - Claim multiple times
   - Claim if not eligible
   - Claim when claiming is disabled

3. Additional safeguards:
   - Address validation
   - Amount validation
   - Eligibility checks
   - Claim status verification

