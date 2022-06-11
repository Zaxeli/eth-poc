The malicious solidity contract is in contr.sol

Compile it using `soljs`

Deploy the contract using Ganache to replicate the chain at the desired block

Use the `launch()` function in the contract.

The deploy.js file does this and also checks the balance before and after it.

It should run the exploit. However, there is a problem where it isn't able to call the external Balancer Vault contract for the `flashLoan()` function. 


(node modules need to be installed also)



