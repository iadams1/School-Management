# _**School Management Database System**_
> **Last Updated:** May 6th, 2025

## Project Summary
School Management Database System is a comprehensive database application designed to manage and organize operations for a multi-campus educational institution. The system combines a MySQL relational database with Python-based automation tools to manage student records, staff information, academic tracking, financial operations, security, and administrative reporting.

### Core Elements
- Campus Management: Records information for multiple school campuses, including locations, contact details, budgets, expenses, facilities, and events
- Student Information Management: Maintains student profiles, enrollment records, attendance history, payments, guardian relationships, and academic progress
- Academic Management: Stores courses, prerequisites, class sections, instructors, enrollment history, and grade reporting
- Staff & Employment Management: Tracks staff members, roles, qualifications, employment history, and campus assignments
- Financial Management: Manages student payments, campus expenses, budget tracking, and financial reporting
- Facility Management: Tracks campus facilities, usage schedules, and maintenance records
- User Authentication & Authorization: Provides secure user accounts with role-based access control for administrators, teachers, and clerks
- Data Security & Auditing: Protects sensitive information through encryption and tracks database activity using audit logs
- Python Automation Tools: Includes Python utilities that extend database functionality:
  - Password Hashing Utility: Uses bcrypt encryption to securely hash and protect user passwords
  - School Report Generator: Automates report creation by retrieving and analyzing database records
  - Student Monitoring System: Provides tools for tracking and analyzing student-related information

#### Key Features
- Normalized relational database schema designed using Third Normal Form (3NF) principles to maintain data integrity
- Role-based access control (RBAC) implemented using MySQL roles for Admin, Teacher, and Clerk users
- Encrypted storage for sensitive information including contact details, passwords, and salary records
- Database views created for role-specific access and administrative reporting
- Stored procedures developed for automated user creation and student academic reporting
- Triggers implemented for:
  - Audit logging of database changes including INSERT, UPDATE, and DELETE operations
  - Preventing scheduling conflicts between instructors and class sections
  - Maintaining data consistency across related records
- Python integration for database automation and security:
  - Implemented bcrypt-based password hashing for secure credential management
  - Developed automated reporting tools for administrative insights
  - Created student monitoring utilities for analyzing academic data

Custom SQL queries and reports were developed to provide insights such as:
  - Student academic performance summaries
  - Campus fee collection reports
  - Staff attendance analysis
  - Monthly and annual budget tracking
  - Student grade reports
  - Database activity and audit history tracking

> This was a project assigned specifically to me from my professor for a more advanced experience due to being in the Honors Program section of the Database Design & Implementation course. The project focused on applying database design principles, security practices, SQL development, and Python automation techniques to create a realistic school management system capable of supporting multiple user roles and administrative operations.

---

### Coding Languages Used:
- **MySQL / SQL** (Database Architecture, Queries, Views, Stored Procedures, Triggers, Security Management)
- **Python** (Database Automation, Report Generation, Password Security, Data Monitoring)

---

## System Architecture

The system consists of three primary layers:

### Database Layer
- MySQL relational database containing student, staff, academic, financial, and facility information
- Implements normalization, primary/foreign key relationships, constraints, views, stored procedures, and triggers

### Security Layer
- Role-based access control for Admin, Teacher, and Clerk users
- Encrypted storage for sensitive data
- Audit logging system for tracking database changes

### Application Layer
- Python utilities connected to the database to provide additional functionality:
  - Secure password management using bcrypt hashing
  - Automated school report generation
  - Student record monitoring and analysis

---

## Getting Started

Within this repository includes the following files from the project:
- Screenshot of the project's Entity Relationship Diagram (ERD) designed in 3NF
- Complete SQL database creation and implementation script
- Python utility files for security, reporting, and student monitoring

To run this project locally, follow the instructions below. The project was developed using MySQL Workbench and Python.

### Prerequisites

Ensure that **MySQL** and **MySQL Workbench** are installed on your system. If not, refer to the [official MySQL installation guide](https://www.mysql.com/downloads/).

Python is also required to run the included database utility scripts.

Required Python package:
- bcrypt

## Usage

**School Management Database System** could be used by educational institutions, private schools, or organizations managing multiple campuses and student populations. The system helps improve:

- Data organization through a centralized relational database
- Security through encryption and role-based permissions
- Administrative decision-making through automated reports
- Operational efficiency through database automation
- Data accuracy through validation rules and database constraints

---

## Contact

### Created by: Isaiah Adams
>LinkedIn: www.linkedin.com/in/isaiah-j-adams
>
>Email: IJAdams1@outlook.com

Hi there! I'm Isaiah, a Graduate at Arkansas Tech University with Bachelors of Science in Computer Science. My passion lies in developing meaningful software and database solutions that connect technology with real-world problems. Projects like this one allow me to apply database design, software development, automation, and security concepts in a practical environment while continuing to grow as a software engineer.

Feel free to reach out—I’d love to connect or answer any questions you may have.
