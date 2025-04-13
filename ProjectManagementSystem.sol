// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract ProjectManagementSystem {
    struct Task {
        string taskName;
        string description;
        address assignedTo;
        bool isCompleted;
    }

    struct Project {
        string projectName;
        string description;
        uint256[] taskIds; // Список ID задач вместо массива структур
    }

    Project[] private projects;
    Task[] private tasks;
    mapping(address => bool) public taskAssigneeExists;

    event ProjectCreated(uint256 indexed projectId, string projectName, string description);
    event TaskAdded(uint256 indexed projectId, string taskName, string description);
    event TaskAssigned(uint256 indexed projectId, uint256 indexed taskId, address indexed assignedTo);
    event TaskCompleted(uint256 indexed projectId, uint256 indexed taskId);

    function createProject(string memory projectName, string memory description) public {
        projects.push(Project({projectName: projectName, description: description, taskIds: new uint256[](0)}));
        emit ProjectCreated(projects.length - 1, projectName, description);
    }

    function addTask(uint256 projectId, string memory taskName, string memory description) public {
        require(projectId < projects.length, "Project does not exist.");
        uint256 taskId = tasks.length;
        tasks.push(Task({taskName: taskName, description: description, assignedTo: address(0), isCompleted: false}));
        projects[projectId].taskIds.push(taskId);
        emit TaskAdded(projectId, taskName, description);
    }

    function assignTask(uint256 projectId, uint256 taskId, address assignedTo) public {
        require(projectId < projects.length, "Project does not exist.");
        require(taskId < tasks.length, "Task does not exist.");
        require(!taskAssigneeExists[assignedTo], "Task already assigned to another task.");

        tasks[taskId].assignedTo = assignedTo;
        taskAssigneeExists[assignedTo] = true;
        emit TaskAssigned(projectId, taskId, assignedTo);
    }

    function completeTask(uint256 projectId, uint256 taskId) public {
        require(projectId < projects.length, "Project does not exist.");
        require(taskId < tasks.length, "Task does not exist.");
        require(tasks[taskId].assignedTo == msg.sender, "You are not assigned to this task.");
        require(!tasks[taskId].isCompleted, "Task already completed.");

        tasks[taskId].isCompleted = true;
        emit TaskCompleted(projectId, taskId);
    }

    function getProject(uint256 projectId) public view returns (string memory, string memory, Task[] memory) {
        require(projectId < projects.length, "Project does not exist.");
        Project memory project = projects[projectId];
        Task[] memory tasks_ = new Task[](project.taskIds.length);
        for (uint256 i = 0; i < project.taskIds.length; i++) {
            tasks_[i] = tasks[project.taskIds[i]];
        }
        return (project.projectName, project.description, tasks_);
    }

    function getProjectCount() public view returns (uint256) {
        return projects.length;
    }
}