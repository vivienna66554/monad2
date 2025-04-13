// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityVotingSystem {
    struct Proposal {
        string proposalName;
        string description;
        uint256 yesVotes;
        uint256 noVotes;
    }

    struct Voter {
        bool hasVoted;
    }

    Proposal[] private proposals;
    mapping(address => mapping(uint256 => Voter)) public voterStatus; // Хранение состояния голосования для каждого пользователя и предложения

    event ProposalCreated(uint256 indexed proposalId, string proposalName, string description);
    event Voted(uint256 indexed proposalId, address indexed voter, bool votedYes);

    function createProposal(string memory proposalName, string memory description) public {
        proposals.push(Proposal({proposalName: proposalName, description: description, yesVotes: 0, noVotes: 0}));
        emit ProposalCreated(proposals.length - 1, proposalName, description);
    }

    function vote(uint256 proposalId, bool votedYes) public {
        require(proposalId < proposals.length, "Proposal does not exist.");
        require(!voterStatus[msg.sender][proposalId].hasVoted, "Already voted.");

        if (votedYes) {
            proposals[proposalId].yesVotes += 1;
        } else {
            proposals[proposalId].noVotes += 1;
        }

        voterStatus[msg.sender][proposalId].hasVoted = true;
        emit Voted(proposalId, msg.sender, votedYes);
    }

    function getProposal(uint256 proposalId) public view returns (string memory, string memory, uint256, uint256) {
        require(proposalId < proposals.length, "Proposal does not exist.");
        Proposal memory proposal = proposals[proposalId];
        return (proposal.proposalName, proposal.description, proposal.yesVotes, proposal.noVotes);
    }

    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }
}