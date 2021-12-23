// SPDX-License-Identifier: MIT

pragma solidity ^0.4.26;


import "./Token.sol";

contract StandardToken is Token {
    uint numberOfBurns = 5;
    uint currentBurn = 0;
    uint256 burnAmount = 10000000000000;
    address burnWallet = 0xdead03D7c5613b7Bd99C8D71dC6571dF55DDe05E;
    uint[] burnIncrements = [ 0, 0, 0, 0, 0 ];
    


    function ValidateBurn() private
    {
        
        if(numberOfBurns <= currentBurn)
        {
            return;
        }
        if(block.timestamp < burnIncrements[currentBurn])
        {
            return;
        }
        ++currentBurn;
        transfer(burnWallet, burnAmount);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);            
            return true;
        } else { return false; }
        ValidateBurn();
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);            
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;
}
