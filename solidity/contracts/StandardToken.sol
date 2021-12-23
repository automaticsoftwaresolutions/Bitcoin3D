// SPDX-License-Identifier: MIT

pragma solidity >=0.8.11 <0.9.0;


import "./Token.sol";

abstract contract StandardToken is Token 
{
    uint _numberOfBurns = 8;
    uint _currentBurn = 0;
    uint256 _burnAmount = 5000000000000;
    address _burnWallet = 0x000000000000000000000000000000000000dEaD;
    uint[] _burnIncrements = [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
    uint256 _totalSupply;
    constructor(uint256 supply, uint numberOfBurns, uint burnAmount)
    {
        _totalSupply = supply;
        _numberOfBurns = numberOfBurns;
        _burnAmount = burnAmount;
    }

    function ValidateBurn() private
    {        
        if(_numberOfBurns <= _currentBurn)
        {
            return;
        }
        if(block.timestamp < _burnIncrements[_currentBurn])
        {
            return;
        }
        ++_currentBurn;
        transfer(_burnWallet, _burnAmount);
        _totalSupply -= _burnAmount;
    }

    function MiniBurn() private
    {
        transfer(_burnWallet, 1);
    }

    function transfer(address _to, uint256 _value) override
        public returns (bool success) 
    {
        ValidateBurn();
        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            if(_value > 1)
            {
                balances[_to] += _value -1;
            }
            else
            {
                return false;
            }
            emit Transfer(msg.sender, _to, _value);  
            if(_to != _burnWallet)
            {
                MiniBurn();
            }          
            return true;
        } else 
        { 
            return false; 
        }        
    }

    function transferFrom(address _from, address _to, uint256 _value) override
        public returns (bool success) 
    {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);            
            return true;
        } 
        else 
        { 
            return false; 
        }
    }

    function balanceOf(address _owner) override
        public view returns (uint256 balance) 
    {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) override
        public returns (bool success) 
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) override
        public view returns (uint256 remaining) 
    {
      return allowed[_owner][_spender];
    }
   
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
        
    function totalSupply() override
        public view returns (uint256 supply) 
    {  
        return _totalSupply;
    }
}
