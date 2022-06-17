# Ethereum Reentrancy exploit to steal 80M USD

This is a PoC recreation of the exploit against RariCapital which stole 80M USD from their lending pool by exploiting a Reentrancy and Flash Loan vulnerability. The attack was carried out in this transaction: https://versatile.blocksecteam.com/tx/eth/0xab486012f21be741c9e674ffda227e30518e8a1e37a5f1d58d0b0d41f6e76530; and the tweet by BlockSecTeam is here: https://twitter.com/BlockSecTeam/status/1520350965274386433 


## Background

### Flash Loans

Flash loans are transactions that we can do on a Vault (Balancer Vault) to get an amount of money from the vault. We can then use this money to perform any actions that we want within the same transaction. The requirement is that the money must be returned back to the Vault.
Ref: https://docs.balancer.fi/concepts/features/flash-loans 

### Reentrancy

Reentrancy is a kind of vulnerability which allows us to reenter into a contract's functions before the state changes are made which prevent reexecution of the same logic. This can allow an attacker to perform some action which is beneficial to them repeatedly before the contract updates the relevant state which prevents it.

## Effects of this exploit

### (Remove) Coins affected
The attacker stole money in the form of USDC and WETH. USDC is pegged to the actual value of USD; WETH is a wrapped version of ETH so that it can be used as a token.

### 



## Structure of exploit

The exploit makes use of a malicious contract which is created by the attacker. This contract then calls the `flashLoan` function on the `BalancerVault` contract. The tokens that it requests are: `[USDC, WETH]`; and the amounts are: `[150000000000000, 50000000000000000000000]` respectively.

Once it has the amounts received, the function `receiveFlashLoan` is called by `BalancerVault`. This will then spawn another contract which uses these funds to enter into markets, accrue interest, borrow and then redeem the profits. When it does the `borrow` function on the tokens, the fallback function will be triggered along with the borrowed amount. This is used to then call `exitMarket`, which means that the market is exited without repaying the borrowed amount. So, the funds are now stolen. It does this twice.

Addresses:
- The malicious user account: 0x6162759eDAd730152F0dF8115c698a42E666157F
- The inital malicious contract: 0x32075bAd9050d4767018084F0Cb87b3182D36C45
- The first spawned contract: 0x03296D34FD6B3619a75860f44a0D2C68336708e7
- The second spawned conract: 0x4Ec88aa13b789fA31e939124a3384DcE9d8030e8












The malicious solidity contract is in contr.sol

Compile it using `soljs`

Deploy the contract using Ganache to replicate the chain at the desired block

Use the `launch()` function in the contract.

The deploy.js file does this and also checks the balance before and after it.

It should run the exploit. However, there is a problem where it isn't able to call the external Balancer Vault contract for the `flashLoan()` function. 


(node modules need to be installed also)



