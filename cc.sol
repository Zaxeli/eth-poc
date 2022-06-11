pragma solidity ^0.7.0;


contract CEther {
  function borrow(uint borrowAmount) external returns (uint);
}

contract Unitroller {
  // function oracle()
}


contract FirstContract {

  // address of the attacker who created this contract
  address public parent;

  constructor(address parent_) public {
    parent = parent_;
  }

  function launch() public returns (uint) {
    
    // addresses
    address cEther_addr = 0x26267e41CeCa7C8E0f143554Af707336f27Fa051;
    address Unitroller_addr = 0x3f2D1BC6D02522dbcdb216b2e75eDDdAFE04B16F;
    address BalancerVault_addr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    // contracts
    CEther cEther = CEther(cEther_addr);
    BalancerVault vault = Vault(BalancerVault_addr); 



    // uint r = cEther.borrow(amt);

    return 0;
  }


  function borrow(uint amt) public returns (uint) {
    
    // addresses
    address cEther_addr = 0x26267e41CeCa7C8E0f143554Af707336f27Fa051;
    address Unitroller_addr = 0x3f2D1BC6D02522dbcdb216b2e75eDDdAFE04B16F;
    address BalancerVault_addr = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    // contracts
    CEther cEther = CEther(cEther_addr);



    uint r = cEther.borrow(amt);

    return r;
  }



  function getInteger() public pure returns (uint) {
    return 123;
  }
}

