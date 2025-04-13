// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityForumSystem {
    struct Forum {
        string forumName;
        string description;
        uint256[] topicIds; // Список ID тем
    }

    struct Topic {
        string title;
        string description;
        uint256[] messageIds; // Список ID сообщений
    }

    struct Message {
        string content;
        address author;
        uint256 timestamp;
    }

    Forum[] private forums;
    Topic[] private topics;
    Message[] private messages;

    event ForumCreated(uint256 indexed forumId, string forumName, string description);
    event TopicAdded(uint256 indexed forumId, uint256 indexed topicId, string title, string description);
    event MessageAdded(uint256 indexed forumId, uint256 indexed topicId, uint256 indexed messageId, string content, address author, uint256 timestamp);

    function createForum(string memory forumName, string memory description) public {
        forums.push(Forum({forumName: forumName, description: description, topicIds: new uint256[](0)}));
        emit ForumCreated(forums.length - 1, forumName, description);
    }

    function addTopic(uint256 forumId, string memory title, string memory description) public {
        require(forumId < forums.length, "Forum does not exist.");
        uint256 topicId = topics.length;
        topics.push(Topic({title: title, description: description, messageIds: new uint256[](0)}));
        forums[forumId].topicIds.push(topicId);
        emit TopicAdded(forumId, topicId, title, description);
    }

    function addMessage(uint256 forumId, uint256 topicId, string memory content) public {
        require(forumId < forums.length, "Forum does not exist.");
        require(topicId < topics.length, "Topic does not exist.");
        uint256 messageId = messages.length;
        messages.push(Message({content: content, author: msg.sender, timestamp: block.timestamp}));
        topics[topicId].messageIds.push(messageId);
        emit MessageAdded(forumId, topicId, messageId, content, msg.sender, block.timestamp);
    }

    function getForum(uint256 forumId) public view returns (string memory, string memory, Topic[] memory) {
        require(forumId < forums.length, "Forum does not exist.");
        Forum memory forum = forums[forumId];
        Topic[] memory top = new Topic[](forum.topicIds.length);
        for (uint256 i = 0; i < forum.topicIds.length; i++) {
            top[i] = topics[forum.topicIds[i]];
        }
        return (forum.forumName, forum.description, top);
    }

    function getTopic(uint256 topicId) public view returns (string memory, string memory, Message[] memory) {
        require(topicId < topics.length, "Topic does not exist.");
        Topic memory topic = topics[topicId];
        Message[] memory mes = new Message[](topic.messageIds.length);
        for (uint256 i = 0; i < topic.messageIds.length; i++) {
            mes[i] = messages[topic.messageIds[i]];
        }
        return (topic.title, topic.description, mes);
    }

    function getForumCount() public view returns (uint256) {
        return forums.length;
    }

    function getTopicCount() public view returns (uint256) {
        return topics.length;
    }
}