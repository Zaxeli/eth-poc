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

















# Ethereum Reentrancy exploit to steal 80M USD

This is a PoC recreation of the exploit against RariCapital which stole 80M USD from their lending pool by exploiting a Reentrancy and Flash Loan vulnerability. The attack was carried out in this transaction: https://versatile.blocksecteam.com/tx/eth/0xab486012f21be741c9e674ffda227e30518e8a1e37a5f1d58d0b0d41f6e76530; and the tweet by BlockSecTeam is here: https://twitter.com/BlockSecTeam/status/1520350965274386433 

## Core ideas for the exploit:

### Basics/background
What is flash loan
What is the reentrancy

### effects of exploit
Which coins were affected
How much of each coin stolen


### structure of exploit
Malicious account
Malicious contract
Spawned contracts

### Conceptual exploit

do a flashloan on BalancerVault
receive flashloan
spwan contract
transfer usdc to spawn1

use spawn1:-
setup:
    enterMarkets for the cToken ebe0d1

        what is cToken and what does enerMarket do?
mint:
    approve a spender (ebe0d1) for the amount that can be spent

    accrueInteret by allowing the spender to spend

        gets money for the cTokens that are now owned becaue we got them from the flashLoan and so we can get interest for it

    spender -> mint
        what is this?

        supplies the received amount from flashLoan so that interest accrual can happen


borrow:
    fETH_127_cEther borrow

    borrow an amount (47072970419999996575297) from the fETH_127 cEther token 

    this will also trigger fallback:
        exitMarket for ebe0d1 

        we have exited the market without returning the borrowed amount


redeemAll:
    approve a spender (ebe0d1)


    redeemUnderlying

        we get the money back from the cEther token 

    usdc transfer to MalContract

        then we send the money to the parent contract. This is the profit we make

weth_contr withdraw 5000..

    we use the flashLoan to withdraw 500000.. ETH by using the WETH we got from the flashLoan

fETH_127_cont mint 5000..

    then mint fETH_127 tokens usng the 5000.. ETH
    meaning, we transfer our ETH nto the protocol to allow it to gain interest

enterMarket (fETH 127)

ebe0d1.borrow

cERC20Delegator.borrow

x8922c.borrow

spawn another contract (x4ec88)

do similarly to  setup, mint, borrow with a reentrant exitMarket call, and then redeemAll

once this is done, we deposit 5000.. ETH back to WETH
then use this to transfer it to BalancerVault, along with USDC
so that the transcation doesn't revert.

In short, we are getting a flashLoan and then using those to enter markets and then mint and borrow money. We can then use the fallback function to reenter into the exitMarket function which absolves us from having to repay the borrowed amount. At the end, we return the money we took from BalancerVault.

Once all this is done, we can use the malicious contract to send the stolen money to our actual account.






### clarifications
what is cToken




- Uses reentrancy
- 












<!-- 
< -- Work in progress -- >

The malicious solidity contract is in contr.sol

Compile it using `soljs`

Deploy the contract using Ganache to replicate the chain at the desired block

Use the `launch()` function in the contract.

The deploy.js file does this and also checks the balance before and after it.

It should run the exploit. However, there is a problem where it isn't able to call the external Balancer Vault contract for the `flashLoan()` function. 


(node modules need to be installed also) -->



