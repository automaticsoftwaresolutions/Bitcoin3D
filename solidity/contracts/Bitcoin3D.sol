// SPDX-License-Identifier: MIT

pragma solidity >=0.8.11 <0.9.0;

import "./Token.sol";
import "./StandardToken.sol";

abstract contract ApproveAndCallFallBack 
{
      function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public virtual;
}



//name this contract whatever you'd like
contract Bitcoin3D is StandardToken
{

    /* Public variables of the token */
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
   
    string public name;                  
    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
    string public symbol;                 //An identifier: eg SBX
    string public version = '1.0.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
//
// CHANGE THESE VALUES FOR YOUR TOKEN
//

//make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token

    constructor(uint256 supply) StandardToken(supply) 
    {        
        balances[msg.sender] = supply;            
        name = "Bitcoin3D";                               
        decimals = 18;                            
        symbol = "Bitcoin3D";                              
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, 
        bytes memory _extraData) 
        public returns (bool success) 
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        ApproveAndCallFallBack(_spender).receiveApproval(
            msg.sender,
            _value,
            address(this),
            _extraData
        );

        return true;
    }
}