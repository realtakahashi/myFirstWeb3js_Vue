pragma solidity ^0.4.23;

contract registerAccount{
    uint public numAccount;
    
    constructor() public {
        numAccount = 0;
    }
    
    struct account{
        address addr;
        string name;
        string email;
    }
    mapping(uint=>account) public accounts;
    
    function register(string _name, string _email) public {
        accounts[numAccount].addr = msg.sender;
        accounts[numAccount].name = _name;
        accounts[numAccount].email = _email;
        numAccount++;
    }
    
}
