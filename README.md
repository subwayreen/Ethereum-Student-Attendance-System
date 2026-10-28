# Ethereum-Student-Attendance-System
A blockchain-based student attendance management system developed using Solidity and Remix IDE
# Ethereum-Based Student Attendance Management System

## Project Overview

The Ethereum-Based Student Attendance Management System is a blockchain-based college project developed using Solidity and Remix IDE.

The project aims to provide a transparent, secure and auditable method for managing student attendance using Ethereum smart contracts.

## Technologies Used

- **Solidity:** Smart contract programming language
- **Ethereum:** Blockchain platform
- **Remix IDE:** Development and testing environment
- **Remix VM:** Simulated Ethereum blockchain for executing smart contracts

## Features

1. **Student Registration:** Admin can register students using unique student IDs.
2. **Teacher Authorisation:** Only admin-approved teachers can manage attendance.
3. **Session Management:** Teachers can create class sessions with unique IDs and dates.
4. **Duplicate Prevention:** The smart contract prevents attendance from being marked twice for the same student and session.
5. **Attendance Percentage:** Automatically calculates each student's attendance percentage.
6. **75% Attendance Warning:** Identifies students who do not meet the minimum attendance requirement.
7. **Attendance Correction:** Authorised teachers can correct attendance mistakes.
8. **Blockchain Event Logs:** Records attendance and correction events for auditing.

## How to Run the Project

1. Open [Remix IDE](https://remix.ethereum.org).
2. Create a Solidity file named `StudentAttendance.sol`.
3. Copy the code from this repository into the file.
4. Select Solidity compiler version 0.8.20 or another compatible 0.8.x version.
5. Compile the smart contract.
6. Open **Deploy & Run Transactions**.
7. Select **Remix VM**.
8. Deploy the `StudentAttendance` contract.
9. Use the first account as the admin.
10. Register students and authorise another account as a teacher.
11. Switch to the authorised teacher account to create sessions and mark attendance.
12. Use the read functions to check attendance and eligibility.
13. Test duplicate prevention and correction functionality.
14. View event logs in the Remix terminal.

## Example Test Data

| Student ID | Name | Attendance | Percentage |
|---|---|---|---|
| 101 | Sabreen | 3/4 | 75% |
| 102 | Garv | 2/4 | 50% |
| 103 | Nandini | 4/4 | 100% |

These are example test values. Attendance changes when new sessions are created or records are corrected.

## Smart Contract Functions

- `registerStudent()` — Registers a student.
- `authorizeTeacher()` — Approves a teacher.
- `revokeTeacher()` — Removes a teacher's permission.
- `createSession()` — Creates a new class session.
- `markAttendance()` — Records attendance.
- `correctAttendance()` — Corrects an attendance entry.
- `getAttendance()` — Retrieves an attendance record.
- `getAttendancePercentage()` — Calculates attendance percentage.
- `checkEligibility()` — Checks the 75% requirement.
- `getStudentSummary()` — Displays a student's attendance summary.

## Security Features

- Role-based access control
- Duplicate attendance prevention
- Authorised attendance corrections
- Transaction event logs
- Unique student and session IDs

## Limitations

This is an educational prototype tested on Remix VM. Attendance is calculated across all created sessions, and the application does not currently provide a standalone frontend or database. Real university deployment would require stronger privacy protection, subject-wise attendance management and additional security testing.

## Future Enhancements

- Student and teacher dashboards
- QR-code-based attendance
- Subject-wise attendance reports
- Integration with a web frontend
- Automated attendance notifications
- Secure student identity management

## Conclusion

This project demonstrates how Ethereum smart contracts can be used to validate, record and audit student attendance while automating attendance calculations and eligibility checks.
