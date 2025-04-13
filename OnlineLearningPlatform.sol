// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract OnlineLearningPlatform {
    struct Module {
        string moduleName;
        string contentLink;
    }

    struct Course {
        string courseName;
        string description;
        uint256[] moduleIds; // Список ID модулей вместо массива структур
    }

    Course[] private courses;
    Module[] private modules;
    mapping(address => bool) public courseExists;

    event CourseCreated(uint256 indexed courseId, string courseName, string description);
    event ModuleAdded(uint256 indexed courseId, string moduleName, string contentLink);

    function createCourse(string memory courseName, string memory description) public {
        courses.push(Course({courseName: courseName, description: description, moduleIds: new uint256[](0)}));
        courseExists[msg.sender] = true;
        emit CourseCreated(courses.length - 1, courseName, description);
    }

    function addModule(uint256 courseId, string memory moduleName, string memory contentLink) public {
        require(courseId < courses.length, "Course does not exist.");
        require(courseExists[msg.sender], "You are not authorized to add modules to this course.");

        uint256 moduleId = modules.length;
        modules.push(Module({moduleName: moduleName, contentLink: contentLink}));
        courses[courseId].moduleIds.push(moduleId);
        emit ModuleAdded(courseId, moduleName, contentLink);
    }

    function getCourse(uint256 courseId) public view returns (string memory, string memory, Module[] memory) {
        require(courseId < courses.length, "Course does not exist.");
        Course memory course = courses[courseId];
        Module[] memory modules_ = new Module[](course.moduleIds.length);
        for (uint256 i = 0; i < course.moduleIds.length; i++) {
            modules_[i] = modules[course.moduleIds[i]];
        }
        return (course.courseName, course.description, modules_);
    }

    function getCourseCount() public view returns (uint256) {
        return courses.length;
    }
}