// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityFeedbackSystem {
    struct Feedback {
        string topic;
        string comment;
        address author;
        uint256 timestamp;
    }

    Feedback[] private feedbacks;

    event FeedbackSubmitted(uint256 indexed feedbackId, string topic, string comment, address author, uint256 timestamp);

    function submitFeedback(string memory topic, string memory comment) public {
        feedbacks.push(Feedback({topic: topic, comment: comment, author: msg.sender, timestamp: block.timestamp}));
        emit FeedbackSubmitted(feedbacks.length - 1, topic, comment, msg.sender, block.timestamp);
    }

    function getFeedback(uint256 feedbackId) public view returns (string memory, string memory, address, uint256) {
        require(feedbackId < feedbacks.length, "Feedback does not exist.");
        Feedback memory feedback = feedbacks[feedbackId];
        return (feedback.topic, feedback.comment, feedback.author, feedback.timestamp);
    }

    function getFeedbackCount() public view returns (uint256) {
        return feedbacks.length;
    }
}