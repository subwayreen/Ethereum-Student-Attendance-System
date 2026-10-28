
 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.20;

 contract StudentAttendance {

     // 1. ADMIN
     address public admin;

     constructor() {
         admin = msg.sender;
     }

     modifier onlyAdmin() {
         require(msg.sender == admin, "Only admin allowed");
         _;
     }

     modifier onlyTeacher() {
         require(
             authorizedTeachers[msg.sender],
             "Only authorized teachers allowed"
         );
         _;
     }

     // 2. STUDENT REGISTRATION
     struct Student {
         string name;
         bool registered;
         uint256 presentCount;
     }

     mapping(uint256 => Student) public students;
     uint256 public totalStudents;

     event StudentRegistered(
         uint256 indexed studentId,
         string name
     );

     function registerStudent(
         uint256 _studentId,
         string memory _name
     ) public onlyAdmin {

         require(_studentId > 0, "Invalid student ID");
         require(!students[_studentId].registered, "Student already registered");
         require(bytes(_name).length > 0, "Name cannot be empty");

         students[_studentId] = Student(_name, true, 0);
         totalStudents++;

         emit StudentRegistered(_studentId, _name);
     }

     // 3. TEACHER AUTHORISATION
     mapping(address => bool) public authorizedTeachers;

     event TeacherAuthorized(address indexed teacher);
     event TeacherRevoked(address indexed teacher);

     function authorizeTeacher(address _teacher)
         public onlyAdmin
     {
         require(_teacher != address(0), "Invalid address");
         require(!authorizedTeachers[_teacher], "Already authorized");

         authorizedTeachers[_teacher] = true;
         emit TeacherAuthorized(_teacher);
     }

     function revokeTeacher(address _teacher)
         public onlyAdmin
     {
         require(authorizedTeachers[_teacher], "Not authorized");

         authorizedTeachers[_teacher] = false;
         emit TeacherRevoked(_teacher);
     }

     // 4. CLASS SESSION MANAGEMENT
     struct Session {
         uint256 sessionId;
         string subject;
         uint256 classDate;
         address createdBy;
         bool exists;
     }

     mapping(uint256 => Session) public sessions;
     uint256 public totalSessions;

     event SessionCreated(
         uint256 indexed sessionId,
         string subject,
         uint256 classDate,
         address indexed teacher
     );

     function createSession(
         uint256 _sessionId,
         string memory _subject,
         uint256 _classDate
     ) public onlyTeacher {

         require(_sessionId > 0, "Invalid session ID");
         require(!sessions[_sessionId].exists, "Session already exists");
         require(bytes(_subject).length > 0, "Subject required");
         require(_classDate > 0, "Invalid date");

         sessions[_sessionId] = Session(
             _sessionId,
             _subject,
             _classDate,
             msg.sender,
             true
         );

         totalSessions++;

         emit SessionCreated(
             _sessionId,
             _subject,
             _classDate,
             msg.sender
         );
     }

     // 5. ATTENDANCE RECORDS
     struct Attendance {
         bool marked;
         bool present;
         address markedBy;
         uint256 lastUpdated;
     }

     mapping(uint256 => mapping(uint256 => Attendance))
         private attendanceRecords;

     event AttendanceMarked(
         uint256 indexed studentId,
         uint256 indexed sessionId,
         bool present,
         address indexed teacher
     );

     event AttendanceCorrected(
         uint256 indexed studentId,
         uint256 indexed sessionId,
         bool oldStatus,
         bool newStatus,
         address teacher,
         uint256 timestamp
     );

     function markAttendance(
         uint256 _studentId,
         uint256 _sessionId,
         bool _present
     ) public onlyTeacher {

         require(students[_studentId].registered, "Student not registered");
         require(sessions[_sessionId].exists, "Session does not exist");

         Attendance storage record =
             attendanceRecords[_studentId][_sessionId];

         require(!record.marked, "Attendance already marked");

         record.marked = true;
         record.present = _present;
         record.markedBy = msg.sender;
         record.lastUpdated = block.timestamp;

         if (_present) {
             students[_studentId].presentCount++;
         }

         emit AttendanceMarked(
             _studentId,
             _sessionId,
             _present,
             msg.sender
         );
     }

     // 6. ATTENDANCE CORRECTION WITH AUDIT LOG
     function correctAttendance(
         uint256 _studentId,
         uint256 _sessionId,
         bool _newStatus
     ) public onlyTeacher {

         Attendance storage record =
             attendanceRecords[_studentId][_sessionId];

         require(record.marked, "Attendance not yet marked");
         require(record.present != _newStatus, "Status already same");

         bool oldStatus = record.present;

         if (oldStatus && !_newStatus) {
             students[_studentId].presentCount--;
         } else if (!oldStatus && _newStatus) {
             students[_studentId].presentCount++;
         }

         record.present = _newStatus;
         record.markedBy = msg.sender;
         record.lastUpdated = block.timestamp;

         emit AttendanceCorrected(
             _studentId,
             _sessionId,
             oldStatus,
             _newStatus,
             msg.sender,
             block.timestamp
         );
     }

     // 7. VIEW ATTENDANCE
     function getAttendance(
         uint256 _studentId,
         uint256 _sessionId
     ) public view returns (
         bool marked,
         bool present,
         address teacher,
         uint256 lastUpdated
     ) {
         require(students[_studentId].registered, "Student not registered");
         require(sessions[_sessionId].exists, "Session does not exist");

         Attendance memory record =
             attendanceRecords[_studentId][_sessionId];

         return (
             record.marked,
             record.present,
             record.markedBy,
             record.lastUpdated
         );
     }

     // 8. CALCULATE ATTENDANCE PERCENTAGE
     function getAttendancePercentage(uint256 _studentId)
         public view returns (uint256)
     {
         require(students[_studentId].registered, "Student not registered");

         if (totalSessions == 0) {
             return 0;
         }

         return (
             students[_studentId].presentCount * 100
         ) / totalSessions;
     }

     // 9. CHECK 75% ATTENDANCE ELIGIBILITY
     function checkEligibility(uint256 _studentId)
         public view returns (
             uint256 percentage,
             bool eligible,
             string memory message
         )
     {
         require(students[_studentId].registered, "Student not registered");

         if (totalSessions == 0) {
             return (0, false, "No sessions conducted yet");
         }

         uint256 percentageValue =
             getAttendancePercentage(_studentId);

         if (students[_studentId].presentCount * 100
             >= 75 * totalSessions) {
             return (
                 percentageValue,
                 true,
                 "Eligible: Attendance is at least 75%"
             );
         } else {
             return (
                 percentageValue,
                 false,
                 "WARNING: Attendance below 75%"
             );
         }
     }

     // 10. GET STUDENT SUMMARY
     function getStudentSummary(uint256 _studentId)
         public view returns (
             string memory name,
             uint256 attended,
             uint256 totalClasses,
             uint256 percentage
         )
     {
         require(students[_studentId].registered, "Student not registered");

         Student memory s = students[_studentId];

         return (
             s.name,
             s.presentCount,
             totalSessions,
             getAttendancePercentage(_studentId)
         );
     }
 }