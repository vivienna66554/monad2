// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CharityFundraisingCampaignSystem {
    struct Campaign {
        string campaignName;
        string description;
        uint256 targetAmount;
        uint256 raisedAmount;
        uint256[] requestIds; // Список ID заявок
    }

    struct Request {
        string requestName;
        string description;
        uint256 amount;
        bool isFulfilled;
    }

    Campaign[] private campaigns;
    Request[] private requests;

    event CampaignCreated(uint256 indexed campaignId, string campaignName, string description, uint256 targetAmount);
    event RequestAdded(uint256 indexed campaignId, uint256 indexed requestId, string requestName, string description, uint256 amount);
    event RequestFulfilled(uint256 indexed campaignId, uint256 indexed requestId);

    function createCampaign(string memory campaignName, string memory description, uint256 targetAmount) public {
        campaigns.push(Campaign({campaignName: campaignName, description: description, targetAmount: targetAmount, raisedAmount: 0, requestIds: new uint256[](0)}));
        emit CampaignCreated(campaigns.length - 1, campaignName, description, targetAmount);
    }

    function addRequest(uint256 campaignId, string memory requestName, string memory description, uint256 amount) public {
        require(campaignId < campaigns.length, "Campaign does not exist.");
        uint256 requestId = requests.length;
        requests.push(Request({requestName: requestName, description: description, amount: amount, isFulfilled: false}));
        campaigns[campaignId].requestIds.push(requestId);
        emit RequestAdded(campaignId, requestId, requestName, description, amount);
    }

    function fulfillRequest(uint256 campaignId, uint256 requestId) public {
        require(campaignId < campaigns.length, "Campaign does not exist.");
        require(requestId < requests.length, "Request does not exist.");
        require(!requests[requestId].isFulfilled, "Request already fulfilled.");
        require(campaigns[campaignId].raisedAmount >= requests[requestId].amount, "Insufficient funds.");

        campaigns[campaignId].raisedAmount -= requests[requestId].amount;
        requests[requestId].isFulfilled = true;
        emit RequestFulfilled(campaignId, requestId);
    }

    function getCampaign(uint256 campaignId) public view returns (string memory, string memory, uint256, uint256, Request[] memory) {
        require(campaignId < campaigns.length, "Campaign does not exist.");
        Campaign memory campaign = campaigns[campaignId];
        Request[] memory req = new Request[](campaign.requestIds.length);
        for (uint256 i = 0; i < campaign.requestIds.length; i++) {
            req[i] = requests[campaign.requestIds[i]];
        }
        return (campaign.campaignName, campaign.description, campaign.targetAmount, campaign.raisedAmount, req);
    }

    function getCampaignCount() public view returns (uint256) {
        return campaigns.length;
    }
}