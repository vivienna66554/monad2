// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract ConferenceManagementSystem {
    struct Conference {
        string conferenceName;
        string location;
        uint256 startDate;
        uint256 endDate;
        uint256[] presentationIds; // Список ID докладов
        address[] attendees; // Список адресов участников
    }

    struct Presentation {
        string title;
        string speaker;
        uint256 startTime;
        uint256 endTime;
    }

    Conference[] private conferences;
    Presentation[] private presentations;

    event ConferenceCreated(uint256 indexed conferenceId, string conferenceName, string location, uint256 startDate, uint256 endDate);
    event PresentationAdded(uint256 indexed conferenceId, uint256 indexed presentationId, string title, string speaker, uint256 startTime, uint256 endTime);
    event AttendeeAdded(uint256 indexed conferenceId, address indexed attendee);

    function createConference(string memory conferenceName, string memory location, uint256 startDate, uint256 endDate) public {
        conferences.push(Conference({conferenceName: conferenceName, location: location, startDate: startDate, endDate: endDate, presentationIds: new uint256[](0), attendees: new address[](0)}));
        emit ConferenceCreated(conferences.length - 1, conferenceName, location, startDate, endDate);
    }

    function addPresentation(uint256 conferenceId, string memory title, string memory speaker, uint256 startTime, uint256 endTime) public {
        require(conferenceId < conferences.length, "Conference does not exist.");
        uint256 presentationId = presentations.length;
        presentations.push(Presentation({title: title, speaker: speaker, startTime: startTime, endTime: endTime}));
        conferences[conferenceId].presentationIds.push(presentationId);
        emit PresentationAdded(conferenceId, presentationId, title, speaker, startTime, endTime);
    }

    function addAttendee(uint256 conferenceId, address attendee) public {
        require(conferenceId < conferences.length, "Conference does not exist.");
        conferences[conferenceId].attendees.push(attendee);
        emit AttendeeAdded(conferenceId, attendee);
    }

    function getConference(uint256 conferenceId) public view returns (string memory, string memory, uint256, uint256, Presentation[] memory, address[] memory) {
        require(conferenceId < conferences.length, "Conference does not exist.");
        Conference memory conference = conferences[conferenceId];
        Presentation[] memory pres = new Presentation[](conference.presentationIds.length);
        for (uint256 i = 0; i < conference.presentationIds.length; i++) {
            pres[i] = presentations[conference.presentationIds[i]];
        }
        return (conference.conferenceName, conference.location, conference.startDate, conference.endDate, pres, conference.attendees);
    }

    function getConferenceCount() public view returns (uint256) {
        return conferences.length;
    }
}