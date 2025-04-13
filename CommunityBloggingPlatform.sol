// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityBloggingPlatform {
    struct Post {
        string title;
        string content;
        address author;
        uint256 timestamp;
        uint256[] commentIds; // Список ID комментариев вместо массива структур
    }

    struct Comment {
        string commentText;
        address commenter;
        uint256 timestamp;
    }

    Post[] private posts;
    Comment[] private comments;

    event PostPublished(uint256 indexed postId, string title, string content, address author, uint256 timestamp);
    event CommentAdded(uint256 indexed postId, string commentText, address commenter, uint256 timestamp);

    function publishPost(string memory title, string memory content) public {
        posts.push(Post({title: title, content: content, author: msg.sender, timestamp: block.timestamp, commentIds: new uint256[](0)}));
        emit PostPublished(posts.length - 1, title, content, msg.sender, block.timestamp);
    }

    function addComment(uint256 postId, string memory commentText) public {
        require(postId < posts.length, "Post does not exist.");
        uint256 commentId = comments.length;
        comments.push(Comment({commentText: commentText, commenter: msg.sender, timestamp: block.timestamp}));
        posts[postId].commentIds.push(commentId);
        emit CommentAdded(postId, commentText, msg.sender, block.timestamp);
    }

    function getPost(uint256 postId) public view returns (string memory, string memory, address, uint256, Comment[] memory) {
        require(postId < posts.length, "Post does not exist.");
        Post memory post = posts[postId];
        Comment[] memory comments_ = new Comment[](post.commentIds.length);
        for (uint256 i = 0; i < post.commentIds.length; i++) {
            comments_[i] = comments[post.commentIds[i]];
        }
        return (post.title, post.content, post.author, post.timestamp, comments_);
    }

    function getPostCount() public view returns (uint256) {
        return posts.length;
    }
}