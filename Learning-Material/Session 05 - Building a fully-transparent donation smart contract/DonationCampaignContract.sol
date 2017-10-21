pragma solidity ^0.4.11;

contract DonationCampaignContract {

	address contractCreator;
	mapping(address => uint) donorList; 

	event NewDonation(address donor, uint amount);
	
	modifier minimumDonation(uint threshold) {
		if(msg.value < threshold) {
			throw;
		}
		_;
	}

	function DonationCampaignContract() {
		contractCreator = msg.sender;
	}
	
	function donate() payable minimumDonation(10 ether) {		
		// Check if this guy has ever donated
		uint currentDonation = 0;
		if(donorList[msg.sender] != 0) {
			currentDonation = donorList[msg.sender];
		}
		
		// Save the donation record into a mapping table
		donorList[msg.sender] = currentDonation + msg.value;
		
		// Fire event
		NewDonation(msg.sender, msg.value);
	}

	function claimDonation() {
		uint currentBalance = this.balance; 
		contractCreator.transfer(currentBalance);
	}
	
	function destroyContract() {
		if(msg.sender != contractCreator) {
			throw;
		}
		selfdestruct(contractCreator);
	}
	
}