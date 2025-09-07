# Fund Me Smart Contract

Basic Solidity Smart Contract with ```fund()``` and ```withdraw()``` function to Sepolia Zksync Network. The price converter from ETH to USD is using realtime ChainLink Data Feeds (https://docs.chain.link/data-feeds).

## Remix IDE ##

Development and deployment using Remix.

The deployed contract can be seen here: https://sepolia.explorer.zksync.io/address/0x893935a6fE5606298E63a40a2205937aAE553642

## Foundry ##

FundMe Smart Contract using Foundry and some unit + integration test. Dynamically detect the current network to deploy the smart contract and get the oracle ChainLink price feed (ETH to USD) (currently support sepolia, ethereum, and anvil network).

Deployed Smart Contract using forge: https://sepolia.etherscan.io/address/0xb07E9df095f67fAb13B42c4da7C88E13FC661c80

### Deploy ###

```forge script script/DeployFundMe.s.sol```

### Testing ###

<b>

1. Unit

2. Integration

3. Forked

4. Staging
</b>

This repo cover #1 and #3.

```forge test```

or

```forge test --match-test testFunctionName``` for running specific test case 

or

```forge test --fork-url $SEPOLIA_RPC_URL```

<b>Test Coverage</b>

```forge coverage```