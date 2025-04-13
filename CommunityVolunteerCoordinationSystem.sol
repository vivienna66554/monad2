// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CommunityVolunteerCoordinationSystem {
    struct Volunteer {
        string name;
        string skills;
        bool isAvailable;
    }

    struct Event {
        string eventName;
        string location;
        uint256 startTime;
        uint256 endTime;
        uint256[] volunteerIds; // Список ID волонтеров
    }

    Volunteer[] private volunteers;
    Event[] private events;

    event VolunteerRegistered(uint256 indexed volunteerId, string name, string skills);
    event EventCreated(uint256 indexed eventId, string eventName, string location, uint256 startTime, uint256 endTime);
    event VolunteerAssigned(uint256 indexed eventId, uint256 indexed volunteerId);
    event VolunteerUnassigned(uint256 indexed eventId, uint256 indexed volunteerId);

    function registerVolunteer(string memory name, string memory skills) public {
        volunteers.push(Volunteer({name: name, skills: skills, isAvailable: true}));
        emit VolunteerRegistered(volunteers.length - 1, name, skills);
    }

    function createEvent(string memory eventName, string memory location, uint256 startTime, uint256 endTime) public {
        events.push(Event({eventName: eventName, location: location, startTime: startTime, endTime: endTime, volunteerIds: new uint256[](0)}));
        emit EventCreated(events.length - 1, eventName, location, startTime, endTime);
    }

    function assignVolunteer(uint256 eventId, uint256 volunteerId) public {
        require(eventId < events.length, "Event does not exist.");
        require(volunteerId < volunteers.length, "Volunteer does not exist.");
        require(volunteers[volunteerId].isAvailable, "Volunteer is not available.");

        events[eventId].volunteerIds.push(volunteerId);
        emit VolunteerAssigned(eventId, volunteerId);
    }

    function unassignVolunteer(uint256 eventId, uint256 volunteerId) public {
        require(eventId < events.length, "Event does not exist.");
        require(volunteerId < volunteers.length, "Volunteer does not exist.");

        for (uint256 i = 0; i < events[eventId].volunteerIds.length; i++) {
            if (events[eventId].volunteerIds[i] == volunteerId) {
                events[eventId].volunteerIds[i] = events[eventId].volunteerIds[events[eventId].volunteerIds.length - 1];
                events[eventId].volunteerIds.pop();
                break;
            }
        }
        emit VolunteerUnassigned(eventId, volunteerId);
    }

    function getVolunteer(uint256 volunteerId) public view returns (string memory, string memory, bool) {
        require(volunteerId < volunteers.length, "Volunteer does not exist.");
        Volunteer memory volunteer = volunteers[volunteerId];
        return (volunteer.name, volunteer.skills, volunteer.isAvailable);
    }

    function getEvent(uint256 eventId) public view returns (string memory, string memory, uint256, uint256, Volunteer[] memory) {
        require(eventId < events.length, "Event does not exist.");
        Event memory eventInfo = events[eventId];
        Volunteer[] memory volunteerArray = new Volunteer[](eventInfo.volunteerIds.length);
        for (uint256 i = 0; i < eventInfo.volunteerIds.length; i++) {
            volunteerArray[i] = volunteers[eventInfo.volunteerIds[i]];
        }
        return (eventInfo.eventName, eventInfo.location, eventInfo.startTime, eventInfo.endTime, volunteerArray);
    }

    function getEventCount() public view returns (uint256) {
        return events.length;
    }
}