// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract CharityDonationsPlatform {
    //combine multiple related data types into a single component. 
    //Campaign becomes a data type in itself.
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
        address donorAdress;
        uint amount;
    }

    //state variables
    uint public totalCampaigns; // Fixed typo: totalCampaings -> totalCampaigns

    //map function to map every campaign to its corresponding campaign struct
    mapping(uint => Campaign) public campaigns;

    // campaigns[key] = value 

    //map func to map a campaign id to an array of donor struct
    mapping(uint => Donor[]) public campaignDonors;

    // events
    event CampaignCreated(uint id, string title, address owner);
    event DonationsReceived(uint amount, uint campaignId, address donor);
    event FundsWithdrawn(uint amount, uint campaignId);

    //funcs
    function createCampaign(
        string memory _title,
        string memory _description,
        uint _targetAmount
    ) public {
        require(_targetAmount > 0, "The target amount should be greater than 0");
        totalCampaigns++; //assigns a new unique ID to the campaign
        campaigns[totalCampaigns] = Campaign({
            id: totalCampaigns,
            title: _title,
            description: _description,
            targetAmount: _targetAmount,
            raisedAmount: 0,
            owner: payable(msg.sender),
            isCompleted: false
        });

        emit CampaignCreated(totalCampaigns, _title, msg.sender); //logs the campaign creation
    }

    function donateToCampaign(uint _campaignId) public payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(_campaignId > 0 && _campaignId <= totalCampaigns, "Invalid Campaign Id"); //Checks if the campaign ID is valid
        require(!campaign.isCompleted, "Campaign is already completed"); //Ensures the campaign is NOT completed
        require(msg.value > 0, "Donation must be greater than 0");

        // update funds
        campaign.raisedAmount += msg.value;
        //track donor. adds the donor to the campaignDonors mapping.
        campaignDonors[_campaignId].push(Donor({donorAdress: msg.sender, amount: msg.value}));

        //emit event to log the donation
        emit DonationsReceived(msg.value, _campaignId, msg.sender);

        //condition to check if the target amount is raised
        if (campaign.raisedAmount >= campaign.targetAmount) {
            campaign.isCompleted = true;
        }
    }

    function withdrawFunds(uint _campaignId) public {
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.sender == campaign.owner, "Only the Campaign owner is allowed to withdraw funds");
        require(campaign.raisedAmount > 0, "Amount should be greater than 0");

        uint amount = campaign.raisedAmount;
        campaign.raisedAmount = 0;
        campaign.owner.transfer(amount);

        //logging the withdrawal
        emit FundsWithdrawn(amount, _campaignId);
    }
}
