// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract CharityDonationsPlatform {
    struct Campaign {
        uint id;
        string title;
        string description;
        uint targetAmount;
        uint raisedAmount;
        address payable owner;
        bool isCompleted;
    }

    struct Donor {
        address donorAddress;
        uint amount;
    }

    // State variables
    uint public totalCampaigns;

    // Mappings
    mapping(uint => Campaign) public campaigns;
    mapping(uint => Donor[]) public campaignDonors;

    // Events
    event CampaignCreated(uint id, string title, address owner);
    event DonationsReceived(uint amount, uint campaignId, address donor);
    event FundsWithdrawn(uint amount, uint campaignId);

    // Functions
    function createCampaign(
        string memory _title,
        string memory _description,
        uint _targetAmount
    ) public {
        require(_targetAmount > 0, "The target amount should be greater than 0");
        totalCampaigns++; // Assigns a new unique ID to the campaign
        campaigns[totalCampaigns] = Campaign({
            id: totalCampaigns,
            title: _title,
            description: _description,
            targetAmount: _targetAmount,
            raisedAmount: 0,
            owner: payable(msg.sender),
            isCompleted: false
        });

        emit CampaignCreated(totalCampaigns, _title, msg.sender); // Logs the campaign creation
    }

    function donateToCampaign(uint _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(_campaignId > 0 && _campaignId <= totalCampaigns, "Invalid Campaign ID");
        require(!campaign.isCompleted, "Campaign is already completed");
        require(msg.value > 0, "Donation must be greater than 0");

        // Update funds
        campaign.raisedAmount += msg.value;

        // Track donor
        campaignDonors[_campaignId].push(Donor({donorAddress: msg.sender, amount: msg.value}));

        // Emit event to log the donor
        emit DonationsReceived(msg.value, _campaignId, msg.sender);

        // Check if the target amount is reached
        if (campaign.raisedAmount >= campaign.targetAmount) {
            campaign.isCompleted = true;
        }
    }

    function withdrawFunds(uint _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.sender == campaign.owner, "Only the campaign owner is allowed to withdraw funds");
        require(campaign.raisedAmount > 0, "Amount should be greater than 0");

        uint amount = campaign.raisedAmount;
        campaign.raisedAmount = 0;
        campaign.owner.transfer(amount);

        // Log the withdrawal
        emit FundsWithdrawn(amount, _campaignId);
    }
}
