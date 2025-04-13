// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityEventRegistrationSystem {
    struct Event {
        string eventName;
        string location;
        uint256 startDate;
        uint256 endDate;
        address[] participants; // Список адресов участников
    }

    Event[] private events;

    event EventCreated(uint256 indexed eventId, string eventName, string location, uint256 startDate, uint256 endDate);
    event ParticipantRegistered(uint256 indexed eventId, address indexed participant);

    function createEvent(string memory eventName, string memory location, uint256 startDate, uint256 endDate) public {
        events.push(Event({eventName: eventName, location: location, startDate: startDate, endDate: endDate, participants: new address[](0)}));
        emit EventCreated(events.length - 1, eventName, location, startDate, endDate);
    }

    function registerParticipant(uint256 eventId) public {
        require(eventId < events.length, "Event does not exist.");
        events[eventId].participants.push(msg.sender);
        emit ParticipantRegistered(eventId, msg.sender);
    }

    function getEvent(uint256 eventId) public view returns (string memory, string memory, uint256, uint256, address[] memory) {
        require(eventId < events.length, "Event does not exist.");
        Event memory eventInfo = events[eventId];
        return (eventInfo.eventName, eventInfo.location, eventInfo.startDate, eventInfo.endDate, eventInfo.participants);
    }

    function getEventCount() public view returns (uint256) {
        return events.length;
    }
}