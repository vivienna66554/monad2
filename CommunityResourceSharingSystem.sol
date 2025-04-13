// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityResourceSharingSystem {
    struct Resource {
        string title;
        string description;
        string resourceLink;
        address uploader;
    }

    Resource[] private resources;

    event ResourceUploaded(uint256 indexed resourceId, string title, string description, string resourceLink, address uploader);

    function uploadResource(string memory title, string memory description, string memory resourceLink) public {
        resources.push(Resource({title: title, description: description, resourceLink: resourceLink, uploader: msg.sender}));
        emit ResourceUploaded(resources.length - 1, title, description, resourceLink, msg.sender);
    }

    function getResource(uint256 resourceId) public view returns (string memory, string memory, string memory, address) {
        require(resourceId < resources.length, "Resource does not exist.");
        Resource memory resource = resources[resourceId];
        return (resource.title, resource.description, resource.resourceLink, resource.uploader);
    }

    function getResourceCount() public view returns (uint256) {
        return resources.length;
    }
}