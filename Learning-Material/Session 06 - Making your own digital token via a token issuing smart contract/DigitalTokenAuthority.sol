pragma solidity ^0.4.11;

contract DigitalTokenAuthority {

	/*
	 *
	 *	Event declarations
	 *
	 */
	event Transfer(address from, address to, uint256 value);

	/*
	 *
	 *	Variables
	 *
	 */
	address public administrator;
	string public name;
	string public symbol;
	uint8 public decimals;
	mapping(address => uint256) public balanceOf;
	
	/*
	 *
	 *	Modifiers
	 *
	 */
	modifier mustHaveEnoughBalance(address _fromAddress, uint256 _checkingAmount) {
		if(balanceOf[_fromAddress] < _checkingAmount) {
			throw;
		}
		_;
	}
	
	modifier mustNotOverflow(address _toAddress, uint256 _addingAmount) {
		if(balanceOf[_toAddress] + _addingAmount < balanceOf[_toAddress]) {
			throw;
		}
		_;
	}
	
	/*
	 *
	 *	Functions and constructor
	 *
	 */
	function DigitalTokenAuthority(string _tokenName, 
		string _tokenSymbol, uint8 _decimalUnits, uint256 _initialTokenSupply)
	{
		// Contract creator as the administrator
		administrator = msg.sender;
	
		// Give the creator all inital tokens
		balanceOf[msg.sender] = _initialTokenSupply;
		
		// Configure the token
		name = _tokenName;
		symbol = _tokenSymbol;
		decimals = _decimalUnits;
	}
	
	function transfer(address _to, uint256 _amount) 
		mustHaveEnoughBalance(msg.sender, _amount)
		mustNotOverflow(_to, _amount)
	{
		balanceOf[msg.sender] -= _amount;  // Decrease the balance of the sender
		balanceOf[_to] += _amount;	// Increase the balance of the receiver
		
		// Fire a transfer event to notify others
		Transfer(msg.sender, _to, _amount);
	}

}