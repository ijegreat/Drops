;; Airdrop Smart Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-claimed (err u101))
(define-constant err-not-eligible (err u102))
(define-constant err-no-allocation (err u103))
(define-constant err-claim-disabled (err u104))
(define-constant err-invalid-address (err u105))
(define-constant err-invalid-amount (err u106))

;; Data Variables
(define-data-var total-tokens uint u5000000)     
(define-data-var is-claim-enabled bool false)    

;; Data Maps
(define-map allocations principal uint)          ;; Maps addresses to their allocation
(define-map claimed principal bool)              ;; Tracks if address has claimed
(define-map eligibility-nft principal bool)      ;; NFT-based eligibility
(define-map whitelist principal bool)            ;; Whitelisted addresses

;; Private Functions
(define-private (is-owner)
    (is-eq tx-sender contract-owner))

(define-private (is-eligible (address principal))
    (and 
        (is-some (map-get? whitelist address))
        (is-some (map-get? eligibility-nft address))))

(define-private (validate-address (address principal))
    (and
        (is-some (some address))  ;; Check if address is not none
        (not (is-eq address contract-owner)))) ;; Prevent setting contract owner

;; Public Functions

;; Add addresses to whitelist (owner only)
(define-public (add-to-whitelist (address principal))
    (begin
        (asserts! (is-owner) err-owner-only)
        (asserts! (validate-address address) err-invalid-address)
        (ok (map-set whitelist address true))))

;; Remove address from whitelist (owner only)
(define-public (remove-from-whitelist (address principal))
    (begin
        (asserts! (is-owner) err-owner-only)
        (asserts! (validate-address address) err-invalid-address)
        (ok (map-set whitelist address false))))

;; Set NFT-based eligibility (owner only)
(define-public (set-nft-eligibility (address principal) (eligible bool))
    (begin
        (asserts! (is-owner) err-owner-only)
        (asserts! (validate-address address) err-invalid-address)
        (ok (map-set eligibility-nft address eligible))))

;; Set token allocation for an address (owner only)
(define-public (set-allocation (address principal) (amount uint))
    (begin
        (asserts! (is-owner) err-owner-only)
        (asserts! (validate-address address) err-invalid-address)
        (asserts! (> amount u0) err-invalid-amount)
        (asserts! (<= amount (var-get total-tokens)) err-invalid-amount)
        (ok (map-set allocations address amount))))

;; Claim tokens (public)
(define-public (claim)
    (let ((address tx-sender)
          (allocation (unwrap! (map-get? allocations address) err-no-allocation)))
        (begin
            ;; Check if claiming is enabled
            (asserts! (var-get is-claim-enabled) err-claim-disabled)
            ;; Check if eligible
            (asserts! (is-eligible address) err-not-eligible)
            ;; Check if not already claimed
            (asserts! (not (default-to false (map-get? claimed address))) err-already-claimed)
            ;; Mark as claimed
            (map-set claimed address true)
            ;; Transfer tokens (using ft-transfer hypothetically)
            ;; Note: You'll need to implement actual token transfer logic based on your token type
            (ok allocation))))

;; Direct airdrop to multiple addresses (owner only)
(define-public (batch-airdrop (addresses (list 200 principal)) (amounts (list 200 uint)))
    (begin
        (asserts! (is-owner) err-owner-only)
        ;; Validate that list lengths match
        (asserts! (is-eq (len addresses) (len amounts)) err-invalid-amount)
        ;; Validate each address and amount
        (asserts! 
            (fold and 
                (map validate-address addresses) 
                true) 
            err-invalid-address)
        ;; Check if amounts are greater than zero
        (asserts! 
            (fold and 
                (map is-valid-amount amounts)
                true) 
            err-invalid-amount)
        ;; Implementation would iterate through lists and transfer tokens
        ;; Note: Actual implementation would depend on your token contract
        (ok true)))

;; Helper function to validate amount
(define-private (is-valid-amount (amount uint))
    (> amount u0))

;; Toggle claim status (owner only)
(define-public (toggle-claim)
    (begin
        (asserts! (is-owner) err-owner-only)
        (ok (var-set is-claim-enabled (not (var-get is-claim-enabled))))))

;; Read-only functions

(define-read-only (get-allocation (address principal))
    (default-to u0 (map-get? allocations address)))

(define-read-only (is-claimed (address principal))
    (default-to false (map-get? claimed address)))

(define-read-only (check-eligibility (address principal))
    (is-eligible address))

(define-read-only (get-claim-status)
    (var-get is-claim-enabled))

(define-read-only (get-total-tokens)
    (var-get total-tokens))