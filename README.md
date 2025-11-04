# Marketplace Smart Contract

A reusable NFT marketplace smart contract (Solidity) supporting:
- Fixed-price listings
- Auctions
- Off-chain signed offers
- EIP-2981 compatible royalties
- Platform fees
- Pausable/admin controls and reentrancy protection

This repository contains the contract, interface, deployment scripts, and tests intended for Hardhat/TypeScript projects.

## Table of contents
- Features
- Repository layout
- Requirements
- Configuration
- Deployment
- Usage examples
- Tests
- Security & recommendations

## Features
- Listings (buy now / cancel)
- Time-limited auctions with bidding and settlement
- Accept on-chain or off-chain signed offers
- Royalty distribution per EIP-2981
- Platform fee (recipient + bps)
- Admin controls (pause/unpause, update fee recipient)
- ReentrancyGuard and SafeERC20 usage for safety

## Repository layout
- contracts/Marketplace.sol — main contract
- contracts/interfaces/IMarketplace.sol — marketplace interface
- scripts/deploy/marketplace.ts — deployment script
- test/marketplace.spec.ts or tests/ — unit & integration tests
- hardhat.config.ts / vitest.config.js — project config
- package.json — scripts for build, test, and deploy

## Requirements
- Node.js >= 16 (LTS recommended)
- npm or yarn
- Hardhat
- TypeScript (project uses TypeChain artifacts)
- OpenZeppelin contracts (installed via package.json)

Install dependencies:
```bash
npm install
# or
yarn
```

## Configuration
Create a .env file in the repo root with required environment variables (example):
```text
RPC_URL=https://mainnet.infura.io/v3/YOUR_KEY
PRIVATE_KEY=0x...                # deployer/admin private key (keep secret)
FEE_RECIPIENT=0x...              # platform fee recipient address
FEE_BPS=250                      # platform fee in basis points (e.g., 250 = 2.5%)
ADMIN_KEY=0x...                  # optional admin key for multisig/testing
ETHERSCAN_API_KEY=...            # optional for verification
```

Ensure token approvals are set before performing marketplace transfers.

## Deployment
Deploy to a network with Hardhat:
```bash
npx hardhat run scripts/deploy/marketplace.ts --network <network>
```
Replace `<network>` with your configured Hardhat network (e.g., rinkeby, mainnet, polygon).

Common post-deploy steps:
- Verify contract on Etherscan (if applicable)
- Update frontend with deployed address and ABI (artifacts/typechain)

## Usage examples
Buy a fixed-price listing (JS/ethers):
```js
const marketplace = await ethers.getContractAt("Marketplace", MARKETPLACE_ADDRESS);
await marketplace.buy(listingId, { value: price });
```

Create a listing (seller):
```js
await marketplace.createListing(nftAddress, tokenId, price, expiresAt);
```

Place an auction bid:
```js
await marketplace.placeBid(auctionId, { value: bidAmount });
```

Accept an off-chain signed offer:
- Verify signature off-chain and call `acceptOffer(offer, signature)` on the marketplace.

Refer to tests for full interaction patterns and required approvals.

## Tests
Run unit and integration tests:
```bash
npm run test
# or with vitest
npx vitest
```
Tests cover:
- Listing lifecycle (create, buy, cancel)
- Auction flow (create, bid, settle)
- Offer signing and acceptance
- Royalty & fee distribution
- Access control and reentrancy checks

## Security & recommendations
- Uses OpenZeppelin ReentrancyGuard, SafeERC20, and checks-effects-interactions where relevant.
- Require thorough review and a third-party audit before mainnet deployment.
- Use a multisig for admin actions and pause functionality.
- Monitor gas usage and edge cases in production.
- Do not expose private keys in repos or logs.

## Contributing
- Open issues for bugs or feature requests.
- Create PRs against main with clear descriptions and tests.
- Maintainers will review and request changes as needed.
