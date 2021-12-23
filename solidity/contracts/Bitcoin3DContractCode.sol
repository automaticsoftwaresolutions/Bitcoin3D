// SPDX-License-Identifier: MIT

pragma solidity ^0.4.26;

import "./Token.sol";
import "./StandardToken.sol";

contract ApproveAndCallFallBack {
      function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}



//name this contract whatever you'd like
contract Bitcoin3D is StandardToken {

    /* Public variables of the token */

    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    uint256 reserved = 100000000000;
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
    string public symbol;                 //An identifier: eg SBX
    string public version = '1.0.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
//
// CHANGE THESE VALUES FOR YOUR TOKEN
//

//make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token

    constructor(uint256 supply) public
    {
        balances[msg.sender] = reserved;               // Give the creator all initial tokens (100000 for example)
        totalSupply = supply - reserved;                   // Update total supply (100000 for example)
        name = "Bitcoin3D";                                   // Set the name for display purposes
        decimals = 18;                            // Amount of decimals for display purposes
        symbol = "Bitcoin3D";                               // Set the symbol for display purposes
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);


        ApproveAndCallFallBack(_spender).receiveApproval(
            msg.sender,
            _value,
            this,
            _extraData
        );

        return true;
    }
}