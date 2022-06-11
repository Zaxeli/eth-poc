const fs = require('fs')
const Web3 = require('web3')
const web3 = new Web3('http://localhost:8545')
// const bytecode = fs.readFileSync('./build/FirstContract.bin')
// const abi = JSON.parse(fs.readFileSync('./build/FirstContract.abi').toString())
const bytecode = fs.readFileSync('./build/contr_sol_MalContract.bin')
const abi = JSON.parse(fs.readFileSync('./build/contr_sol_MalContract.abi').toString())


// console.log(abi)
// console.log(JSON.parse(abi))



async function a() {

    const balancerVault = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';


    const ganacheAccounts = await web3.eth.getAccounts();
    const myWalletAddr = ganacheAccounts[0];

    const myContr = new web3.eth.Contract(abi);

    var contrAddress = ''


    await myContr.deploy({
        data: bytecode.toString(),
    }).send({
        from: myWalletAddr,
        gas: 3545064,
    }).then((deployment)=>{
        console.log('deployed');
        console.log(deployment.options.address);
        contrAddress = deployment.options.address;
        console.log("address:",deployment.options.address);

    }).catch(console.error);


    console.log('address of contract: '+contrAddress);

    const contr = new web3.eth.Contract(abi, contrAddress);
    
    await web3.eth.getBalance(balancerVault).then( (r)=>{
        console.log("balance: "+r);
    }).catch((e)=>{
        console.log("er balacnce: ", e);
    });

    await contr.methods.launch().send({
        from: myWalletAddr,
        gas: 5000000
    }).then((receipt) => {
        console.log(receipt);
    }).catch((e) => {
        console.log(e);
    });

    await web3.eth.getBalance(balancerVault).then( (r)=>{
        console.log("balance: "+r);
    }).catch((e)=>{
        console.log("er balacnce: ", e);
    });

}

a();


// COPY THE FUNCTION CALLS FROM THE TX