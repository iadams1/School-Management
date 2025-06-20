/*
	School Management Database System | Honors Project
    Database Design & Implementation COMS-3233-H01
    
    Start Date: 4/17/2025
	  Deadline: 5/6/2025
    
    Written by:
    Isaiah Adams
*/

drop database SchoolSystem;
create database SchoolSystem;
use SchoolSystem;

/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
																											SCHOOL SYSTEM DATABASE TABLE CREATIONS                                                                                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
create table Campuses (
	CampusID							int primary key not null auto_increment,
    CampusName							varchar(50) not null,
    Location							varchar(100) not null,
	CampusContact						varchar(50) not null,
    MonthlyBudget						decimal not null
);

create table Students (
	StudentID							int primary key not null auto_increment,
	StudentName							varchar(25),
	DateOfBirth							date not null,
    EnrollmentDate						date not null,
    PhoneNumber							varbinary(255) not null,
    Email								varbinary(255) not null
);

-- Allows Student IDs to start at 1000
alter table Students auto_increment = 1000;

create table SchoolRecords (
	SRecordsID 							int primary key not null auto_increment,
	CampusID							int not null,
	StudentID 							int not null,
    foreign key (CampusID) 				references Campuses (CampusID),
    foreign key (StudentID) 			references Students (StudentID)
);

create table Guardians (
	GuardianID 							int primary key not null auto_increment,
    FName								varchar(25) not null,
    LName								varchar(25) not null,
    PhoneNumber							varbinary(255) not null,
    Email								varbinary(255) not null
);

create table StudentGuardians (
	SGRecordID							int primary key not null auto_increment,
    StudentID							int not null,
    GuardianID							int not null,
    foreign key (GuardianID)			references Guardians (GuardianID),
    foreign key (StudentID)				references Students (StudentID)
);

-- Encrypt Salary Column
create table Staff (
	StaffID								int primary key not null auto_increment,
	StaffName 							varchar(50) not null,
    StaffRole							enum('Admin', 'Teacher', 'Clerk') not null,
    Qualifications						varchar(100) not null,
    PhoneNumber							varbinary(255) not null,
    Email								varbinary(255) not null
);

-- Encrypt ContactInfo Column
create table PersonContacts (
	ContactID							int primary key not null auto_increment,
    StaffID								int,
    GuardianID							int,
	StudentID							int,
    foreign key (StaffID)				references Staff (StaffID),
    foreign key (GuardianID)			references Guardians (GuardianID),
    foreign key (StudentID)				references Students (StudentID)
);

create table EmploymentHistory (
	EmploymentID						int primary key not null auto_increment,
    CampusID							int not null,
    StaffID								int not null,
    StartDate							date not null,
	endDate								date,
    Salary								varbinary(255) not null,
    foreign key (CampusID) 				references Campuses (CampusID),
    foreign key (StaffID)				references Staff (StaffID)
);

create table AttendanceRecords (
	AttendanceID						int primary key not null auto_increment,
    StaffID								int,
    StudentID							int,
    AttendanceDate						date not null,
    AttendanceStatus					enum('Present', 'Absent', 'Late') not null,
    foreign key (StaffID)				references Staff (StaffID),
    foreign key (StudentID)				references Students (StudentID)
);

create table StudentPayments (
	PaymentID							int primary key not null auto_increment,
    StudentID							int not null,
    PaymentDate							date not null,
    Amount								decimal not null,
    PaymentMode							enum('Cash', 'Card', 'Bank Transfer') not null,
    PaymentStatus						varchar(60) not null,
    foreign key (StudentID)				references Students (StudentID)
);

create table ExpenseTypes (
	ExpenseTypeID						int primary key not null auto_increment,
    ExpenseTypeName						varchar(50) not null unique
);

create table CampusExpenses (
	ExpenseID							int primary key not null auto_increment,
    CampusID							int not null,
    ExpenseTypeID						int not null,
    Amount								decimal(10,2) not null,
    ExpenseDate							date not null,
    foreign key (CampusID) 				references Campuses (CampusID),
    foreign key (ExpenseTypeID) 		references ExpenseTypes (ExpenseTypeID)
);

create table Courses (
	CourseID							int primary key not null auto_increment,
    CourseName							varchar(50) not null,
    CourseDescription 					text not null,
    CreditHours							int not null
);

alter table Courses auto_increment = 4000;

create table CoursePrerequisites (
	PCRecordID							int primary key not null auto_increment,
    CourseID							int not null,
	PrerequisiteID						int,
    foreign key (CourseID) 				references Courses (CourseID),
    foreign key (PrerequisiteID) 		references Courses (CourseID)
);

create table SectionTimes (
	SectionID							int primary key not null auto_increment,
    CampusID							int not null,
	CourseID							int not null,
	TeacherID							int not null, 
	ScheduleDay							enum('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') not null,
	ScheduleStartTime					time not null,
	ScheduleendTime						time not null,
    StartDate							date not null,
    EndDate								date not null,
    Semester							enum('Fall','Spring','Summer','Winter') not null,
	foreign key (CourseID) 				references Courses (CourseID),
    foreign key (CampusID) 				references Campuses (CampusID),
	foreign key (TeacherID)				references Staff (StaffID)
);

create table StudentClassHistory (
	HistoryID							int primary key not null auto_increment,
    SectionID							int not null,
    StudentID							int not null,
    foreign key (StudentID)				references Students (StudentID),
    foreign key (SectionID)				references SectionTimes (SectionID)
);

create table GradeReports (
	GradeID								int primary key not null auto_increment, 
	StudentID							int not null,
    SectionID							int not null, 
	GradeType							enum('Assignment', 'Quiz', 'Exam', 'Test', 'Bonus') not null,
    CourseworkName						varchar(50) not null,
    Grade 								decimal not null,
    foreign key (StudentID)				references Students (StudentID),
    foreign key (SectionID)				references SectionTimes (SectionID)
);

create table EventTypes (
    EventTypeID        					int primary key auto_increment,
    EventTypeName     					varchar(50) not null
);

create table SchoolEvents (
    EventID            					int primary key auto_increment,
    CampusID           					int not null,
    EventTypeID        					int not null,
    EventName          					varchar(100) not null,
    EventDate          					date not null,
    EventTime         					time not null,
    EventDescription        			text,
    foreign key (CampusID) 				references Campuses (CampusID),
    foreign key (EventTypeID) 			references EventTypes (EventTypeID)
);

create table Facilities (
    FacilityID         					int primary key auto_increment,
    CampusID           					int not null,
    FacilityName       					varchar(50) not null,
    FacilityType       					enum('Classroom', 'Lab', 'Sports Ground', 'Auditorium') not null,
    foreign key (CampusID) 				references Campuses (CampusID)
);

create table FacilityUsage (
    UsageID            					int primary key auto_increment,
    FacilityID         					int not null,
    UsageDate          					date not null,
    StartTime          					time,
    endTime            					time,
    Purpose            					varchar(100),
    foreign key (FacilityID) 			references Facilities(FacilityID)
);

create table FacilityMaintenance (
    MaintenanceID      					int primary key auto_increment,
    FacilityID         					int not null,
    MaintenanceDate    					date not null,
    Description        					text,
    MaintenanceCost    					decimal(10,2),
    foreign key (FacilityID) 			references Facilities (FacilityID)
);

 -- Encrypt Password Column
 create table Users (
	UserID								int primary key not null auto_increment,
    StaffID								int not null,
    Username							varchar(50) not null unique, -- matchs MySQL login (admin@localhost, etc.)
    UserPassword						char(60) not null,
    foreign key (StaffID)				references Staff (StaffID)
 );
 
 -- Allows User IDs to start at 10
alter table Users auto_increment = 10;
 
 create table AuditLogs (
	AuditID								int primary key not null auto_increment,
    UserID								int not null,
    Actions								enum('Insert', 'Update', 'Delete') not null,
    TableName							varchar(50) not null,
    UserTimestamp						timestamp not null default current_timestamp,
    Details								text not null,
    foreign key (UserID)				references Users (UserID)
 );

 /* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
																						                       SYSTEM FEATURES CREATIONS                                                                                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
 
-- Set encryption keys
set @key_phone := 'key_phone_123';
set @key_email := 'key_email_456';
set @key_salary := 'key_salary_789';

-- Creates roles for School System
drop role 'Admin', 'Clerk', 'Teacher';
create role 'Admin', 'Clerk', 'Teacher';

-- Gives all permissions to Admin role
grant all privileges on SchoolSystems.* to 'Admin';

 -- Adds system (root) into the table 
insert into Staff (StaffID, StaffName, StaffRole, Qualifications, PhoneNumber, Email)
	values (1, 'System Account', 'Admin', 'System Reserved', 'N/A', 'N/A');

insert into Users (UserID, StaffID, Username, UserPassword)
	values (1, 1, 'System', 'dummy_encrypted_password_hash');
    
-- Allows Staff IDs to start at 2000
alter table Staff auto_increment = 2000;

-- View creation for AuditLog viewing for specific userIDs
create view MyAuditLogs as
	select * from AuditLogs
	where UserID = (
		select UserID from Users
        where Username = current_user()
    );

grant select on MyAuditLogs to 'Teacher';
grant select on MyAuditLogs to 'Clerk';

-- Creations views for Teacher role
create or replace view TeacherGradeView as 
	select g.GradeID, g.StudentID, s.StudentName, g.SectionID, g.CourseworkName, g.Grade, g.GradeType from GradeReports g
    join students s 
    on g.StudentID = s.StudentID
    join sectiontimes st 
    on g.SectionID = st.SectionID
    join staff t
    on st.TeacherID = t.StaffID
    join Users u
    on t.StaffID = u.StaffID
    where current_user() = u.Username;
    
 create view TeacherClassList as
	select st.SectionID, cl.CourseName, s.StudentID, s.StudentName from SectionTimes st
    join Courses cl 
    on st.CourseID = cl.CourseID
    join GradeReports gr 
    on  st.SectionID = gr.SectionID
    join StudentClassHistory sch
    on st.SectionID = sch.SectionID
    join Students s
    on sch.StudentID = s.StudentID
    join Staff t 
    on st.TeacherID = t.StaffID
    join Users u
    on u.StaffID = t.StaffID
    where current_user() = u.Username;
    
create or replace view TeacherAttendanceView as 
	select a.AttendanceID, a.StudentID, s.StudentName, a.AttendanceDate, a.AttendanceStatus, a.StaffID as RecordedBy from AttendanceRecords a
    join Students s
    on a.StudentID = s.StudentID
    join SectionTimes st
    on a.StudentID in (
		select gr.StudentID from GradeReports gr
        where gr.SectionID = st.SectionID
    )
    join Staff t
    on st.TeacherID = t.StaffID
    join Users u
    on u.StaffID = t.StaffID
    where current_user() = u.Username;
    
grant select, update on TeacherGradeView to 'Teacher';
grant select, update on TeacherAttendanceView to 'Teacher';
grant select on TeacherClassList to 'Teacher';

-- Creation views for Clerk role
create view ClerkStudentRoster as 
	select s.StudentID, s.StudentName, s.EnrollmentDate, sr.CampusID, c.CampusName from Students s
    join SchoolRecords sr
    on s.StudentID = sr.StudentID
    join Campuses c 
    on sr.CampusID = c.CampusID;
    
create view ClerkFeeSummary as 
	select c.CampusName, sum(sp.Amount) as TotalCollected, month(sp.PaymentDate) as Month, year(sp.PaymentDate) from StudentPayments sp
    join Students s 
    on sp.StudentID = s.StudentID
    join SchoolRecords sr
    on s.StudentID = sr.StudentID
    join Campuses c 
    on sr.CampusID = c.CampusID
	group by c.CampusName, month(sp.PaymentDate), year(sp.PaymentDate);
    
grant select on ClerkFeeSummary to 'Clerk';
grant select, insert on ClerkStudentRoster to 'Clerk';

-- Creation views for Budget Module 
create view MonthlyBudgetModule as 
	select c.CampusID, c.CampusName, c.MonthlyBudget, coalesce(sum(e.Amount), 0) as 'Actual Expenses', 
    (c.MonthlyBudget - coalesce(sum(e.Amount), 0)) as 'Remaining Budget', month(e.ExpenseDate) as BudgetMonth, year(e.ExpenseDate) as BudgetYear from Campuses c
    left join CampusExpenses e
    on c.CampusID = e.CampusID
    and month(e.ExpenseDate) = current_date()
    and year(e.ExpenseDate) = current_date()
	group by c.CampusID;
    
create view AnnualBudgetModule as 
	select c.CampusID, c.CampusName, c.MonthlyBudget * 12 as AnnualBudget, coalesce(sum(e.Amount), 0) as 'Actual Expenses', 
    ((c.MonthlyBudget * 12) - coalesce(sum(e.Amount), 0)) as 'Remaining Budget', year(e.ExpenseDate) as BudgetYear from Campuses c
    left join CampusExpenses e
    on c.CampusID = e.CampusID
    and year(e.ExpenseDate) = current_date()
	group by c.CampusID;
    
grant select on AnnualBudgetModule to 'Clerk';
grant select on MonthlyBudgetModule to 'Clerk';

-- Views for Generating reports
create view CampusFeeSummary as
	select c.CampusID, c.CampusName, coalesce(sum(p.Amount), 0) as TotalFeesCollected from Campuses c
	join SchoolRecords sr 
    on c.CampusID = sr.CampusID
	join StudentPayments p 
    on sr.StudentID = p.StudentID
	group by c.CampusID;

create view StaffAttendanceSummary as
	select a.StaffID, st.StaffName, count(*) as TotalDays,
    sum(case when a.AttendanceStatus = 'Present' then 1 else 0 end) as PresentDays,
    sum(case when a.AttendanceStatus = 'Absent' then 1 else 0 end) as AbsentDays,
    sum(case when a.AttendanceStatus = 'Late' then 1 else 0 end) as LateDays
	from AttendanceRecords a
	join Staff st 
    on a.StaffID = st.StaffID
	where a.StaffID is not null
	group by a.StaffID;
    
create view StudentsPerformanceSummary as
	select g.StudentID, s.StudentName, round(avg(g.Grade), 2) as AverageGrade, count(*) as TotalAssignments
	from GradeReports g
	join Students s on g.StudentID = s.StudentID
	group by g.StudentID;

grant select on CampusFeeSummary to 'Admin';
grant select on CampusFeeSummary to 'Clerk';
grant select on StaffAttendanceSummary to 'Admin';
grant select on StaffAttendanceSummary to 'Clerk';
grant select on StudentsPerformanceSummary to 'Admin';
grant select on StudentsPerformanceSummary to 'Clerk';

-- Procedure for adding roles, application user and mysql user when a new staff is added
DELIMITER //
create procedure CreateNewUser (in p_StaffID int, in p_Username varchar(100), in p_UserPassword char(60))
begin
	declare role varchar(20);
    
    -- Inserts the new staff into users 
    insert into Users (StaffID, Username, UserPassword)
	values (p_StaffID, p_Username, p_UserPassword);

    select StaffRole into role from Staff
    where StaffID = p_StaffID;
    
    set @create_sql = concat('create user ''', p_Username, '''@''localhost'' identified by ''', p_UserPassword, ''';');
	prepare create_stmt from @create_sql;
	execute create_stmt;
	deallocate prepare create_stmt;
    
    if role = 'Admin' then 
		set @assign_sql = concat('grant `Admin` to ''', p_Username, '''@''localhost'';');
        
	elseif role = 'Teacher' then
		set @assign_sql = concat('grant `Teacher` to ''', p_Username, '''@''localhost'';');
        
	elseif role = 'Clerk' then
		set @assign_sql = concat('grant `Clerk` to ''', p_Username, '''@''localhost'';');
        
    end if;
    
    prepare stmt from @assign_sql;
    execute stmt;
    deallocate prepare stmt;
    
end//
DELIMITER ;

-- Procedure to get a certain students grade in all classes
DELIMITER //
create procedure StudentFullClassReport (in g_StudentID int)
begin
	select g.SectionID ,g.StudentID, s.StudentName, round(avg(g.Grade), 2) as AverageGrade, count(*) as TotalAssignments
	from GradeReports g
	join Students s on g.StudentID = s.StudentID
    where g.StudentID = g_StudentID
	group by g.StudentID;
end // 
DELIMITER ;

-- Procedure to get a certain students grade in all classes
DELIMITER //
create procedure StudentClassSectionReport (in g_StudentID int, in g_SectionID int)
begin
	select g.SectionID, g.StudentID, s.StudentName, round(avg(g.Grade), 2) as AverageGrade, count(*) as TotalAssignments
	from GradeReports g
	join Students s on g.StudentID = s.StudentID
    where g.StudentID = g_StudentID and g.SectionID = g_SectionID
	group by g.StudentID;
end // 
DELIMITER ;

/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
																						                       SYSTEM TRIGGERS CREATIONS                                                                                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

-- Trigger for section time insertions
DELIMITER //
create trigger PreventScheduleConflict_Insert before insert on SectionTimes
for each row begin
	declare conflict int; 
    
	select count(*) into conflict from SectionTimes
    where TeacherID = new.TeacherID 
		and CampusID = new.CampusID
        and ScheduleDay = new.ScheduleDay
		and new.ScheduleStartTime < ScheduleEndTime 
		and new.ScheduleendTime > ScheduleStartTime;

	if conflict > 0 then
		signal sqlstate '45000'
        set message_text = "Schedule conflict: A teacher already has a class during this time.";
	end if;
    
end//
DELIMITER ;

-- Trigger for section time updates
DELIMITER //
create trigger PreventScheduleConflict_Update before update on SectionTimes
for each row begin
	declare conflict int; 
    
	select count(*) into conflict from SectionTimes
    where TeacherID = new.TeacherID 
		and SectionID != old.SectionID
        and ScheduleDay = new.ScheduleDay
        and CampusID = new.CampusID
		and new.ScheduleStartTime < ScheduleendTime 
		and new.ScheduleendTime > ScheduleStartTime;

	if concflict > 0 then
		signal sqlstate '45000'
        set message_text = "Schedule conflict: A teacher already has a class during this updated time.";
	end if;
    
end//
DELIMITER ;


-- --------------------------------------------------------------------------------------------------------- TRIGGERS FOR AUDIT LOGGING ---------------------------------------------------------------------------------------------------------------------------
-- Students Table (Inserts, Updates & Deletions) 
DELIMITER $$
create trigger Audit_Students_Delete after delete on Students
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Students', concat('Deleted student: ', old.StudentName, ', ID: ', old.StudentID));
end
$$

create trigger Audit_Students_Update after update on Students
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Students', concat('Updated Student: ', new.StudentName, ', ID: ', new.StudentID));
end
$$

create trigger Audit_Students_Insert after insert on Students
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Students', concat('Added Student: ', new.StudentName, ', ID: ', new.StudentID));
end
$$
DELIMITER ;

-- Campuses Table (Inserts, Updates & Deletions) 
DELIMITER $$
create trigger Audit_Campuses_Delete after delete on Campuses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Campuses', concat('Deleted Campus: ', old.CampusName, ', ID: ', old.CampusID));
end
$$

create trigger Audit_Campuses_Update after update on Campuses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Campuses', concat('Updated Campus: ', new.CampusName, ', ID: ', new.CampusID));
end
$$

create trigger Audit_Campuses_Insert after insert on Campuses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Campuses', concat('Added Campus: ', new.CampusName, ', ID: ', new.CampusID));
end
$$
DELIMITER ;

-- SchoolRecords Table (Inserts, Updates & Deletions) 
DELIMITER $$
create trigger Audit_SchoolRecords_Delete after delete on SchoolRecords
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'SchoolRecords', concat('Removed school record: Student ID: ', old.StudentID, ', Campus ID: ', old.CampusID));
end
$$

create trigger Audit_SchoolRecords_Update after update on SchoolRecords
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'SchoolRecords', concat('Updated Campus connection for Student ID ', new.StudentID));
end
$$

create trigger Audit_SchoolRecords_Insert after insert on SchoolRecords
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'SchoolRecords', concat('assigned Student ID ', new.StudentID, ' to Campus ID ', new.CampusID));
end
$$
DELIMITER ;

-- StudentGuardians Table (Inserts, Updates & Delections)
DELIMITER $$
create trigger Audit_StudentGuardians_Delete after delete on StudentGuardians
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'StudentGuardians', concat('Removed Guardian ID ', old.GuardianID, ' from Student ID ', old.StudentID));
end
$$

create trigger Audit_StudentGuardians_Update after update on StudentGuardians
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'StudentGuardians', concat('Updated guardian link for Student ID: ', new.StudentID, ', new Guardian ID: ', new.GuardianID));
end
$$

create trigger Audit_StudentGuardians_Insert after insert on StudentGuardians
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'StudentGuardians', concat('Linked Guardian ID ', new.GuardianID, ' to Student ID ', new.StudentID));
end
$$
DELIMITER ;

-- Guardians Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_Guardians_Delete after delete on Guardians
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Guardians', concat('Deleted Guardian: ', old.FName, ' ', old.LName, ', ID: ', old.GuardianID));
end
$$

create trigger Audit_Guardians_Update after update on Guardians
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Guardians', concat('Updated Guardian ID: ', new.GuardianID));
end
$$

create trigger Audit_Guardians_Insert after insert on Guardians
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Guardians', concat('Added Guardian: ', new.FName, ' ', new.LName, ' ID: ', new.GuardianID));
end
$$
DELIMITER ;

-- Student Payments Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_StudentPayments_Delete after delete on StudentPayments
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'StudentPayments', concat('Deleted payment of $', old.Amount, ' for Student ID ', old.StudentID, ' on ', old.PaymentDate));
end
$$

create trigger Audit_StudentPayments_Update after update on StudentPayments
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'StudentPayments', concat('Updated Payment ID: ', new.PaymentID));
end
$$

create trigger Audit_StudentPayments_Insert after insert on StudentPayments
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'StudentPayments', concat('Recorded payment of $', new.Amount, ' for Student ID ', new.StudentID, ' on ', new.PaymentDate));
end
$$
DELIMITER ;

-- Staff Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_Staff_Delete after delete on Staff
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Staff', concat('Deleted Staff: ', old.StaffName, ', role: ', old.StaffRole));
end
$$

create trigger Audit_Staff_Update after update on Staff
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Staff', concat('Updated Staff ID: ', new.StaffID));
end
$$

create trigger Audit_Staff_Insert after insert on Staff
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Staff', concat('Added Staff: ', new.StaffName, ', role: ', new.StaffRole));
end
$$
DELIMITER ;

-- Employment History Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_EmploymentHistory_Delete after delete on EmploymentHistory
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'EmploymentHistory', concat('Removed employment record: Staff ID ', old.StaffID, ' from Campus ID ', old.CampusID));
end
$$

create trigger Audit_EmploymentHistory_Update after update on EmploymentHistory
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'EmploymentHistory', concat('Updated employment record ID: ', new.EmploymentID));
end
$$

create trigger Audit_EmploymentHistory_Insert after insert on EmploymentHistory
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'EmploymentHistory', concat('assigned Staff ID ', new.StaffID, ' to Campus ID ', new.CampusID, ' starting ', new.StartDate));
end
$$
DELIMITER ;

-- Employment History Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_PersonContacts_Delete after delete on PersonContacts
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'PersonContacts', concat('Deleted Contact ID: ', old.ContactID));
end
$$

create trigger Audit_PersonContacts_Update after update on PersonContacts
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'PersonContacts', concat('Contact Contact ID: ', new.ContactID));
end
$$

create trigger Audit_PersonContacts_Insert after insert on PersonContacts
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'PersonContacts', concat('Added Contact ID: ', new.ContactID, 
			ifnull(concat(' (StudentID: ', new.StudentID, ')'), ''),
			ifnull(concat(' (StaffID: ', new.StaffID, ')'), ''),
			ifnull(concat(' (GuardianID: ', new.GuardianID, ')'), '')));
end 
$$
DELIMITER ;

-- Attendance Records Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_AttendanceRecords_Delete after delete on AttendanceRecords
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'AttendanceRecords', concat('Deleted attendance record for ',
			ifnull(concat('Student ID ', old.StudentID), concat('Staff ID ', old.StaffID)), ' on ', old.AttendanceDate));
end
$$

create trigger Audit_AttendanceRecords_Update after update on AttendanceRecords
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'AttendanceRecords', concat('Updated attendance record ID: ', new.AttendanceID));
end
$$

create trigger Audit_AttendanceRecords_Insert after insert on AttendanceRecords
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'AttendanceRecords', concat('Marked ',
			ifnull(concat('Student ID ', new.StudentID), concat('Staff ID ', new.StaffID)), ' as ', new.AttendanceStatus, ' on ', new.AttendanceDate));
end
$$
DELIMITER ;

-- Users Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_Users_Delete after delete on Users
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Users', concat('Deleted user: ', old.Username, ' for Staff ID ', old.StaffID));
end
$$

create trigger Audit_Users_Update after update on Users
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Users', concat('Updated user account: ', new.Username));
end
$$

create trigger Audit_Users_Insert after insert on Users
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Users', concat('Created user: ', new.Username, ' for Staff ID: ', new.StaffID));
end
$$
DELIMITER ;

-- Campus Expenses Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_CampusExpenses_Delete after delete on CampusExpenses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'CampusExpenses', concat('Deleted expense of $', old.Amount, ' for Campus ID ', old.CampusID, ' on ', old.ExpenseDate));
end
$$

create trigger Audit_CampusExpenses_Update after update on CampusExpenses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'CampusExpenses', concat('Updated expense record ID: ', new.ExpenseID));
end
$$

create trigger Audit_CampusExpenses_Insert after insert on CampusExpenses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'CampusExpenses', concat('Logged expense of $', new.Amount, ' for Campus ID ', new.CampusID, ' (type ID: ', new.ExpenseTypeID, ') on ', new.ExpenseDate));
end
$$
DELIMITER ;

-- Expense Types Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_ExpenseTypes_Delete after delete on ExpenseTypes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'ExpenseTypes', concat('Deleted expense type: ', old.ExpenseTypeName, ' (ID: ', old.ExpenseTypeID, ')'));
end
$$

create trigger Audit_ExpenseTypes_Update after update on ExpenseTypes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'ExpenseTypes', concat('Updated expense type ID: ', new.ExpenseTypeID));
end
$$

create trigger Audit_ExpenseTypes_Insert after insert on ExpenseTypes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'ExpenseTypes', concat('Added new expense type: ', new.ExpenseTypeName));
end
$$
DELIMITER ;

-- School Events Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_SchoolEvents_Delete after delete on SchoolEvents
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'SchoolEvents', concat('Deleted event: "', old.EventName, '" from Campus ID ', old.CampusID));
end
$$

create trigger Audit_SchoolEvents_Update after update on SchoolEvents
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'SchoolEvents', concat('Updated event ID: ', new.EventID));
end
$$

create trigger Audit_SchoolEvents_Insert after insert on SchoolEvents
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'SchoolEvents', concat('Created event: "', new.EventName, '" at Campus ID ', new.CampusID, ' on ', new.EventDate));
end
$$
DELIMITER ;

-- Event Types Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_EventTypes_Delete after delete on EventTypes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'EventTypes', concat('Deleted event type: ', old.EventTypeName, ' (ID: ', old.EventTypeID, ')'));
end
$$

create trigger Audit_EventTypes_Update after update on EventTypes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'EventTypes', concat('Updated event type ID: ', new.EventTypeID));
end
$$

create trigger Audit_EventTypes_Insert after insert on EventTypes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'EventTypes', concat('Added new event type: ', new.EventTypeName));
end
$$
DELIMITER ;

-- Facilities Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_Facilities_Delete after delete on Facilities
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Facilities', concat('Deleted facility: "', old.FacilityName, '" (ID: ', old.FacilityID, ') at Campus ID ', old.CampusID));
end
$$

create trigger Audit_Facilities_Update after update on Facilities
for each row begin
	declare userID int;
    
   if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Facilities', concat('Updated facility ID: ', new.FacilityID));
end
$$

create trigger Audit_Facilities_Insert after insert on Facilities
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Facilities', concat('Added facility: "', new.FacilityName, '" (Type: ', new.FacilityType, ') at Campus ID ', new.CampusID));
end
$$
DELIMITER ;

-- Facility Usage Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_FacilityUsage_Delete after delete on FacilityUsage
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'FacilityUsage', concat('Deleted usage record for Dacility ID ', old.FacilityID, ' on ', old.UsageDate));
end
$$

create trigger Audit_FacilityUsage_Update after update on FacilityUsage
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'FacilityUsage', concat('Updated usage record ID: ', new.UsageID));
end
$$

create trigger Audit_FacilityUsage_Insert after insert on FacilityUsage
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'FacilityUsage', concat('Scheduled facility ID ', new.FacilityID, ' on ', new.UsageDate, ' from ', coalesce(new.StartTime, 'N/A'), ' to ', coalesce(new.endTime, 'N/A'), ' for "', new.Purpose, '"'));
end
$$
DELIMITER ;

-- Facility Maintenance Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_FacilityMaintenance_Delete after delete on FacilityMaintenance
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'FacilityMaintenance', concat('Deleted maintenance for Facility ID ', old.FacilityID, ' on ', old.MaintenanceDate, ', cost: $', old.MaintenanceCost));
end
$$

create trigger Audit_FacilityMaintenance_Update after update on FacilityMaintenance
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'FacilityMaintenance', concat('Updated maintenance record ID: ', new.MaintenanceID));
end
$$

create trigger Audit_FacilityMaintenance_Insert after insert on FacilityMaintenance
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'FacilityMaintenance', concat('Logged maintenance for Facility ID ', new.FacilityID, ' on ', new.MaintenanceDate, ', cost: $', new.MaintenanceCost));
end
$$
DELIMITER ;

-- Courses Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_Courses_Delete after delete on Courses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'Courses', concat('Deleted course: "', old.CourseName, '", ID: ', old.CourseID));
end
$$

create trigger Audit_Courses_Update after update on Courses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'Courses', concat('Updated Course ID: ', new.CourseID));
end
$$

create trigger Audit_Courses_Insert after insert on Courses
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'Courses', concat('Added course: "', new.CourseName, '", ID: ', new.CourseID));
end
$$
DELIMITER ;

-- Course Prerequisites Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_CoursePrerequisites_Delete after delete on CoursePrerequisites
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'CoursePrerequisites', concat('Removed prerequisite ID: Course ID ', old.CourseID, ' required Course ID ', old.PrerequisiteID));
end
$$

create trigger Audit_CoursePrerequisites_Update after update on CoursePrerequisites
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'CoursePrerequisites', concat('Updated Prerequisite ID: ', new.PCRecordID));
end
$$

create trigger Audit_CoursePrerequisites_Insert after insert on CoursePrerequisites
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    if new.PrerequisiteID is null then
		insert into AuditLogs (UserID, Actions, TableName, Details) 
		values (userID, 'Insert', 'CoursePrerequisites', concat('Set prerequisite: Course ID ', new.CourseID, ' has no prerequisite.'));
	else
		insert into AuditLogs (UserID, Actions, TableName, Details) 
		values (userID, 'Insert', 'CoursePrerequisites', concat('Set prerequisite: Course ID ', new.CourseID, ' requires Course ID ', new.PrerequisiteID));
    end if;
    
end
$$
DELIMITER ;

-- Section Times Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_SectionTimes_Delete after delete on SectionTimes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'SectionTimes', concat('Deleted Section ID: ', old.SectionID));
end
$$

create trigger Audit_SectionTimes_Update after update on SectionTimes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'SectionTimes', concat('Updated Section ID: ', new.SectionID));
end
$$

create trigger Audit_SectionTimes_Insert after insert on SectionTimes
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'SectionTimes', concat('Created section for Course ID ', new.CourseID, ' by Teacher ID ', new.TeacherID, ' on ', new.ScheduleDay, ' from ', new.ScheduleStartTime, ' to ', new.ScheduleendTime));
end
$$
DELIMITER ;

-- Grade Reports Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_GradeReports_Delete after delete on GradeReports
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'GradeReports', concat('Deleted grade record for Student ID ', old.StudentID, ' in Section ID ', old.SectionID));
end
$$

create trigger Audit_GradeReports_Update after update on GradeReports
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'GradeReports', concat('Updated Grade ID: ', new.GradeID));
end
$$

create trigger Audit_GradeReports_Insert after insert on GradeReports
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'GradeReports', concat('Added grade for Student ID ', new.StudentID, ' in Section ID ', new.SectionID, ' for "', new.CourseworkName, '", type: ', new.GradeType));
end
$$
DELIMITER ;

-- Student Class History Table (Inserts, Updates & Deletion) 
DELIMITER $$
create trigger Audit_StudentClassHistory_Delete after delete on StudentClassHistory
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Delete', 'StudentClassHistory', concat('Removed Student ID ', old.StudentID, ' from Section ID ', old.SectionID));
end
$$

create trigger Audit_StudentClassHistory_Update after update on StudentClassHistory
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Update', 'StudentClassHistory', concat('Updated class history ID: ', new.HistoryID));
end
$$

create trigger Audit_StudentClassHistory_Insert after insert on StudentClassHistory
for each row begin
	declare userID int;
    
    if current_user() = 'root@localhost' then 
		set userID = 1;
	else 
		select UserID into userID from Users where Username = substring_index(current_user(), '@', 1);
	end if;
    
    insert into AuditLogs (UserID, Actions, TableName, Details) 
    values (userID, 'Insert', 'StudentClassHistory', concat('Enrolled Student ID ', new.StudentID, ' in Section ID ', new.SectionID));
end
$$
DELIMITER ;

/* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
																						                             SAMPLE DATA                                                                                                         
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */

-- Data for 3 campuses
INSERT INTO Campuses (CampusName, Location, CampusContact, MonthlyBudget) VALUES
    ('Main Campus', '123 University Blvd, City A', '123-456-7890', 100000),
    ('North Campus', '456 North St, City B', '234-567-8901', 50000),
    ('South Campus', '789 South Ave, City C', '345-678-9012', 75000);

-- Main Campus - 15 students
INSERT INTO Students (StudentName, DateOfBirth, EnrollmentDate, PhoneNumber, Email) VALUES
	('John Doe', '2000-05-10', '2020-08-15', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('john.doe@university.com', @key_email)),
    ('Jane Smith', '2001-11-20', '2021-01-20', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('jane.smith@university.com', @key_email)),
    ('Alice Johnson', '2000-04-25', '2020-09-05', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('alice.johnson@university.com', @key_email)),
    ('Bob Brown', '1999-12-12', '2019-05-10', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('bob.brown@university.com', @key_email)),
    ('Charlie Davis', '2002-07-15', '2021-02-10', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('charlie.davis@university.com', @key_email)),
    ('Diana Miller', '2000-01-22', '2020-08-18', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('diana.miller@university.com', @key_email)),
    ('Evan Lee', '2001-04-25', '2021-03-01', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('evan.lee@university.com', @key_email)),
    ('Fiona Moore', '1999-11-30', '2019-06-12', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('fiona.moore@university.com', @key_email)),
    ('George Harris', '2000-03-11', '2020-07-19', AES_ENCRYPT('901-234-5678', @key_phone), AES_ENCRYPT('george.harris@university.com', @key_email)),
    ('Hannah Walker', '2002-08-01', '2021-01-15', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('hannah.walker@university.com', @key_email)),
    ('Ivy Scott', '2001-05-25', '2021-04-22', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('ivy.scott@university.com', @key_email)),
    ('Jackie King', '2000-09-13', '2020-10-02', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('jackie.king@university.com', @key_email)),
    ('Kevin Lee', '2001-07-10', '2021-02-11', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('kevin.lee@university.com', @key_email)),
    ('Liam Kim', '2000-11-15', '2020-09-30', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('liam.kim@university.com', @key_email)),
    ('Mia Lewis', '1999-04-20', '2019-05-15', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('mia.lewis@university.com', @key_email));

-- North Campus - 15 students
INSERT INTO Students (StudentName, DateOfBirth, EnrollmentDate, PhoneNumber, Email) VALUES
    ('Nina Carter', '2002-06-14', '2021-03-15', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('nina.carter@university.com', @key_email)),
    ('Oliver Perez', '1999-08-19', '2019-07-30', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('oliver.perez@university.com', @key_email)),
    ('Paul Adams', '2000-02-11', '2020-10-10', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('paul.adams@university.com', @key_email)),
    ('Quincy Reed', '2001-09-09', '2021-02-10', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('quincy.reed@university.com', @key_email)),
    ('Rachel Evans', '2002-12-01', '2021-01-20', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('rachel.evans@university.com', @key_email)),
    ('Sophia Knight', '2000-05-30', '2020-08-01', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('sophia.knight@university.com', @key_email)),
    ('Travis Gray', '2001-01-15', '2021-03-12', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('travis.gray@university.com', @key_email)),
    ('Ursula Ward', '2000-08-07', '2020-09-18', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('ursula.ward@university.com', @key_email)),
    ('Vera Scott', '2002-03-25', '2021-02-25', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('vera.scott@university.com', @key_email)),
    ('Walter Harris', '1999-10-05', '2019-06-07', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('walter.harris@university.com', @key_email)),
    ('Xander Clark', '2000-03-11', '2020-07-25', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('xander.clark@university.com', @key_email)),
    ('Yasmine Lee', '2001-05-05', '2021-01-25', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('yasmine.lee@university.com', @key_email)),
    ('Zachary Allen', '2000-09-29', '2020-08-12', AES_ENCRYPT('901-234-5678', @key_phone), AES_ENCRYPT('zachary.allen@university.com', @key_email)),
    ('Ava Thomas', '2002-01-05', '2021-02-14', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('ava.thomas@university.com', @key_email)),
    ('Benjamin White', '2001-11-18', '2021-03-22', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('benjamin.white@university.com', @key_email));

-- South Campus - 15 students
INSERT INTO Students (StudentName, DateOfBirth, EnrollmentDate, PhoneNumber, Email) VALUES
    ('Clara Adams', '2000-01-03', '2020-06-15', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('clara.adams@university.com', @key_email)),
    ('Daniel Miller', '2001-10-22', '2021-02-28', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('daniel.miller@university.com', @key_email)),
    ('Ella Thompson', '2000-03-18', '2020-08-10', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('ella.thompson@university.com', @key_email)),
    ('Fay Wilson', '2001-06-02', '2021-04-05', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('fay.wilson@university.com', @key_email)),
    ('Gage Walker', '1999-07-20', '2019-05-15', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('gage.walker@university.com', @key_email)),
    ('Hope Carter', '2002-04-25', '2021-03-14', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('hope.carter@university.com', @key_email)),
    ('Isla Scott', '2001-12-08', '2021-02-01', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('isla.scott@university.com', @key_email)),
    ('Jack Hunter', '2002-08-12', '2021-01-10', AES_ENCRYPT('901-234-5678', @key_phone), AES_ENCRYPT('jack.hunter@university.com', @key_email)),
    ('Kayla Lewis', '2000-04-16', '2020-09-23', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('kayla.lewis@university.com', @key_email)),
    ('Luna Moore', '2001-11-07', '2021-03-12', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('luna.moore@university.com', @key_email)),
    ('Miles Walker', '2002-05-30', '2021-02-15', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('miles.walker@university.com', @key_email)),
    ('Nina Lee', '2000-10-23', '2020-10-10', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('nina.lee@university.com', @key_email)),
    ('Owen King', '2002-02-17', '2021-03-21', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('owen.king@university.com', @key_email)),
    ('Penelope Rose', '1999-09-04', '2019-07-02', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('penelope.rose@university.com', @key_email));


-- Guardians - 28 Guardians (for 45 students)
INSERT INTO Guardians (FName, LName, PhoneNumber, Email) VALUES
    ('John', 'Doe', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('john.doe@guardian.com', @key_email)),
    ('Mary', 'Smith', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('mary.smith@guardian.com', @key_email)),
    ('Alice', 'Johnson', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('alice.johnson@guardian.com', @key_email)),
    ('David', 'Brown', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('david.brown@guardian.com', @key_email)),
    ('Charles', 'Davis', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('charles.davis@guardian.com', @key_email)),
    ('Eleanor', 'Miller', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('eleanor.miller@guardian.com', @key_email)),
    ('Grace', 'Lee', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('grace.lee@guardian.com', @key_email)),
    ('Frank', 'Walker', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('frank.walker@guardian.com', @key_email)),
    ('Sophia', 'Harris', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('sophia.harris@guardian.com', @key_email)),
    ('Helen', 'Wright', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('helen.wright@guardian.com', @key_email)),
    ('Linda', 'Scott', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('linda.scott@guardian.com', @key_email)),
    ('Michael', 'Young', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('michael.young@guardian.com', @key_email)),
    ('Elizabeth', 'King', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('elizabeth.king@guardian.com', @key_email)),
    ('James', 'Martinez', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('james.martinez@guardian.com', @key_email)),
    ('Patricia', 'Gonzalez', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('patricia.gonzalez@guardian.com', @key_email)),
    ('Barbara', 'Moore', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('barbara.moore@guardian.com', @key_email)),
    ('Robert', 'Perez', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('robert.perez@guardian.com', @key_email)),
    ('Mary', 'Roberts', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('mary.roberts@guardian.com', @key_email)),
    ('Joseph', 'Clark', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('joseph.clark@guardian.com', @key_email)),
    ('Betty', 'Evans', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('betty.evans@guardian.com', @key_email)),
    ('William', 'Nelson', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('william.nelson@guardian.com', @key_email)),
    ('Susan', 'Carter', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('susan.carter@guardian.com', @key_email)),
    ('Patricia', 'Mitchell', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('patricia.mitchell@guardian.com', @key_email)),
    ('Andrew', 'Robinson', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('andrew.robinson@guardian.com', @key_email)),
    ('Karen', 'King', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('karen.king@guardian.com', @key_email)),
    ('Daniel', 'White', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('daniel.white@guardian.com', @key_email)),
    ('Thomas', 'Green', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('thomas.green@guardian.com', @key_email)),
    ('Christopher', 'Adams', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('christopher.adams@guardian.com', @key_email));

-- Student-Guardian Relationships
INSERT INTO StudentGuardians (StudentID, GuardianID) VALUES
    (1000, 1), -- Guardian 1 has Student 1000
    (1001, 2), -- Guardian 2 has Student 1001
    (1002, 3), -- Guardian 3 has Student 1002
    (1003, 4), -- Guardian 4 has Student 1003
    (1004, 5), -- Guardian 5 has Student 1004
    (1005, 6), -- Guardian 6 has Student 1005
    (1006, 7), -- Guardian 7 has Student 1006
    (1007, 8), -- Guardian 8 has Student 1007
    (1008, 9), -- Guardian 9 has Student 1008
    (1009, 10), -- Guardian 10 has Student 1009
    (1010, 11), -- Guardian 11 has Student 1010
    (1011, 12), -- Guardian 12 has Student 1011
    (1012, 13), -- Guardian 13 has Student 1012
    (1013, 14), -- Guardian 14 has Student 1013
    (1014, 15), -- Guardian 15 has Student 1014
    (1015, 16), -- Guardian 16 has Student 1015
    (1016, 17), -- Guardian 17 has Student 1016
    (1017, 18), -- Guardian 18 has Student 1017
    (1018, 19), -- Guardian 19 has Student 1018
    (1019, 20), -- Guardian 20 has Student 1019
    (1020, 21), -- Guardian 21 has Student 1021
    (1021, 22), -- Guardian 22 has Student 1022
    (1022, 23), -- Guardian 23 has Student 1023
    (1023, 24), -- Guardian 24 has Student 1024
    (1024, 25), -- Guardian 25 has Student 1025
    (1025, 26), -- Guardian 26 has Student 1026
    (1026, 27), -- Guardian 27 has Student 1027
    (1027, 28), -- Guardian 28 has Student 1028
    (1028, 27), -- Guardian 27 has Student 1029
    (1029, 20), -- Guardian 20 has Student 1030
    (1030, 1), -- Guardian 1 also has Student 1030
    (1031, 2), -- Guardian 2 also has Student 1031
    (1032, 3), -- Guardian 3 also has Student 1032
    (1033, 4), -- Guardian 4 also has Student 1033
    (1034, 5), -- Guardian 5 also has Student 1034
    (1035, 6), -- Guardian 6 also has Student 1035
    (1036, 7), -- Guardian 7 also has Student 1036
    (1037, 8), -- Guardian 8 also has Student 1037
    (1038, 9), -- Guardian 9 also has Student 1038
    (1039, 10), -- Guardian 10 also has Student 1039
    (1040, 11), -- Guardian 11 also has Student 1040
    (1041, 12), -- Guardian 12 also has Student 1041
    (1042, 13), -- Guardian 13 also has Student 1042
    (1043, 14); -- Guardian 14 also has Student 1043

-- Staff Insert (6 staff per campus, 18 total with updated names)
INSERT INTO Staff (StaffName, StaffRole, Qualifications, PhoneNumber, Email) VALUES
    ('Johnathan Doyle', 'Admin', 'MBA, Leadership', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('johnathan.doyle@admin.com', @key_email)),
    ('Julia Spencer', 'Teacher', 'PhD in Computer Science', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('julia.spencer@teacher.com', @key_email)),
    ('Maxwell Harrison', 'Teacher', 'M.Ed. Mathematics', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('maxwell.harrison@teacher.com', @key_email)),
    ('Isabella Young', 'Clerk', 'Associate Degree in Admin', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('isabella.young@clerk.com', @key_email)),
    ('Alexander Cole', 'Teacher', 'PhD in Physics', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('alexander.cole@teacher.com', @key_email)),
    ('Samantha Reed', 'Teacher', 'M.A. in History', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('samantha.reed@teacher.com', @key_email)),
    ('Benjamin Clark', 'Admin', 'MBA, Finance', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('benjamin.clark@admin.com', @key_email)),
    ('Eva Martinez', 'Teacher', 'PhD in Chemistry', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('eva.martinez@teacher.com', @key_email)),
    ('Nathaniel Scott', 'Teacher', 'PhD in Engineering', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('nathaniel.scott@teacher.com', @key_email)),
    ('Olivia Evans', 'Clerk', 'Certificate in Office Management', AES_ENCRYPT('123-456-7890', @key_phone), AES_ENCRYPT('olivia.evans@clerk.com', @key_email)),
    ('Henry Mitchell', 'Teacher', 'M.A. in Literature', AES_ENCRYPT('234-567-8901', @key_phone), AES_ENCRYPT('henry.mitchell@teacher.com', @key_email)),
    ('Lily Harris', 'Teacher', 'M.Ed. in Education', AES_ENCRYPT('345-678-9012', @key_phone), AES_ENCRYPT('lily.harris@teacher.com', @key_email)),
    ('George Johnson', 'Admin', 'MBA, HR Management', AES_ENCRYPT('456-789-0123', @key_phone), AES_ENCRYPT('george.johnson@admin.com', @key_email)),
    ('Chloe Bell', 'Teacher', 'PhD in Biology', AES_ENCRYPT('567-890-1234', @key_phone), AES_ENCRYPT('chloe.bell@teacher.com', @key_email)),
    ('Patrick Adams', 'Teacher', 'PhD in Psychology', AES_ENCRYPT('678-901-2345', @key_phone), AES_ENCRYPT('patrick.adams@teacher.com', @key_email)),
    ('Madison Green', 'Clerk', 'Certificate in Admin Support', AES_ENCRYPT('789-012-3456', @key_phone), AES_ENCRYPT('madison.green@clerk.com', @key_email)),
    ('Jacob Turner', 'Teacher', 'M.S. in Computer Science', AES_ENCRYPT('890-123-4567', @key_phone), AES_ENCRYPT('jacob.turner@teacher.com', @key_email)),
    ('Sophia Mitchell', 'Teacher', 'M.A. in Education', AES_ENCRYPT('012-345-6789', @key_phone), AES_ENCRYPT('sophia.mitchell@teacher.com', @key_email));

-- Staff Employment History with transitions and salary changes
INSERT INTO EmploymentHistory (CampusID, StaffID, StartDate, EndDate, Salary) VALUES
    (1, 2000, '2021-01-01', '2022-01-25', AES_ENCRYPT('70000', @key_salary)),  -- Admin at Campus 1, Salary = 70,000
    (2, 2001, '2022-02-01', null, AES_ENCRYPT('52000', @key_salary)),  -- Teacher at Campus 2, Salary = 52,000
    (2, 2002, '2021-07-01', null, AES_ENCRYPT('40000', @key_salary)),  -- Clerk at Campus 2, Salary = 40,000
    (3, 2003, '2022-04-01', null, AES_ENCRYPT('49000', @key_salary)),  -- Teacher at Campus 3, Salary = 49,000
    (3, 2004, '2021-06-01', null, AES_ENCRYPT('72000', @key_salary)),  -- Admin at Campus 3, Salary = 72,000
    (1, 2005, '2022-03-01', '2023-08-16', AES_ENCRYPT('43000', @key_salary)),  -- Clerk at Campus 1, Salary = 43,000
    (2, 2006, '2021-08-01', null, AES_ENCRYPT('55000', @key_salary)),  -- Teacher at Campus 2, Salary = 55,000
    (1, 2007, '2022-06-01', null, AES_ENCRYPT('42000', @key_salary)),  -- Clerk at Campus 1, Salary = 42,000
    (2, 2008, '2021-09-01', null, AES_ENCRYPT('71000', @key_salary)),  -- Admin at Campus 2, Salary = 71,000
    (1, 2009, '2022-07-01', null, AES_ENCRYPT('46000', @key_salary)),  -- Teacher at Campus 1, Salary = 46,000
    (3, 2010, '2021-12-01', null, AES_ENCRYPT('73000', @key_salary)),  -- Admin at Campus 3, Salary = 73,000
    (2, 2011, '2022-03-01', null, AES_ENCRYPT('50000', @key_salary)),  -- Teacher at Campus 2, Salary = 50,000
    (1, 2012, '2022-09-01', null, AES_ENCRYPT('45000', @key_salary)),  -- Clerk at Campus 1, Salary = 45,000
    (2, 2013, '2021-10-01', null, AES_ENCRYPT('53000', @key_salary)),  -- Teacher at Campus 2, Salary = 53,000
    (3, 2014, '2022-05-01', null, AES_ENCRYPT('56000', @key_salary)),  -- Teacher at Campus 3, Salary = 56,000
    (1, 2015, '2022-06-01', '2023-08-01', AES_ENCRYPT('45000', @key_salary)),  -- Teacher at Campus 1, Salary = 45,000
    (2, 2015, '2023-08-01', NULL, AES_ENCRYPT('50000', @key_salary)),  -- Teacher at Campus 2, Salary = 50,000 (Salary increase)
    (3, 2016, '2021-07-01', '2023-04-01', AES_ENCRYPT('40000', @key_salary)),  -- Clerk at Campus 3, Salary = 40,000
    (1, 2016, '2023-04-01', NULL, AES_ENCRYPT('42000', @key_salary)),  -- Clerk at Campus 1, Salary = 42,000 (Salary increase)
    (2, 2017, '2022-01-01', '2023-06-01', AES_ENCRYPT('65000', @key_salary)),  -- Admin at Campus 2, Salary = 65,000
    (3, 2017, '2023-06-01', NULL, AES_ENCRYPT('70000', @key_salary)),  -- Admin at Campus 3, Salary = 70,000 (Salary increase)
    (2, 2000, '2022-02-01', '2023-09-01', AES_ENCRYPT('78000', @key_salary)),  -- Admin at Campus 2, Salary = 78,000 (Salary increase)
    (2, 2005, '2023-09-01', NULL, AES_ENCRYPT('53000', @key_salary));  -- Clerk at Campus 2, Salary = 53,000 (Salary increase)

-- School Records: Mapping students to campuses
INSERT INTO SchoolRecords (CampusID, StudentID) VALUES
    (1, 1000), (1, 1001), (1, 1002), (1, 1003), (1, 1004), (1, 1005),
    (2, 1006), (2, 1007), (2, 1008), (2, 1009), (2, 1010), (2, 1011),
    (3, 1012), (3, 1013), (3, 1014), (3, 1015), (3, 1016), (3, 1017),
    (1, 1018), (1, 1019), (1, 1020), (1, 1021), (1, 1022), (1, 1023),
    (2, 1024), (2, 1025), (2, 1026), (2, 1027), (2, 1028), (2, 1029),
    (3, 1030), (3, 1031), (3, 1032), (3, 1033), (3, 1034), (3, 1035),
    (1, 1036), (1, 1037), (1, 1038), (1, 1039), (1, 1040), (1, 1041),
    (2, 1042), (2, 1043);

-- 18 Staff
INSERT INTO PersonContacts (StaffID, GuardianID, StudentID) VALUES
    (2000, NULL, NULL),
    (2001, NULL, NULL),
    (2002, NULL, NULL),
    (2003, NULL, NULL),
    (2004, NULL, NULL),
    (2005, NULL, NULL),
    (2006, NULL, NULL),
    (2007, NULL, NULL),
    (2008, NULL, NULL),
    (2009, NULL, NULL),
    (2010, NULL, NULL),
    (2011, NULL, NULL),
    (2012, NULL, NULL),
    (2013, NULL, NULL),
    (2014, NULL, NULL),
    (2015, NULL, NULL),
    (2016, NULL, NULL),
    (2017, NULL, NULL);

-- 30 Guardians
INSERT INTO PersonContacts (StaffID, GuardianID, StudentID) VALUES
    (NULL, 1, NULL),
    (NULL, 2, NULL),
    (NULL, 3, NULL),
    (NULL, 4, NULL),
    (NULL, 5, NULL),
    (NULL, 6, NULL),
    (NULL, 7, NULL),
    (NULL, 8, NULL),
    (NULL, 9, NULL),
    (NULL, 10, NULL),
    (NULL, 11, NULL),
    (NULL, 12, NULL),
    (NULL, 13, NULL),
    (NULL, 14, NULL),
    (NULL, 15, NULL),
    (NULL, 16, NULL),
    (NULL, 17, NULL),
    (NULL, 18, NULL),
    (NULL, 19, NULL),
    (NULL, 20, NULL),
    (NULL, 21, NULL),
    (NULL, 22, NULL),
    (NULL, 23, NULL),
    (NULL, 24, NULL),
    (NULL, 25, NULL),
    (NULL, 26, NULL),
    (NULL, 27, NULL);
    
-- 45 Students
INSERT INTO PersonContacts (StaffID, GuardianID, StudentID) VALUES
    (NULL, NULL, 1000),
    (NULL, NULL, 1001),
    (NULL, NULL, 1002),
    (NULL, NULL, 1003),
    (NULL, NULL, 1004),
    (NULL, NULL, 1005),
    (NULL, NULL, 1006),
    (NULL, NULL, 1007),
    (NULL, NULL, 1008),
    (NULL, NULL, 1009),
    (NULL, NULL, 1010),
    (NULL, NULL, 1011),
    (NULL, NULL, 1012),
    (NULL, NULL, 1013),
    (NULL, NULL, 1014),
    (NULL, NULL, 1015),
    (NULL, NULL, 1016),
    (NULL, NULL, 1017),
    (NULL, NULL, 1018),
    (NULL, NULL, 1019),
    (NULL, NULL, 1020),
    (NULL, NULL, 1021),
    (NULL, NULL, 1022),
    (NULL, NULL, 1023),
    (NULL, NULL, 1024),
    (NULL, NULL, 1025),
    (NULL, NULL, 1026),
    (NULL, NULL, 1027),
    (NULL, NULL, 1028),
    (NULL, NULL, 1029),
    (NULL, NULL, 1030),
    (NULL, NULL, 1031),
    (NULL, NULL, 1032),
    (NULL, NULL, 1033),
    (NULL, NULL, 1034),
    (NULL, NULL, 1035),
    (NULL, NULL, 1036),
    (NULL, NULL, 1037),
    (NULL, NULL, 1038),
    (NULL, NULL, 1039),
    (NULL, NULL, 1040),
    (NULL, NULL, 1041),
    (NULL, NULL, 1042),
    (NULL, NULL, 1043);
    
-- Students (45 students) - Multiple entries to reflect various attendance patterns
INSERT INTO AttendanceRecords (StaffID, StudentID, AttendanceDate, AttendanceStatus) VALUES
    (NULL, 1000, '2025-01-10', 'Present'),
    (NULL, 1000, '2025-01-11', 'Absent'),
    (NULL, 1000, '2025-01-12', 'Late'),
    (NULL, 1001, '2025-01-10', 'Present'),
    (NULL, 1001, '2025-01-11', 'Present'),
    (NULL, 1001, '2025-01-12', 'Absent'),
    (NULL, 1002, '2025-01-10', 'Late'),
    (NULL, 1002, '2025-01-11', 'Present'),
    (NULL, 1002, '2025-01-12', 'Present'),
    (NULL, 1003, '2025-01-10', 'Present'),
    (NULL, 1003, '2025-01-11', 'Present'),
    (NULL, 1003, '2025-01-12', 'Present'),
    (NULL, 1004, '2025-01-10', 'Present'),
    (NULL, 1004, '2025-01-11', 'Absent'),
    (NULL, 1004, '2025-01-12', 'Late'),
    (NULL, 1005, '2025-01-10', 'Absent'),
    (NULL, 1005, '2025-01-11', 'Absent'),
    (NULL, 1005, '2025-01-12', 'Present'),
    (NULL, 1006, '2025-01-10', 'Present'),
    (NULL, 1006, '2025-01-11', 'Present'),
    (NULL, 1006, '2025-01-12', 'Present'),
    (NULL, 1007, '2025-01-10', 'Late'),
    (NULL, 1007, '2025-01-11', 'Late'),
    (NULL, 1007, '2025-01-12', 'Present'),
    (NULL, 1008, '2025-01-10', 'Present'),
    (NULL, 1008, '2025-01-11', 'Present'),
    (NULL, 1008, '2025-01-12', 'Present'),
    (NULL, 1009, '2025-01-10', 'Present'),
    (NULL, 1009, '2025-01-11', 'Absent'),
    (NULL, 1009, '2025-01-12', 'Present'),
    (NULL, 1010, '2025-01-10', 'Absent'),
    (NULL, 1010, '2025-01-11', 'Late'),
    (NULL, 1010, '2025-01-12', 'Absent'),
    (NULL, 1011, '2025-01-10', 'Present'),
    (NULL, 1011, '2025-01-11', 'Present'),
    (NULL, 1011, '2025-01-12', 'Present'),
    (NULL, 1012, '2025-01-10', 'Late'),
    (NULL, 1012, '2025-01-11', 'Absent'),
    (NULL, 1012, '2025-01-12', 'Present'),
    (NULL, 1013, '2025-01-10', 'Present'),
    (NULL, 1013, '2025-01-11', 'Present'),
    (NULL, 1013, '2025-01-12', 'Late'),
    (NULL, 1014, '2025-01-10', 'Absent'),
    (NULL, 1014, '2025-01-11', 'Absent'),
    (NULL, 1014, '2025-01-12', 'Absent'),
    (NULL, 1015, '2025-01-10', 'Present'),
    (NULL, 1015, '2025-01-11', 'Present'),
    (NULL, 1015, '2025-01-12', 'Present'),
    (NULL, 1016, '2025-01-10', 'Late'),
    (NULL, 1016, '2025-01-11', 'Present'),
    (NULL, 1016, '2025-01-12', 'Absent'),
    (NULL, 1017, '2025-01-10', 'Absent'),
    (NULL, 1017, '2025-01-11', 'Present'),
    (NULL, 1017, '2025-01-12', 'Present'),
    (NULL, 1018, '2025-01-10', 'Late'),
    (NULL, 1018, '2025-01-11', 'Present'),
    (NULL, 1018, '2025-01-12', 'Late'),
    (NULL, 1019, '2025-01-10', 'Present'),
    (NULL, 1019, '2025-01-11', 'Present'),
    (NULL, 1019, '2025-01-12', 'Absent'),
    (NULL, 1020, '2025-01-10', 'Late'),
    (NULL, 1020, '2025-01-11', 'Present'),
    (NULL, 1020, '2025-01-12', 'Late'),
    (NULL, 1021, '2025-01-10', 'Absent'),
    (NULL, 1021, '2025-01-11', 'Absent'),
    (NULL, 1021, '2025-01-12', 'Present'),
    (NULL, 1022, '2025-01-10', 'Present'),
    (NULL, 1022, '2025-01-11', 'Present'),
    (NULL, 1022, '2025-01-12', 'Present'),
    (NULL, 1023, '2025-01-10', 'Late'),
    (NULL, 1023, '2025-01-11', 'Present'),
    (NULL, 1023, '2025-01-12', 'Late'),
    (NULL, 1024, '2025-01-10', 'Present'),
    (NULL, 1024, '2025-01-11', 'Present'),
    (NULL, 1024, '2025-01-12', 'Absent'),
    (NULL, 1025, '2025-01-10', 'Present'),
    (NULL, 1025, '2025-01-11', 'Present'),
    (NULL, 1025, '2025-01-12', 'Present'),
    (NULL, 1026, '2025-01-10', 'Present'),
    (NULL, 1026, '2025-01-11', 'Absent'),
    (NULL, 1026, '2025-01-12', 'Present'),
    (NULL, 1027, '2025-01-10', 'Present'),
    (NULL, 1027, '2025-01-11', 'Present'),
    (NULL, 1027, '2025-01-12', 'Present'),
    (NULL, 1028, '2025-01-10', 'Absent'),
    (NULL, 1028, '2025-01-11', 'Present'),
    (NULL, 1028, '2025-01-12', 'Present'),
    (NULL, 1029, '2025-01-10', 'Late'),
    (NULL, 1029, '2025-01-11', 'Present'),
    (NULL, 1029, '2025-01-12', 'Present'),
    (NULL, 1030, '2025-01-10', 'Present'),
    (NULL, 1030, '2025-01-11', 'Late'),
    (NULL, 1030, '2025-01-12', 'Absent'),
    (NULL, 1031, '2025-01-10', 'Present'),
    (NULL, 1031, '2025-01-11', 'Present'),
    (NULL, 1031, '2025-01-12', 'Absent'),
    (NULL, 1032, '2025-01-10', 'Absent'),
    (NULL, 1032, '2025-01-11', 'Late'),
    (NULL, 1032, '2025-01-12', 'Present'),
    (NULL, 1033, '2025-01-10', 'Present'),
    (NULL, 1033, '2025-01-11', 'Present'),
    (NULL, 1033, '2025-01-12', 'Present'),
    (NULL, 1034, '2025-01-10', 'Present'),
    (NULL, 1034, '2025-01-11', 'Present'),
    (NULL, 1034, '2025-01-12', 'Late'),
    (NULL, 1035, '2025-01-10', 'Absent'),
    (NULL, 1035, '2025-01-11', 'Present'),
    (NULL, 1035, '2025-01-12', 'Present'),
    (NULL, 1036, '2025-01-10', 'Late'),
    (NULL, 1036, '2025-01-11', 'Present'),
    (NULL, 1036, '2025-01-12', 'Absent'),
    (NULL, 1037, '2025-01-10', 'Present'),
    (NULL, 1037, '2025-01-11', 'Present'),
    (NULL, 1037, '2025-01-12', 'Present'),
    (NULL, 1038, '2025-01-10', 'Absent'),
    (NULL, 1038, '2025-01-11', 'Present'),
    (NULL, 1038, '2025-01-12', 'Late'),
    (NULL, 1039, '2025-01-10', 'Present'),
    (NULL, 1039, '2025-01-11', 'Present'),
    (NULL, 1039, '2025-01-12', 'Present'),
    (NULL, 1040, '2025-01-10', 'Late'),
    (NULL, 1040, '2025-01-11', 'Absent'),
    (NULL, 1040, '2025-01-12', 'Present'),
    (NULL, 1041, '2025-01-10', 'Present'),
    (NULL, 1041, '2025-01-11', 'Present'),
    (NULL, 1041, '2025-01-12', 'Present'),
    (NULL, 1042, '2025-01-10', 'Present'),
    (NULL, 1042, '2025-01-11', 'Absent'),
    (NULL, 1042, '2025-01-12', 'Present'),
    (NULL, 1043, '2025-01-10', 'Late'),
    (NULL, 1043, '2025-01-11', 'Present'),
    (NULL, 1043, '2025-01-12', 'Absent'),
	(NULL, 1000, '2025-01-13', 'Absent'),
    (NULL, 1000, '2025-01-14', 'Late'),
    (NULL, 1001, '2025-01-13', 'Late'),
    (NULL, 1001, '2025-01-14', 'Late'),
    (NULL, 1002, '2025-01-13', 'Absent'),
    (NULL, 1002, '2025-01-14', 'Present'),
    (NULL, 1003, '2025-01-13', 'Late'),
    (NULL, 1003, '2025-01-14', 'Absent'),
    (NULL, 1004, '2025-01-13', 'Late'),
    (NULL, 1004, '2025-01-14', 'Present'),
    (NULL, 1005, '2025-01-13', 'Late'),
    (NULL, 1005, '2025-01-14', 'Absent'),
    (NULL, 1006, '2025-01-13', 'Absent'),
    (NULL, 1006, '2025-01-14', 'Present'),
    (NULL, 1007, '2025-01-13', 'Present'),
    (NULL, 1007, '2025-01-14', 'Absent'),
    (NULL, 1008, '2025-01-13', 'Present'),
    (NULL, 1008, '2025-01-14', 'Late'),
    (NULL, 1009, '2025-01-13', 'Absent'),
    (NULL, 1009, '2025-01-14', 'Present'),
    (NULL, 1010, '2025-01-13', 'Late'),
    (NULL, 1010, '2025-01-14', 'Absent'),
    (NULL, 1011, '2025-01-13', 'Absent'),
    (NULL, 1011, '2025-01-14', 'Late'),
    (NULL, 1012, '2025-01-13', 'Absent'),
    (NULL, 1012, '2025-01-14', 'Present'),
    (NULL, 1013, '2025-01-13', 'Present'),
    (NULL, 1013, '2025-01-14', 'Present'),
    (NULL, 1014, '2025-01-13', 'Absent'),
    (NULL, 1014, '2025-01-14', 'Late'),
    (NULL, 1015, '2025-01-13', 'Late'),
    (NULL, 1015, '2025-01-14', 'Present'),
    (NULL, 1016, '2025-01-13', 'Absent'),
    (NULL, 1016, '2025-01-14', 'Late'),
    (NULL, 1017, '2025-01-13', 'Present'),
    (NULL, 1017, '2025-01-14', 'Present'),
    (NULL, 1018, '2025-01-13', 'Absent'),
    (NULL, 1018, '2025-01-14', 'Absent'),
    (NULL, 1019, '2025-01-13', 'Late'),
    (NULL, 1019, '2025-01-14', 'Late'),
    (NULL, 1020, '2025-01-13', 'Absent'),
    (NULL, 1020, '2025-01-14', 'Present'),
    (NULL, 1021, '2025-01-13', 'Absent'),
    (NULL, 1021, '2025-01-20', 'Absent'),
    (NULL, 1021, '2025-01-21', 'Absent'),
    (NULL, 1021, '2025-01-14', 'Present'),
    (NULL, 1022, '2025-01-13', 'Late'),
    (NULL, 1022, '2025-01-14', 'Present'),
    (NULL, 1023, '2025-01-13', 'Late'),
    (NULL, 1023, '2025-01-14', 'Absent'),
    (NULL, 1024, '2025-01-13', 'Present'),
    (NULL, 1024, '2025-01-14', 'Absent'),
    (NULL, 1025, '2025-01-13', 'Present'),
    (NULL, 1025, '2025-01-14', 'Present'),
    (NULL, 1026, '2025-01-13', 'Late'),
    (NULL, 1026, '2025-01-14', 'Absent'),
    (NULL, 1027, '2025-01-13', 'Present'),
    (NULL, 1027, '2025-01-14', 'Late'),
    (NULL, 1028, '2025-01-13', 'Absent'),
    (NULL, 1028, '2025-01-14', 'Present'),
    (NULL, 1029, '2025-01-13', 'Present'),
    (NULL, 1029, '2025-01-14', 'Late'),
    (NULL, 1030, '2025-01-13', 'Absent'),
    (NULL, 1030, '2025-01-14', 'Present'),
    (NULL, 1031, '2025-01-13', 'Absent'),
    (NULL, 1031, '2025-01-14', 'Present'),
    (NULL, 1032, '2025-01-13', 'Absent'),
    (NULL, 1032, '2025-01-14', 'Absent'),
    (NULL, 1033, '2025-01-13', 'Present'),
    (NULL, 1033, '2025-01-14', 'Present'),
    (NULL, 1034, '2025-01-13', 'Present'),
    (NULL, 1034, '2025-01-14', 'Absent'),
    (NULL, 1035, '2025-01-13', 'Absent'),
    (NULL, 1035, '2025-01-15', 'Absent'),
    (NULL, 1035, '2025-01-14', 'Late'),
    (NULL, 1036, '2025-01-13', 'Absent'),
    (NULL, 1036, '2025-01-14', 'Present'),
    (NULL, 1037, '2025-01-13', 'Present'),
    (NULL, 1037, '2025-01-14', 'Present'),
    (NULL, 1038, '2025-01-13', 'Present'),
    (NULL, 1038, '2025-01-14', 'Absent'),
    (NULL, 1039, '2025-01-13', 'Absent'),
    (NULL, 1039, '2025-01-14', 'Absent'),
    (NULL, 1040, '2025-01-13', 'Absent'),
    (NULL, 1040, '2025-01-14', 'Present'),
    (NULL, 1041, '2025-01-13', 'Present'),
    (NULL, 1041, '2025-01-14', 'Present'),
    (NULL, 1042, '2025-01-13', 'Absent'),
    (NULL, 1042, '2025-01-14', 'Present'),
    (NULL, 1043, '2025-01-13', 'Absent'),
    (NULL, 1043, '2025-01-14', 'Late');

-- Staff (18 staff) - Multiple entries to reflect various attendance patterns
INSERT INTO AttendanceRecords (StaffID, StudentID, AttendanceDate, AttendanceStatus) VALUES
    (2000, NULL, '2025-01-13', 'Absent'),
    (2000, NULL, '2025-01-14', 'Late'),
    (2001, NULL, '2025-01-13', 'Present'),
    (2001, NULL, '2025-01-14', 'Absent'),
    (2002, NULL, '2025-01-13', 'Late'),
    (2002, NULL, '2025-01-14', 'Absent'),
    (2003, NULL, '2025-01-13', 'Present'),
    (2003, NULL, '2025-01-14', 'Present'),
    (2004, NULL, '2025-01-13', 'Late'),
    (2004, NULL, '2025-01-14', 'Present'),
    (2005, NULL, '2025-01-13', 'Absent'),
    (2005, NULL, '2025-01-14', 'Late'),
    (2006, NULL, '2025-01-13', 'Present'),
    (2006, NULL, '2025-01-14', 'Present'),
    (2007, NULL, '2025-01-13', 'Late'),
    (2007, NULL, '2025-01-14', 'Absent'),
    (2008, NULL, '2025-01-13', 'Absent'),
    (2008, NULL, '2025-01-14', 'Present'),
    (2009, NULL, '2025-01-13', 'Late'),
    (2009, NULL, '2025-01-14', 'Present'),
    (2010, NULL, '2025-01-13', 'Absent'),
    (2010, NULL, '2025-01-14', 'Present'),
    (2011, NULL, '2025-01-13', 'Late'),
    (2011, NULL, '2025-01-14', 'Absent'),
    (2012, NULL, '2025-01-13', 'Present'),
    (2012, NULL, '2025-01-14', 'Late'),
    (2013, NULL, '2025-01-13', 'Absent'),
    (2013, NULL, '2025-01-14', 'Absent'),
    (2014, NULL, '2025-01-13', 'Present'),
    (2014, NULL, '2025-01-14', 'Present'),
    (2015, NULL, '2025-01-13', 'Present'),
    (2015, NULL, '2025-01-14', 'Absent'),
    (2016, NULL, '2025-01-13', 'Late'),
    (2016, NULL, '2025-01-14', 'Present'),
    (2017, NULL, '2025-01-13', 'Present'),
    (2017, NULL, '2025-01-14', 'Late'),
    (2000, NULL, '2025-02-01', 'Absent'),
    (2000, NULL, '2025-02-02', 'Late'),
    (2000, NULL, '2025-02-03', 'Present'),
    (2001, NULL, '2025-02-01', 'Present'),
    (2001, NULL, '2025-02-02', 'Present'),
    (2001, NULL, '2025-02-03', 'Present'),
    (2002, NULL, '2025-02-01', 'Late'),
    (2002, NULL, '2025-02-02', 'Present'),
    (2002, NULL, '2025-02-03', 'Absent'),
    (2003, NULL, '2025-02-01', 'Present'),
    (2003, NULL, '2025-02-02', 'Present'),
    (2003, NULL, '2025-02-03', 'Late'),
    (2004, NULL, '2025-02-01', 'Present'),
    (2004, NULL, '2025-02-02', 'Absent'),
    (2004, NULL, '2025-02-03', 'Present'),
    (2005, NULL, '2025-02-01', 'Late'),
    (2005, NULL, '2025-02-02', 'Present'),
    (2005, NULL, '2025-02-03', 'Present'),
    (2006, NULL, '2025-02-01', 'Present'),
    (2006, NULL, '2025-02-02', 'Present'),
    (2006, NULL, '2025-02-03', 'Present'),
    (2007, NULL, '2025-02-01', 'Absent'),
    (2007, NULL, '2025-02-02', 'Present'),
    (2007, NULL, '2025-02-03', 'Present'),
    (2008, NULL, '2025-02-01', 'Present'),
    (2008, NULL, '2025-02-02', 'Present'),
    (2008, NULL, '2025-02-03', 'Late'),
    (2009, NULL, '2025-02-01', 'Late'),
    (2009, NULL, '2025-02-02', 'Present'),
    (2009, NULL, '2025-02-03', 'Present'),
    (2010, NULL, '2025-02-01', 'Present'),
    (2010, NULL, '2025-02-02', 'Absent'),
    (2010, NULL, '2025-02-03', 'Present'),
    (2011, NULL, '2025-02-01', 'Late'),
    (2011, NULL, '2025-02-02', 'Present'),
    (2011, NULL, '2025-02-03', 'Present'),
    (2012, NULL, '2025-02-01', 'Present'),
    (2012, NULL, '2025-02-02', 'Present'),
    (2012, NULL, '2025-02-03', 'Present'),
    (2013, NULL, '2025-02-01', 'Absent'),
    (2013, NULL, '2025-02-02', 'Present'),
    (2013, NULL, '2025-02-03', 'Late'),
    (2014, NULL, '2025-02-01', 'Present'),
    (2014, NULL, '2025-02-02', 'Present'),
    (2014, NULL, '2025-02-03', 'Present'),
    (2015, NULL, '2025-02-01', 'Present'),
    (2015, NULL, '2025-02-02', 'Present'),
    (2015, NULL, '2025-02-03', 'Present'),
    (2016, NULL, '2025-02-01', 'Late'),
    (2016, NULL, '2025-02-02', 'Present'),
    (2016, NULL, '2025-02-03', 'Present'),
    (2017, NULL, '2025-02-01', 'Present'),
    (2017, NULL, '2025-02-02', 'Late'),
    (2017, NULL, '2025-02-03', 'Present');

-- Inserting more Event Types
INSERT INTO EventTypes (EventTypeName) VALUES
    ('Sports'),             -- Type 1
    ('Workshops'),          -- Type 2
    ('Cultural'),           -- Type 3
    ('General'),            -- Type 4
    ('Seminars'),           -- Type 5
    ('Conferences'),        -- Type 6
    ('Fundraisers'),        -- Type 7
    ('Career Fairs'),       -- Type 8
    ('Exhibitions'),        -- Type 9
    ('Health & Wellness'),  -- Type 10
    ('Music Performances'), -- Type 11
    ('Talent Shows'),       -- Type 12
    ('Networking Events'),  -- Type 13
    ('Hackathons'),         -- Type 14
    ('Art Shows'),          -- Type 15
    ('Tech Talks');         -- Type 16

-- Main Campus Events
INSERT INTO SchoolEvents (CampusID, EventTypeID, EventName, EventDate, EventTime, EventDescription) VALUES
    (1, 1, 'Football Tournament', '2025-04-01', '10:00:00', 'An exciting inter-campus football tournament with teams from all faculties participating.'),
    (1, 3, 'Cultural Festival', '2025-05-15', '14:00:00', 'A celebration of world cultures with food, art, and performances showcasing diversity.'),
    (1, 2, 'Python Workshop', '2025-06-20', '09:00:00', 'A hands-on workshop to help students master Python programming, from basics to advanced concepts.'),
    (1, 4, 'General Assembly', '2025-07-10', '10:00:00', 'A meeting to discuss university-wide initiatives, policy updates, and student welfare matters.'),
    (1, 7, 'Charity Fundraiser', '2025-08-05', '18:00:00', 'A fundraising event to support local charities with silent auctions, raffles, and donation booths.'),
    (1, 8, 'Graduate Career Fair', '2025-09-15', '11:00:00', 'A career fair for graduates featuring top companies offering interviews and job opportunities.'),
    (1, 6, 'Tech Conference', '2025-10-01', '13:30:00', 'An educational tech conference exploring innovations in AI, machine learning, and robotics.'),
    (1, 10, 'Mental Health Awareness Day', '2025-11-20', '09:00:00', 'A day dedicated to mental health awareness, with activities designed to promote student well-being.'),
    (1, 12, 'Student Talent Show', '2025-12-05', '19:00:00', 'A showcase of students’ hidden talents, featuring music, dance, and comedy performances.'),
    (1, 5, 'Career Development Seminar', '2026-01-10', '14:00:00', 'A seminar offering professional advice, CV reviews, and interview tips from career experts.'),
    (1, 15, 'Art Show', '2026-02-12', '16:00:00', 'An exhibition of visual arts created by students, including sculptures, paintings, and digital media.'),
    (1, 9, 'Science Exhibition', '2026-03-15', '11:00:00', 'A science fair featuring student-led projects, demonstrations, and experiments.'),
    (1, 14, 'Hackathon', '2026-04-12', '08:00:00', 'A 48-hour hackathon challenge where students build innovative projects and compete for prizes.'),
    (1, 13, 'Networking Night', '2026-05-25', '18:00:00', 'A chance for students to meet alumni, industry professionals, and potential employers.'),
    (1, 16, 'Tech Talk: AI in Education', '2026-06-18', '13:30:00', 'A discussion on the transformative role of artificial intelligence in modern education systems.'),
    (1, 11, 'Jazz Band Performance', '2026-07-01', '18:30:00', 'Live performance by the university’s jazz band, featuring a collection of classic and modern jazz pieces.'),
    (1, 3, 'Volunteer Day', '2026-08-02', '09:00:00', 'A community volunteering event where students work together to serve local organizations and causes.'),
    (1, 4, 'Halloween Party', '2026-10-31', '20:00:00', 'A spooky Halloween party with costume contests, games, and plenty of treats for all.'),
    (1, 2, 'Debate Tournament', '2026-11-05', '09:00:00', 'A competitive debate event where students tackle complex topics in an intellectual showdown.'),
    (1, 5, 'Film Screening', '2026-12-05', '19:00:00', 'An evening of critically acclaimed films, followed by a discussion with directors and critics.');

-- North Campus Events
INSERT INTO SchoolEvents (CampusID, EventTypeID, EventName, EventDate, EventTime, EventDescription) VALUES
    (2, 9, 'Science Exhibition', '2025-04-15', '10:00:00', 'A showcase of student science projects focusing on environmental sustainability.'),
    (2, 6, 'Tech Conference', '2025-05-22', '13:30:00', 'A conference with guest speakers from the tech industry sharing insights on cloud computing and data science.'),
    (2, 3, 'Cultural Festival', '2025-06-18', '14:00:00', 'A cultural festival filled with music, dance performances, and international cuisine.'),
    (2, 7, 'Charity Fundraiser', '2025-07-14', '17:30:00', 'A charity event featuring an auction and live performances to raise funds for local children’s hospitals.'),
    (2, 8, 'Graduate Career Fair', '2025-08-10', '10:00:00', 'An opportunity for graduates to meet top employers and discuss job openings across various industries.'),
    (2, 2, 'Python Workshop', '2025-09-05', '09:00:00', 'A hands-on session focused on Python programming fundamentals and real-world applications.'),
    (2, 4, 'General Assembly', '2025-10-15', '11:00:00', 'An all-campus meeting to discuss student affairs, policy changes, and upcoming events.'),
    (2, 5, 'Career Development Seminar', '2025-11-25', '14:00:00', 'A professional development seminar offering advice on job search strategies and CV writing.'),
    (2, 15, 'Art Show', '2025-12-01', '17:00:00', 'An art exhibition showcasing student artwork including paintings, photography, and digital media.'),
    (2, 1, 'Football Tournament', '2026-01-10', '12:00:00', 'An inter-campus football tournament with teams from across the campus participating.'),
    (2, 10, 'Mental Health Awareness Day', '2026-02-10', '09:00:00', 'Activities and workshops aimed at raising awareness and reducing stigma surrounding mental health issues.'),
    (2, 14, 'Hackathon', '2026-03-15', '08:00:00', 'A high-energy coding event where teams compete to develop the most innovative software solutions.'),
    (2, 13, 'Networking Night', '2026-04-12', '18:30:00', 'A casual event where students can network with industry professionals and alumni.'),
    (2, 16, 'Tech Talk: AI in Education', '2026-05-05', '13:00:00', 'A talk discussing the growing role of artificial intelligence in revolutionizing educational methods.'),
    (2, 12, 'Student Talent Show', '2026-06-15', '19:00:00', 'A talent showcase event with performances in music, dance, and comedy by students.'),
    (2, 3, 'Volunteer Day', '2026-07-07', '09:00:00', 'A day of community service where students volunteer in local shelters and organizations.'),
    (2, 11, 'Jazz Band Performance', '2026-08-14', '18:30:00', 'A performance by the university’s jazz band, bringing a fusion of old-school jazz and modern improvisations.'),
    (2, 5, 'Film Screening', '2026-09-20', '18:00:00', 'A screening of a popular film, followed by a panel discussion with the director and cast.'),
    (2, 2, 'Debate Tournament', '2026-10-15', '09:00:00', 'An engaging debate event where students argue critical global issues in structured rounds.');

-- South Campus Events
INSERT INTO SchoolEvents (CampusID, EventTypeID, EventName, EventDate, EventTime, EventDescription) VALUES
    (3, 3, 'Cultural Festival', '2025-04-25', '14:00:00', 'A vibrant cultural festival showcasing performances, food, and crafts from different cultures.'),
    (3, 7, 'Charity Fundraiser', '2025-05-12', '17:00:00', 'A fundraiser event with raffles, silent auctions, and donation drives to support local causes.'),
    (3, 8, 'Graduate Career Fair', '2025-06-10', '10:00:00', 'An opportunity for graduating students to connect with employers for full-time positions.'),
    (3, 6, 'Tech Conference', '2025-07-04', '13:30:00', 'A conference featuring keynote speakers from top tech companies and industry leaders.'),
    (3, 2, 'Python Workshop', '2025-08-20', '09:00:00', 'An in-depth workshop on Python programming, focusing on its use in data analysis and machine learning.'),
    (3, 4, 'General Assembly', '2025-09-12', '10:00:00', 'A gathering of students and faculty to discuss new policies, campus developments, and upcoming events.'),
    (3, 5, 'Career Development Seminar', '2025-10-08', '14:00:00', 'A seminar that focuses on career development, interview techniques, and resume building.'),
    (3, 1, 'Football Tournament', '2025-11-18', '12:00:00', 'An exciting inter-campus football match with teams from various departments competing for the title.'),
    (3, 9, 'Science Exhibition', '2025-12-15', '10:00:00', 'A day to showcase cutting-edge student projects in the fields of biology, chemistry, and physics.'),
    (3, 10, 'Mental Health Awareness Day', '2026-01-17', '09:00:00', 'Activities and workshops aimed at raising awareness and reducing stigma surrounding mental health issues.'),
    (3, 11, 'Jazz Band Performance', '2026-02-25', '18:30:00', 'An evening of smooth jazz performed by the university’s talented jazz band.'),
    (3, 12, 'Student Talent Show', '2026-03-30', '19:00:00', 'An exciting talent show where students showcase their musical, theatrical, and comedic skills.'),
    (3, 13, 'Networking Night', '2026-04-18', '18:00:00', 'An informal networking event for students to connect with industry professionals and alumni.'),
    (3, 14, 'Hackathon', '2026-05-01', '08:00:00', 'A coding marathon where teams compete to develop the most innovative software solutions.'),
    (3, 15, 'Art Show', '2026-06-07', '17:00:00', 'A visual arts showcase featuring paintings, sculptures, and photography created by students.'),
    (3, 16, 'Tech Talk: AI in Education', '2026-07-15', '13:00:00', 'A presentation on how AI technologies are transforming teaching, learning, and student engagement.'),
    (3, 5, 'Film Screening', '2026-08-12', '19:00:00', 'A screening of a popular documentary on social issues, followed by a discussion panel.');

-- Facilities Table
-- Main Campus Facilities
INSERT INTO Facilities (CampusID, FacilityName, FacilityType) VALUES
    (1, 'Main Auditorium', 'Auditorium'),
    (1, 'Physics Lab', 'Lab'),
    (1, 'Library', 'Classroom'),
    (1, 'Gymnasium', 'Sports Ground'),
    (1, 'Computer Lab', 'Lab'),
    (1, 'Cafeteria', 'Classroom'),
    (1, 'Lecture Hall 1', 'Classroom'),
    (1, 'Main Conference Room', 'Classroom'),
    (1, 'Art Studio', 'Classroom'),
    (1, 'Outdoor Sports Area', 'Sports Ground');

-- North Campus Facilities
INSERT INTO Facilities (CampusID, FacilityName, FacilityType) VALUES
    (2, 'North Auditorium', 'Auditorium'),
    (2, 'Biology Lab', 'Lab'),
    (2, 'Library', 'Classroom'),
    (2, 'Basketball Court', 'Sports Ground'),
    (2, 'Technology Lab', 'Lab'),
    (2, 'Cafeteria', 'Classroom'),
    (2, 'Lecture Hall 2', 'Classroom'),
    (2, 'Small Conference Room', 'Classroom'),
    (2, 'Dance Studio', 'Classroom'),
    (2, 'Indoor Sports Area', 'Sports Ground');

-- South Campus Facilities
INSERT INTO Facilities (CampusID, FacilityName, FacilityType) VALUES
    (3, 'South Auditorium', 'Auditorium'),
    (3, 'Chemistry Lab', 'Lab'),
    (3, 'Library', 'Classroom'),
    (3, 'Football Field', 'Sports Ground'),
    (3, 'Design Lab', 'Lab'),
    (3, 'Cafeteria', 'Classroom'),
    (3, 'Lecture Hall 3', 'Classroom'),
    (3, 'Meeting Room', 'Classroom'),
    (3, 'Music Room', 'Classroom'),
    (3, 'Outdoor Sports Area', 'Sports Ground');

-- Main Campus Facility Usage
INSERT INTO FacilityUsage (FacilityID, UsageDate, StartTime, EndTime, Purpose) VALUES
    (1, '2025-04-21', '10:00:00', '12:00:00', 'Guest Speaker Event'),
    (2, '2025-04-22', '08:00:00', '10:00:00', 'Lab Experiment Session'),
    (3, '2025-04-23', '09:00:00', '11:00:00', 'Study Group'),
    (4, '2025-04-20', '13:00:00', '15:00:00', 'Basketball Practice'),
    (5, '2025-04-24', '14:00:00', '16:00:00', 'Computer Science Class'),
    (6, '2025-04-25', '12:00:00', '14:00:00', 'Cafeteria Lunchtime'),
    (7, '2025-04-26', '08:00:00', '10:00:00', 'Lecture on Artificial Intelligence'),
    (8, '2025-04-27', '11:00:00', '13:00:00', 'Staff Meeting'),
    (9, '2025-04-21', '15:00:00', '17:00:00', 'Art Class'),
    (10, '2025-04-20', '16:00:00', '18:00:00', 'Outdoor Sports Event');

-- North Campus Facility Usage
INSERT INTO FacilityUsage (FacilityID, UsageDate, StartTime, EndTime, Purpose) VALUES
    (11, '2025-04-22', '10:00:00', '12:00:00', 'Science Fair'),
    (12, '2025-04-21', '08:00:00', '10:00:00', 'Biology Experiment'),
    (13, '2025-04-23', '09:00:00', '11:00:00', 'Reading Club'),
    (14, '2025-04-20', '13:00:00', '15:00:00', 'Basketball Game'),
    (15, '2025-04-24', '14:00:00', '16:00:00', 'Technology Workshop'),
    (16, '2025-04-25', '12:00:00', '14:00:00', 'Cafeteria Lunchtime'),
    (17, '2025-04-26', '08:00:00', '10:00:00', 'Lecture on Quantum Mechanics'),
    (18, '2025-04-27', '11:00:00', '13:00:00', 'Student Government Meeting'),
    (19, '2025-04-21', '15:00:00', '17:00:00', 'Dance Practice'),
    (20, '2025-04-20', '16:00:00', '18:00:00', 'Indoor Sports Game');

-- South Campus Facility Usage
INSERT INTO FacilityUsage (FacilityID, UsageDate, StartTime, EndTime, Purpose) VALUES
    (21, '2025-04-22', '10:00:00', '12:00:00', 'Science Lecture'),
    (22, '2025-04-21', '08:00:00', '10:00:00', 'Chemistry Lab'),
    (23, '2025-04-23', '09:00:00', '11:00:00', 'Music Club Rehearsal'),
    (24, '2025-04-20', '13:00:00', '15:00:00', 'Football Match'),
    (25, '2025-04-24', '14:00:00', '16:00:00', 'Engineering Workshop'),
    (26, '2025-04-25', '12:00:00', '14:00:00', 'Cafeteria Lunchtime'),
    (27, '2025-04-26', '08:00:00', '10:00:00', 'History Lecture'),
    (28, '2025-04-27', '11:00:00', '13:00:00', 'Club Fair'),
    (29, '2025-04-21', '15:00:00', '17:00:00', 'Theater Performance'),
    (30, '2025-04-20', '16:00:00', '18:00:00', 'Outdoor Sports Event');

-- Main Campus Facility Maintenance
INSERT INTO FacilityMaintenance (FacilityID, MaintenanceDate, Description, MaintenanceCost) VALUES
    (1, '2025-04-20', 'Auditorium sound system upgrade', 2000.00),
    (2, '2025-04-22', 'Replaced broken lab equipment', 1500.00),
    (3, '2025-04-25', 'Updated library bookshelves', 800.00),
    (4, '2025-04-27', 'Repaired gymnasium flooring', 1200.00),
    (5, '2025-04-28', 'Upgraded computers in lab', 2500.00),
    (6, '2025-04-21', 'Fixed cafeteria kitchen appliances', 900.00),
    (7, '2025-04-23', 'Repaired lecture hall AV system', 1300.00),
    (8, '2025-04-24', 'Cleaned and painted conference room', 600.00),
    (9, '2025-04-20', 'Repaired air conditioning in art studio', 700.00),
    (10, '2025-04-22', 'Repaired lighting in outdoor sports area', 400.00);

-- North Campus Facility Maintenance
INSERT INTO FacilityMaintenance (FacilityID, MaintenanceDate, Description, MaintenanceCost) VALUES
    (11, '2025-04-23', 'Repaired audio equipment in auditorium', 1800.00),
    (12, '2025-04-21', 'Replaced lab cooling system', 1200.00),
    (13, '2025-04-25', 'Replaced lighting in library', 500.00),
    (14, '2025-04-28', 'Fixed basketball court flooring', 1500.00),
    (15, '2025-04-20', 'Replaced projectors in tech lab', 2200.00),
    (16, '2025-04-22', 'Renovated cafeteria seating', 700.00),
    (17, '2025-04-26', 'Replaced air conditioning in lecture hall', 1000.00),
    (18, '2025-04-20', 'Repainted sports indoor area', 800.00),
    (19, '2025-04-24', 'Fixed lights in dance studio', 400.00),
    (20, '2025-04-27', 'Refurbished gymnasium equipment', 1300.00);

-- South Campus Facility Maintenance
INSERT INTO FacilityMaintenance (FacilityID, MaintenanceDate, Description, MaintenanceCost) VALUES
    (21, '2025-04-20', 'Replaced lighting system in auditorium', 1500.00),
    (22, '2025-04-23', 'Fixed plumbing in chemistry lab', 1000.00),
    (23, '2025-04-21', 'Repaired sound system in music room', 1200.00),
    (24, '2025-04-27', 'Fixed grass on football field', 800.00),
    (25, '2025-04-22', 'Replaced equipment in engineering lab', 2000.00),
    (26, '2025-04-20', 'Repaired cafeteria kitchen hood', 900.00),
    (27, '2025-04-26', 'Updated audio-visual equipment in history lecture hall', 1500.00),
    (28, '2025-04-24', 'Repaired flooring in student center', 700.00),
    (29, '2025-04-25', 'Repaired sound system in theater', 1000.00),
    (30, '2025-04-23', 'Upgraded gymnasium lighting', 800.00);

-- Main Campus Courses (27 courses)
INSERT INTO Courses (CourseName, CourseDescription, CreditHours) VALUES
    ('Introduction to Computer Science', 'Basic concepts of computer science, programming languages, and algorithms.', 3),
    ('Data Structures and Algorithms', 'Learn about common data structures and algorithms with practical applications.', 4),
    ('Database Systems', 'Introduction to database management systems, design, and SQL.', 3),
    ('Web Development', 'Learn how to design and develop web applications using HTML, CSS, and JavaScript.', 3),
    ('Discrete Mathematics', 'Introduction to logic, sets, and combinatorics for computing.', 3),
    ('Operating Systems', 'Learn how operating systems work, focusing on process management and memory.', 4),
    ('Linear Algebra', 'Learn the fundamentals of linear algebra, including matrices, vectors, and eigenvalues.', 3),
    ('Calculus I', 'Introduction to calculus, focusing on limits, derivatives, and integrals.', 3),
    ('Psychology 101', 'Introduction to psychology, covering topics like cognition, emotion, and behavior.', 3),
    ('Introduction to Philosophy', 'An introduction to philosophical thinking and major philosophical questions.', 3),
    ('Calculus II', 'Advanced calculus concepts including integration techniques and series.', 3),
    ('Introduction to Sociology', 'Basic concepts in sociology, including culture, social structure, and institutions.', 3),
    ('Computer Networks', 'Learn about computer network architecture, protocols, and security.', 4),
    ('Artificial Intelligence', 'Study the principles of artificial intelligence and machine learning.', 3),
    ('Software Engineering', 'Learn software development methodologies, including Agile and Scrum.', 4),
    ('Fundamentals of Economics', 'Basic principles of economics, including supply and demand, and market theory.', 3),
    ('Statistics and Probability', 'Introduction to probability theory and statistical methods for data analysis.', 3),
    ('Human-Computer Interaction', 'Study how humans interact with computers and how to design user-friendly systems.', 3),
    ('Algorithms for Data Science', 'Advanced algorithms used in data analysis and machine learning.', 4),
    ('Business Management', 'Learn the fundamentals of business management, including marketing and finance.', 3),
    ('Digital Signal Processing', 'Learn how to process signals, including filtering and Fourier transforms.', 4),
    ('Game Development', 'Learn how to design and develop video games using popular game engines.', 3),
    ('Network Security', 'Study the principles and techniques used to secure computer networks.', 4),
    ('Modern Physics', 'Learn about quantum mechanics, relativity, and particle physics.', 3),
    ('Ethics in Technology', 'Study the ethical issues arising from the development and use of technology.', 3),
    ('Machine Learning', 'Introduction to machine learning techniques, including supervised and unsupervised learning.', 4),
    ('Mobile Application Development', 'Learn how to build mobile apps for Android and iOS using modern development tools.', 3),
    ('Creative Writing', 'Develop skills in narrative storytelling, character development, and creative writing techniques.', 3);

-- North Campus Courses (18 courses)
INSERT INTO Courses (CourseName, CourseDescription, CreditHours) VALUES
    ('Introduction to Programming', 'Learn the basics of programming using Python.', 3),
    ('Introduction to Data Science', 'Introduction to the concepts and methods of data science using real-world datasets.', 3),
    ('Advanced Algorithms', 'Study advanced algorithms used in computer science and their applications.', 4),
    ('Discrete Structures', 'Explore the mathematical structures used in computing, including graphs and trees.', 3),
    ('Introduction to Artificial Intelligence', 'Learn the fundamentals of AI, including search algorithms and game playing.', 3),
    ('Computer Graphics', 'Introduction to graphics programming and 3D modeling.', 3),
    ('Principles of Economics', 'Learn about the basic principles of microeconomics and macroeconomics.', 3),
    ('Database Management Systems', 'Study the theory and implementation of database systems and SQL.', 4),
    ('Linear Programming', 'Learn optimization techniques and methods used in operations research.', 3),
    ('Introduction to Sociology', 'Basic concepts of sociology, focusing on social behavior and institutions.', 3),
    ('Software Development Life Cycle', 'Study software development methodologies and life cycles.', 3),
    ('Machine Learning Fundamentals', 'Learn about machine learning techniques and algorithms for predictive modeling.', 4),
    ('Digital Electronics', 'Introduction to digital circuits, logic gates, and electronic components.', 3),
    ('Web Application Development', 'Learn to design and develop dynamic web applications using HTML, CSS, and JavaScript.', 3),
    ('Data Structures', 'Study common data structures and their applications in programming.', 3),
    ('Introduction to Programming in Java', 'Learn Java programming and object-oriented design principles.', 3),
    ('Computer Vision', 'Study the principles of computer vision and image processing algorithms.', 4),
    ('Networking Fundamentals', 'Learn about networking concepts including protocols, IP addressing, and routing.', 3),
    ('Digital Marketing', 'Learn about online marketing strategies, SEO, and social media marketing.', 3);

-- South Campus Courses (19 courses)
INSERT INTO Courses (CourseName, CourseDescription, CreditHours) VALUES
    ('Introduction to Programming', 'Learn the basics of programming using Python.', 3),
    ('Data Science Fundamentals', 'Introduction to data science, including data manipulation, visualization, and statistics.', 3),
    ('Object-Oriented Programming', 'Learn object-oriented design and programming using Java.', 3),
    ('Calculus I', 'Introduction to calculus, focusing on limits, derivatives, and integrals.', 3),
    ('Microeconomics', 'Learn about the theory of supply and demand, market structures, and pricing.', 3),
    ('Linear Algebra', 'Learn the fundamentals of linear algebra, including matrices, vectors, and eigenvalues.', 3),
    ('Database Management', 'Study relational database management systems and SQL basics.', 3),
    ('Web Development', 'Learn how to design and develop responsive web applications using HTML, CSS, and JavaScript.', 3),
    ('Computer Networks', 'Learn about computer network protocols, IP addressing, and the internet.', 4),
    ('Psychology 101', 'Introduction to psychology, covering cognition, behavior, and mental processes.', 3),
    ('Advanced Data Structures', 'Study advanced data structures such as heaps, graphs, and tries.', 3),
    ('Digital Electronics', 'Study digital circuits, logic gates, and binary numbers.', 3),
    ('Introduction to Philosophy', 'Explore major philosophical topics and thinkers in the Western tradition.', 3),
    ('Software Engineering', 'Learn software development methodologies, including Agile and Scrum.', 4),
    ('Marketing Fundamentals', 'Introduction to marketing strategies, consumer behavior, and advertising.', 3),
    ('Mobile App Development', 'Learn the basics of mobile application development using Flutter or React Native.', 3),
    ('Artificial Intelligence', 'Study machine learning algorithms, neural networks, and AI applications.', 4),
    ('Cloud Computing', 'Learn the fundamentals of cloud infrastructure, platforms, and services.', 3),
    ('Game Design', 'Learn game development techniques including 2D and 3D game design.', 3),
    ('Human-Computer Interaction', 'Study the design of user interfaces and the interaction between users and systems.', 3);

-- Inserting Prerequisites for Courses
-- Main Campus Courses
INSERT INTO CoursePrerequisites (CourseID, PrerequisiteID) VALUES
    (4001, NULL),  -- Introduction to Computer Science has no prerequisite
    (4002, 4001),  -- Data Structures and Algorithms requires Introduction to Computer Science
    (4003, 4001),  -- Database Systems requires Introduction to Computer Science
    (4004, NULL),  -- Web Development has no prerequisite
    (4005, NULL),  -- Discrete Mathematics has no prerequisite
    (4006, 4001),  -- Operating Systems requires Introduction to Computer Science
    (4007, NULL),  -- Linear Algebra has no prerequisite
    (4008, NULL),  -- Calculus I has no prerequisite
    (4009, NULL),  -- Psychology 101 has no prerequisite
    (4010, NULL),  -- Introduction to Philosophy has no prerequisite
    (4011, 4008),  -- Calculus II requires Calculus I
    (4012, NULL),  -- Introduction to Sociology has no prerequisite
    (4013, 4002),  -- Computer Networks requires Data Structures and Algorithms
    (4014, 4002),  -- Artificial Intelligence requires Data Structures and Algorithms
    (4015, 4002),  -- Software Engineering requires Data Structures and Algorithms
    (4016, NULL),  -- Fundamentals of Economics has no prerequisite
    (4017, NULL),  -- Statistics and Probability has no prerequisite
    (4018, NULL),  -- Human-Computer Interaction has no prerequisite
    (4019, 4002),  -- Algorithms for Data Science requires Data Structures and Algorithms
    (4020, NULL),  -- Business Management has no prerequisite
    (4021, 4002),  -- Digital Signal Processing requires Data Structures and Algorithms
    (4022, 4002),  -- Network Security requires Data Structures and Algorithms
    (4023, NULL),  -- Modern Physics has no prerequisite
    (4024, NULL),  -- Ethics in Technology has no prerequisite
    (4025, 4019),  -- Machine Learning requires Algorithms for Data Science
    (4026, NULL),  -- Mobile Application Development has no prerequisite
    (4027, NULL);  -- Creative Writing has no prerequisite

-- North Campus Courses
INSERT INTO CoursePrerequisites (CourseID, PrerequisiteID) VALUES
	(4028, NULL),  -- Introduction to Programming has no prerequisite
	(4029, NULL),  -- Introduction to Data Science has no prerequisite
    (4030, 4029),  -- Advanced Algorithms requires Data Structures
    (4031, NULL),  -- Discrete Structures has no prerequisite
    (4032, NULL),  -- Introduction to Artificial Intelligence has no prerequisite
    (4033, NULL),  -- Computer Graphics has no prerequisite
    (4034, NULL),  -- Principles of Economics has no prerequisite
    (4035, 4034),  -- Database Management Systems requires Principles of Economics
    (4036, NULL),  -- Linear Programming has no prerequisite
    (4037, NULL),  -- Introduction to Sociology has no prerequisite
    (4038, NULL),  -- Software Development Life Cycle has no prerequisite
    (4039, 4037),  -- Machine Learning Fundamentals requires Introduction to Sociology
    (4040, NULL),  -- Digital Electronics has no prerequisite
    (4041, 4028),  -- Web Application Development requires Introduction to Programming
    (4042, 4028),  -- Data Structures requires Introduction to Programming
    (4043, 4030),  -- Computer Vision requires Advanced Algorithms
    (4044, NULL),  -- Networking Fundamentals has no prerequisite
    (4045, NULL);  -- Digital Marketing has no prerequisite

-- South Campus Courses
INSERT INTO CoursePrerequisites (CourseID, PrerequisiteID) VALUES
    (4046, NULL),  -- Introduction to Programming has no prerequisite
    (4047, NULL),  -- Data Science Fundamentals has no prerequisite
    (4048, 4046),  -- Object-Oriented Programming requires Introduction to Programming
    (4049, NULL),  -- Calculus I has no prerequisite
    (4050, NULL),  -- Microeconomics has no prerequisite
    (4051, NULL),  -- Linear Algebra has no prerequisite
    (4052, 4042),  -- Database Management requires Data Structures
    (4053, NULL),  -- Web Development has no prerequisite
    (4054, 4042),  -- Computer Networks requires Data Structures
    (4055, NULL),  -- Psychology 101 has no prerequisite
    (4056, 4042),  -- Advanced Data Structures requires Data Structures
    (4057, NULL),  -- Digital Electronics has no prerequisite
    (4058, NULL),  -- Introduction to Philosophy has no prerequisite
    (4059, 4046),  -- Software Engineering requires Introduction to Programming
    (4060, NULL),  -- Marketing Fundamentals has no prerequisite
    (4061, NULL),  -- Mobile App Development has no prerequisite
    (4062, 4056),  -- Artificial Intelligence requires Advanced Data Structures
    (4063, 4042),  -- Cloud Computing requires Data Structures
    (4064, NULL),  -- Game Design has no prerequisite
    (4065, NULL);  -- Human-Computer Interaction has no prerequisite

-- Main Campus Section Times with 30-minute intervals for all 27 classes
INSERT INTO SectionTimes (CampusID, CourseID, TeacherID, ScheduleDay, ScheduleStartTime, ScheduleEndTime, StartDate, EndDate, Semester) VALUES
    (1, 4001, 2009, 'Monday', '08:00:00', '08:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Introduction to Computer Science
    (1, 4002, 2009, 'Monday', '08:30:00', '09:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Data Structures and Algorithms
    (1, 4003, 2009, 'Monday', '09:00:00', '09:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Database Systems
    (1, 4004, 2009, 'Monday', '09:30:00', '10:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Web Development
    (1, 4005, 2009, 'Monday', '10:00:00', '10:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Discrete Mathematics
    (1, 4006, 2009, 'Monday', '10:30:00', '11:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Operating Systems
    (1, 4001, 2005, 'Tuesday', '08:00:00', '08:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Linear Algebra
    (1, 4002, 2005, 'Tuesday', '08:30:00', '09:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Calculus I
    (1, 4003, 2005, 'Tuesday', '09:00:00', '09:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Psychology 101
    (1, 4004, 2005, 'Tuesday', '09:30:00', '10:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Introduction to Philosophy
    (1, 4005, 2005, 'Tuesday', '10:00:00', '10:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Calculus II
    (1, 4006, 2005, 'Tuesday', '10:30:00', '11:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Introduction to Sociology
    (1, 4001, 2007, 'Wednesday', '08:00:00', '08:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Computer Networks
    (1, 4002, 2007, 'Wednesday', '08:30:00', '09:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Artificial Intelligence
    (1, 4003, 2007, 'Wednesday', '09:00:00', '09:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Software Engineering
    (1, 4004, 2007, 'Wednesday', '09:30:00', '10:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Fundamentals of Economics
    (1, 4005, 2007, 'Wednesday', '10:00:00', '10:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Statistics and Probability
    (1, 4006, 2007, 'Wednesday', '10:30:00', '11:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Human-Computer Interaction
    (1, 4001, 2009, 'Thursday', '08:00:00', '08:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Algorithms for Data Science
    (1, 4002, 2009, 'Thursday', '08:30:00', '09:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Business Management
    (1, 4003, 2009, 'Thursday', '09:00:00', '09:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Digital Signal Processing
    (1, 4004, 2009, 'Thursday', '09:30:00', '10:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Game Development
    (1, 4005, 2009, 'Thursday', '10:00:00', '10:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Network Security
    (1, 4006, 2009, 'Thursday', '10:30:00', '11:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Modern Physics
    (1, 4001, 2005, 'Friday', '08:00:00', '08:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Ethics in Technology
    (1, 4002, 2005, 'Friday', '08:30:00', '09:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Machine Learning
    (1, 4003, 2005, 'Friday', '09:00:00', '09:30:00', '2022-08-01', '2022-12-31', 'Fall'), -- Mobile Application Development
    (1, 4004, 2005, 'Friday', '09:30:00', '10:00:00', '2022-08-01', '2022-12-31', 'Fall'), -- Creative Writing
    (1, 4005, 2005, 'Friday', '10:00:00', '10:30:00', '2022-08-01', '2022-12-31', 'Fall'); -- Final class for Main Campus

-- Campus 2 Section Times with 30-minute intervals for all 18 classes
INSERT INTO SectionTimes (CampusID, CourseID, TeacherID, ScheduleDay, ScheduleStartTime, ScheduleEndTime, StartDate, EndDate, Semester) VALUES
    (2, 4027, 2001, 'Monday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Programming
    (2, 4032, 2001, 'Monday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Data Science
    (2, 4037, 2002, 'Monday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Advanced Algorithms
    (2, 4042, 2006, 'Monday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Discrete Structures
    (2, 4028, 2001, 'Tuesday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Artificial Intelligence
    (2, 4029, 2001, 'Tuesday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Computer Graphics
    (2, 4030, 2001, 'Tuesday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Principles of Economics
    (2, 4031, 2001, 'Tuesday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Database Management Systems
    (2, 4033, 2002, 'Wednesday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Linear Programming
    (2, 4034, 2002, 'Wednesday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Sociology
    (2, 4035, 2002, 'Wednesday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Software Development Life Cycle
    (2, 4036, 2002, 'Wednesday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Machine Learning Fundamentals
    (2, 4038, 2002, 'Thursday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Digital Electronics
    (2, 4039, 2006, 'Thursday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Web Application Development
    (2, 4040, 2006, 'Thursday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Data Structures
    (2, 4041, 2006, 'Thursday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Programming in Java
    (2, 4043, 2006, 'Friday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Computer Vision
    (2, 4044, 2006, 'Friday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'); -- Networking Fundamentals

-- Campus 3 Section Times with 30-minute intervals for all 19 classes
INSERT INTO SectionTimes (CampusID, CourseID, TeacherID, ScheduleDay, ScheduleStartTime, ScheduleEndTime, StartDate, EndDate, Semester) VALUES
    (3, 4045, 2003, 'Monday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Programming
    (3, 4046, 2003, 'Monday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Data Science Fundamentals
    (3, 4047, 2003, 'Monday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Object-Oriented Programming
    (3, 4048, 2003, 'Monday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Calculus I
    (3, 4049, 2003, 'Tuesday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Microeconomics
    (3, 4050, 2003, 'Tuesday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Linear Algebra
    (3, 4051, 2003, 'Tuesday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Database Management
    (3, 4052, 2003, 'Tuesday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Web Development
    (3, 4053, 2003, 'Wednesday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Computer Networks
    (3, 4054, 2003, 'Wednesday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Psychology 101
    (3, 4055, 2003, 'Wednesday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Advanced Data Structures
    (3, 4056, 2003, 'Wednesday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Digital Electronics
    (3, 4057, 2003, 'Thursday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Introduction to Philosophy
    (3, 4058, 2003, 'Thursday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Software Engineering
    (3, 4059, 2003, 'Thursday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Marketing Fundamentals
    (3, 4060, 2003, 'Thursday', '09:30:00', '10:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Mobile App Development
    (3, 4061, 2003, 'Friday', '08:00:00', '08:30:00', '2022-07-20', '2022-12-20', 'Fall'), -- Artificial Intelligence
    (3, 4062, 2003, 'Friday', '08:30:00', '09:00:00', '2022-07-20', '2022-12-20', 'Fall'), -- Cloud Computing
    (3, 4063, 2003, 'Friday', '09:00:00', '09:30:00', '2022-07-20', '2022-12-20', 'Fall'); -- Game Design

-- Class History for Campus 1
INSERT INTO StudentClassHistory (SectionID, StudentID) VALUES
	(1, 1000), (2, 1000), (3, 1000), (4, 1000),  -- John Doe
	(1, 1001), (2, 1001), (3, 1001), (4, 1001),  -- Jane Smith
	(5, 1002), (6, 1002), (7, 1002), (8, 1002),  -- Alice Johnson
	(9, 1003), (10, 1003), (11, 1003), (12, 1003),  -- Bob Brown
	(13, 1004), (14, 1004), (15, 1004), (16, 1004),  -- Charlie Davis
	(1, 1005), (2, 1005), (3, 1005), (4, 1005),  -- Diana Miller
	(17, 1006), (18, 1006), (19, 1006), (20, 1006),  -- Evan Lee
	(21, 1007), (22, 1007), (23, 1007), (24, 1007),  -- Fiona Moore
	(25, 1008), (26, 1008), (27, 1008), (28, 1008),  -- George Harris
	(29, 1009), (30, 1009), (31, 1009), (32, 1009),  -- Hannah Walker
	(33, 1010), (34, 1010), (35, 1010), (36, 1010),  -- Ivy Scott
	(37, 1011), (38, 1011), (39, 1011), (40, 1011),  -- Jackie King
	(41, 1012), (42, 1012), (43, 1012), (44, 1012);  -- Kevin Lee

-- Class History for Campus 2
INSERT INTO StudentClassHistory (SectionID, StudentID) VALUES
	(1, 1015), (2, 1015), (3, 1015), (4, 1015),  -- Nina Carter
	(5, 1016), (6, 1016), (7, 1016), (8, 1016),  -- Oliver Perez
	(9, 1017), (10, 1017), (11, 1017), (12, 1017),  -- Paul Adams
	(13, 1018), (14, 1018), (15, 1018), (16, 1018),  -- Quincy Reed
	(17, 1019), (18, 1019), (19, 1019), (20, 1019),  -- Rachel Evans
	(21, 1020), (22, 1020), (23, 1020), (24, 1020),  -- Sophia Walker
	(25, 1021), (26, 1021), (27, 1021), (28, 1021),  -- Thomas Green
	(29, 1022), (30, 1022), (31, 1022), (32, 1022),  -- Ursula Ward
	(33, 1023), (34, 1023), (35, 1023), (36, 1023),  -- Vera Scott
	(37, 1024), (38, 1024), (39, 1024), (40, 1024),  -- Walter Harris
	(41, 1025), (42, 1025), (43, 1025), (44, 1025),  -- Xander Clark
	(45, 1026), (46, 1026), (47, 1026), (48, 1026);  -- Yasmine Lee

-- Class History for Campus 3
INSERT INTO StudentClassHistory (SectionID, StudentID) VALUES
    (1, 1030), (2, 1030), (3, 1030), (4, 1030),  -- Isla Scott
    (5, 1031), (6, 1031), (7, 1031), (8, 1031),  -- Jack Hunter
    (9, 1032), (10, 1032), (11, 1032), (12, 1032),  -- Kayla Lewis
    (13, 1033), (14, 1033), (15, 1033), (16, 1033),  -- Luna Moore
    (17, 1034), (18, 1034), (19, 1034), (20, 1034),  -- Miles Walker
    (21, 1035), (22, 1035), (23, 1035), (24, 1035),  -- Nina Lee
    (25, 1036), (26, 1036), (27, 1036), (28, 1036),  -- Owen King
    (29, 1037), (30, 1037), (31, 1037), (32, 1037),  -- Penelope Rose
    (33, 1038), (34, 1038), (35, 1038), (36, 1038),  -- Xander Clark
    (37, 1039), (38, 1039), (39, 1039), (40, 1039),  -- Clara Adams
    (41, 1040), (42, 1040), (43, 1040), (44, 1040),  -- Daniel Miller
    (45, 1041), (46, 1041), (47, 1041), (48, 1041),  -- Ella Thompson
    (49, 1042), (50, 1042), (51, 1042), (52, 1042),  -- Additional Students
    (53, 1043), (54, 1043), (55, 1043), (56, 1043);  -- Additional Students


-- Payments for Student 1000
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1000, '2022-03-01', 450.00, 'Card', 'Completed'),
    (1000, '2022-03-15', 400.00, 'Card', 'Completed'),
    (1000, '2022-04-01', 350.00, 'Bank Transfer', 'Completed'),
    (1000, '2022-04-15', 500.00, 'Cash', 'Completed'),
    (1000, '2022-05-01', 550.00, 'Card', 'Pending'),
    (1000, '2022-05-15', 600.00, 'Card', 'Completed'),
    (1000, '2022-06-01', 650.00, 'Bank Transfer', 'Completed'),
    (1000, '2022-06-15', 700.00, 'Cash', 'Completed'),
    (1000, '2022-07-01', 750.00, 'Card', 'Completed'),
    (1000, '2022-07-15', 800.00, 'Card', 'Completed'),
    (1000, '2022-08-01', 850.00, 'Bank Transfer', 'Completed'),
    (1000, '2022-08-15', 900.00, 'Cash', 'Completed'),

-- Payments for Student 1001
    (1001, '2022-03-01', 400.00, 'Card', 'Completed'),
    (1001, '2022-03-15', 350.00, 'Bank Transfer', 'Completed'),
    (1001, '2022-04-01', 450.00, 'Card', 'Completed'),
    (1001, '2022-04-15', 500.00, 'Cash', 'Completed'),
    (1001, '2022-05-01', 600.00, 'Card', 'Pending'),
    (1001, '2022-05-15', 650.00, 'Bank Transfer', 'Completed'),
    (1001, '2022-06-01', 700.00, 'Cash', 'Completed'),
    (1001, '2022-06-15', 750.00, 'Card', 'Completed'),
    (1001, '2022-07-01', 800.00, 'Card', 'Completed'),
    (1001, '2022-07-15', 850.00, 'Bank Transfer', 'Completed'),
    (1001, '2022-08-01', 900.00, 'Cash', 'Completed'),
    (1001, '2022-08-15', 950.00, 'Card', 'Completed'),

-- Payments for Student 1002
    (1002, '2022-03-02', 550.00, 'Card', 'Completed'),
    (1002, '2022-03-16', 600.00, 'Card', 'Completed'),
    (1002, '2022-04-02', 650.00, 'Bank Transfer', 'Completed'),
    (1002, '2022-04-16', 700.00, 'Cash', 'Completed'),
    (1002, '2022-05-02', 750.00, 'Card', 'Pending'),
    (1002, '2022-05-16', 800.00, 'Card', 'Completed'),
    (1002, '2022-06-02', 850.00, 'Bank Transfer', 'Completed'),
    (1002, '2022-06-16', 900.00, 'Cash', 'Completed'),
    (1002, '2022-07-02', 950.00, 'Card', 'Completed'),
    (1002, '2022-07-16', 1000.00, 'Card', 'Completed'),
    (1002, '2022-08-02', 1050.00, 'Bank Transfer', 'Completed'),
    (1002, '2022-08-16', 1100.00, 'Cash', 'Completed'),

-- Payments for Student 1003
    (1003, '2022-03-03', 450.00, 'Bank Transfer', 'Completed'),
    (1003, '2022-03-17', 400.00, 'Card', 'Completed'),
    (1003, '2022-04-03', 350.00, 'Card', 'Completed'),
    (1003, '2022-04-17', 500.00, 'Cash', 'Completed'),
    (1003, '2022-05-03', 550.00, 'Bank Transfer', 'Completed'),
    (1003, '2022-05-17', 600.00, 'Card', 'Completed'),
    (1003, '2022-06-03', 650.00, 'Card', 'Completed'),
    (1003, '2022-06-17', 700.00, 'Cash', 'Completed'),
    (1003, '2022-07-03', 750.00, 'Bank Transfer', 'Completed'),
    (1003, '2022-07-17', 800.00, 'Card', 'Pending'),
    (1003, '2022-08-03', 850.00, 'Card', 'Completed'),
    (1003, '2022-08-17', 900.00, 'Cash', 'Completed'),

-- Payments for Student 1004
    (1004, '2022-03-04', 550.00, 'Card', 'Completed'),
    (1004, '2022-03-18', 600.00, 'Bank Transfer', 'Completed'),
    (1004, '2022-04-04', 650.00, 'Card', 'Completed'),
    (1004, '2022-04-18', 700.00, 'Cash', 'Completed'),
    (1004, '2022-05-04', 750.00, 'Card', 'Completed'),
    (1004, '2022-05-18', 800.00, 'Bank Transfer', 'Completed'),
    (1004, '2022-06-04', 850.00, 'Card', 'Completed'),
    (1004, '2022-06-18', 900.00, 'Cash', 'Completed'),
    (1004, '2022-07-04', 950.00, 'Card', 'Completed'),
    (1004, '2022-07-18', 1000.00, 'Bank Transfer', 'Pending'),
    (1004, '2022-08-04', 1050.00, 'Card', 'Completed'),
    (1004, '2022-08-18', 1100.00, 'Cash', 'Completed');

-- Payments for Student 1005
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1005, '2022-03-05', 450.00, 'Bank Transfer', 'Completed'),
    (1005, '2022-03-19', 500.00, 'Card', 'Completed'),
    (1005, '2022-04-05', 550.00, 'Card', 'Completed'),
    (1005, '2022-04-19', 600.00, 'Cash', 'Completed'),
    (1005, '2022-05-05', 650.00, 'Bank Transfer', 'Completed'),
    (1005, '2022-05-19', 700.00, 'Card', 'Completed'),
    (1005, '2022-06-05', 750.00, 'Card', 'Completed'),
    (1005, '2022-06-19', 800.00, 'Cash', 'Completed'),
    (1005, '2022-07-05', 850.00, 'Bank Transfer', 'Completed'),
    (1005, '2022-07-19', 900.00, 'Card', 'Completed'),
    (1005, '2022-08-05', 950.00, 'Card', 'Completed'),
    (1005, '2022-08-19', 1000.00, 'Cash', 'Completed'),

-- Payments for Student 1006
    (1006, '2022-03-06', 400.00, 'Cash', 'Completed'),
    (1006, '2022-03-20', 450.00, 'Card', 'Completed'),
    (1006, '2022-04-06', 500.00, 'Bank Transfer', 'Completed'),
    (1006, '2022-04-20', 550.00, 'Card', 'Completed'),
    (1006, '2022-05-06', 600.00, 'Card', 'Completed'),
    (1006, '2022-05-20', 650.00, 'Bank Transfer', 'Completed'),
    (1006, '2022-06-06', 700.00, 'Card', 'Completed'),
    (1006, '2022-06-20', 750.00, 'Card', 'Completed'),
    (1006, '2022-07-06', 800.00, 'Bank Transfer', 'Completed'),
    (1006, '2022-07-20', 850.00, 'Card', 'Completed'),
    (1006, '2022-08-06', 900.00, 'Card', 'Completed'),
    (1006, '2022-08-20', 950.00, 'Bank Transfer', 'Completed'),

-- Payments for Student 1007
    (1007, '2022-03-07', 500.00, 'Bank Transfer', 'Completed'),
    (1007, '2022-03-21', 550.00, 'Card', 'Completed'),
    (1007, '2022-04-07', 600.00, 'Card', 'Completed'),
    (1007, '2022-04-21', 650.00, 'Cash', 'Completed'),
    (1007, '2022-05-07', 700.00, 'Bank Transfer', 'Completed'),
    (1007, '2022-05-21', 750.00, 'Card', 'Completed'),
    (1007, '2022-06-07', 800.00, 'Card', 'Completed'),
    (1007, '2022-06-21', 850.00, 'Cash', 'Completed'),
    (1007, '2022-07-07', 900.00, 'Bank Transfer', 'Completed'),
    (1007, '2022-07-21', 950.00, 'Card', 'Completed'),
    (1007, '2022-08-07', 1000.00, 'Card', 'Completed'),
    (1007, '2022-08-21', 1050.00, 'Cash', 'Completed'),

-- Payments for Student 1008
    (1008, '2022-03-08', 450.00, 'Card', 'Completed'),
    (1008, '2022-03-22', 500.00, 'Card', 'Completed'),
    (1008, '2022-04-08', 550.00, 'Bank Transfer', 'Completed'),
    (1008, '2022-04-22', 600.00, 'Cash', 'Completed'),
    (1008, '2022-05-08', 650.00, 'Card', 'Completed'),
    (1008, '2022-05-22', 700.00, 'Card', 'Completed'),
    (1008, '2022-06-08', 750.00, 'Bank Transfer', 'Completed'),
    (1008, '2022-06-22', 800.00, 'Cash', 'Completed'),
    (1008, '2022-07-08', 850.00, 'Card', 'Completed'),
    (1008, '2022-07-22', 900.00, 'Card', 'Completed'),
    (1008, '2022-08-08', 950.00, 'Bank Transfer', 'Completed'),
    (1008, '2022-08-22', 1000.00, 'Cash', 'Completed'),

-- Payments for Student 1009
    (1009, '2022-03-09', 500.00, 'Bank Transfer', 'Completed'),
    (1009, '2022-03-23', 550.00, 'Card', 'Completed'),
    (1009, '2022-04-09', 600.00, 'Card', 'Completed'),
    (1009, '2022-04-23', 650.00, 'Cash', 'Completed'),
    (1009, '2022-05-09', 700.00, 'Bank Transfer', 'Completed'),
    (1009, '2022-05-23', 750.00, 'Card', 'Completed'),
    (1009, '2022-06-09', 800.00, 'Card', 'Completed'),
    (1009, '2022-06-23', 850.00, 'Cash', 'Completed'),
    (1009, '2022-07-09', 900.00, 'Bank Transfer', 'Completed'),
    (1009, '2022-07-23', 950.00, 'Card', 'Completed'),
    (1009, '2022-08-09', 1000.00, 'Card', 'Completed'),
    (1009, '2022-08-23', 1050.00, 'Cash', 'Completed');

-- Payments for Student 1010
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1010, '2022-03-10', 550.00, 'Card', 'Completed'),
    (1010, '2022-03-24', 600.00, 'Bank Transfer', 'Completed'),
    (1010, '2022-04-10', 650.00, 'Card', 'Completed'),
    (1010, '2022-04-24', 700.00, 'Cash', 'Completed'),
    (1010, '2022-05-10', 750.00, 'Card', 'Completed'),
    (1010, '2022-05-24', 800.00, 'Bank Transfer', 'Completed'),
    (1010, '2022-06-10', 850.00, 'Card', 'Completed'),
    (1010, '2022-06-24', 900.00, 'Cash', 'Completed'),
    (1010, '2022-07-10', 950.00, 'Card', 'Completed'),
    (1010, '2022-07-24', 1000.00, 'Bank Transfer', 'Completed'),
    (1010, '2022-08-10', 1050.00, 'Card', 'Completed'),
    (1010, '2022-08-24', 1100.00, 'Cash', 'Completed'),

-- Payments for Student 1011
    (1011, '2022-03-11', 600.00, 'Card', 'Completed'),
    (1011, '2022-03-25', 650.00, 'Card', 'Completed'),
    (1011, '2022-04-11', 700.00, 'Bank Transfer', 'Completed'),
    (1011, '2022-04-25', 750.00, 'Cash', 'Completed'),
    (1011, '2022-05-11', 800.00, 'Card', 'Completed'),
    (1011, '2022-05-25', 850.00, 'Card', 'Completed'),
    (1011, '2022-06-11', 900.00, 'Bank Transfer', 'Completed'),
    (1011, '2022-06-25', 950.00, 'Cash', 'Completed'),
    (1011, '2022-07-11', 1000.00, 'Card', 'Completed'),
    (1011, '2022-07-25', 1050.00, 'Bank Transfer', 'Completed'),
    (1011, '2022-08-11', 1100.00, 'Card', 'Completed'),
    (1011, '2022-08-25', 1150.00, 'Cash', 'Completed'),

-- Payments for Student 1012
    (1012, '2022-03-12', 650.00, 'Bank Transfer', 'Completed'),
    (1012, '2022-03-26', 700.00, 'Card', 'Completed'),
    (1012, '2022-04-12', 750.00, 'Card', 'Completed'),
    (1012, '2022-04-26', 800.00, 'Cash', 'Completed'),
    (1012, '2022-05-12', 850.00, 'Bank Transfer', 'Completed'),
    (1012, '2022-05-26', 900.00, 'Card', 'Completed'),
    (1012, '2022-06-12', 950.00, 'Card', 'Completed'),
    (1012, '2022-06-26', 1000.00, 'Cash', 'Completed'),
    (1012, '2022-07-12', 1050.00, 'Bank Transfer', 'Completed'),
    (1012, '2022-07-26', 1100.00, 'Card', 'Completed'),
    (1012, '2022-08-12', 1150.00, 'Card', 'Completed'),
    (1012, '2022-08-26', 1200.00, 'Cash', 'Completed'),

-- Payments for Student 1013
    (1013, '2022-03-13', 700.00, 'Card', 'Completed'),
    (1013, '2022-03-27', 750.00, 'Bank Transfer', 'Completed'),
    (1013, '2022-04-13', 800.00, 'Cash', 'Completed'),
    (1013, '2022-04-27', 850.00, 'Card', 'Completed'),
    (1013, '2022-05-13', 900.00, 'Card', 'Completed'),
    (1013, '2022-05-27', 950.00, 'Bank Transfer', 'Completed'),
    (1013, '2022-06-13', 1000.00, 'Cash', 'Completed'),
    (1013, '2022-06-27', 1050.00, 'Card', 'Completed'),
    (1013, '2022-07-13', 1100.00, 'Card', 'Completed'),
    (1013, '2022-07-27', 1150.00, 'Bank Transfer', 'Completed'),
    (1013, '2022-08-13', 1200.00, 'Cash', 'Completed'),
    (1013, '2022-08-27', 1250.00, 'Card', 'Completed'),

-- Payments for Student 1014
    (1014, '2022-03-14', 750.00, 'Bank Transfer', 'Completed'),
    (1014, '2022-03-28', 800.00, 'Card', 'Completed'),
    (1014, '2022-04-14', 850.00, 'Cash', 'Completed'),
    (1014, '2022-04-28', 900.00, 'Card', 'Completed'),
    (1014, '2022-05-14', 950.00, 'Card', 'Completed'),
    (1014, '2022-05-28', 1000.00, 'Bank Transfer', 'Completed'),
    (1014, '2022-06-14', 1050.00, 'Cash', 'Completed'),
    (1014, '2022-06-28', 1100.00, 'Card', 'Completed'),
    (1014, '2022-07-14', 1150.00, 'Card', 'Completed'),
    (1014, '2022-07-28', 1200.00, 'Bank Transfer', 'Completed'),
    (1014, '2022-08-14', 1250.00, 'Cash', 'Completed'),
    (1014, '2022-08-28', 1300.00, 'Card', 'Completed');

-- Payments for Student 1015
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1015, '2022-03-15', 800.00, 'Card', 'Completed'),
    (1015, '2022-03-29', 850.00, 'Card', 'Completed'),
    (1015, '2022-04-15', 900.00, 'Bank Transfer', 'Completed'),
    (1015, '2022-04-29', 950.00, 'Cash', 'Completed'),
    (1015, '2022-05-15', 1000.00, 'Card', 'Completed'),
    (1015, '2022-05-29', 1050.00, 'Card', 'Completed'),
    (1015, '2022-06-15', 1100.00, 'Bank Transfer', 'Completed'),
    (1015, '2022-06-29', 1150.00, 'Cash', 'Completed'),
    (1015, '2022-07-15', 1200.00, 'Card', 'Completed'),
    (1015, '2022-07-29', 1250.00, 'Card', 'Completed'),
    (1015, '2022-08-15', 1300.00, 'Bank Transfer', 'Completed'),
    (1015, '2022-08-29', 1350.00, 'Cash', 'Completed');

-- Payments for Student 1016
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1016, '2022-03-16', 850.00, 'Bank Transfer', 'Completed'),
    (1016, '2022-03-30', 900.00, 'Card', 'Completed'),
    (1016, '2022-04-16', 950.00, 'Card', 'Completed'),
    (1016, '2022-04-30', 1000.00, 'Cash', 'Completed'),
    (1016, '2022-05-16', 1050.00, 'Bank Transfer', 'Completed'),
    (1016, '2022-05-30', 1100.00, 'Card', 'Completed'),
    (1016, '2022-06-16', 1150.00, 'Card', 'Completed'),
    (1016, '2022-06-30', 1200.00, 'Cash', 'Completed'),
    (1016, '2022-07-16', 1250.00, 'Bank Transfer', 'Completed'),
    (1016, '2022-07-30', 1300.00, 'Card', 'Completed'),
    (1016, '2022-08-16', 1350.00, 'Card', 'Completed'),
    (1016, '2022-08-30', 1400.00, 'Cash', 'Completed');

-- Payments for Student 1017
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1017, '2022-03-17', 900.00, 'Card', 'Completed'),
    (1017, '2022-03-31', 950.00, 'Bank Transfer', 'Completed'),
    (1017, '2022-04-17', 1000.00, 'Cash', 'Completed'),
    (1017, '2022-04-30', 1050.00, 'Card', 'Completed'),
    (1017, '2022-05-17', 1100.00, 'Card', 'Completed'),
    (1017, '2022-05-31', 1150.00, 'Bank Transfer', 'Completed'),
    (1017, '2022-06-17', 1200.00, 'Cash', 'Completed'),
    (1017, '2022-06-30', 1250.00, 'Card', 'Completed'),
    (1017, '2022-07-17', 1300.00, 'Card', 'Completed'),
    (1017, '2022-07-31', 1350.00, 'Bank Transfer', 'Completed'),
    (1017, '2022-08-17', 1400.00, 'Cash', 'Completed'),
    (1017, '2022-08-31', 1450.00, 'Card', 'Completed');

-- Payments for Student 1018
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1018, '2022-03-18', 950.00, 'Card', 'Completed'),
    (1018, '2022-04-01', 1000.00, 'Card', 'Completed'),
    (1018, '2022-04-18', 1050.00, 'Bank Transfer', 'Completed'),
    (1018, '2022-05-01', 1100.00, 'Cash', 'Completed'),
    (1018, '2022-05-18', 1150.00, 'Card', 'Completed'),
    (1018, '2022-06-01', 1200.00, 'Card', 'Completed'),
    (1018, '2022-06-18', 1250.00, 'Bank Transfer', 'Completed'),
    (1018, '2022-07-01', 1300.00, 'Cash', 'Completed'),
    (1018, '2022-07-18', 1350.00, 'Card', 'Completed'),
    (1018, '2022-08-01', 1400.00, 'Card', 'Completed'),
    (1018, '2022-08-18', 1450.00, 'Bank Transfer', 'Completed'),
    (1018, '2022-08-31', 1500.00, 'Cash', 'Completed');

-- Payments for Student 1019
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1019, '2022-03-19', 1000.00, 'Bank Transfer', 'Completed'),
    (1019, '2022-04-02', 1050.00, 'Card', 'Completed'),
    (1019, '2022-04-19', 1100.00, 'Card', 'Completed'),
    (1019, '2022-05-02', 1150.00, 'Cash', 'Completed'),
    (1019, '2022-05-19', 1200.00, 'Bank Transfer', 'Completed'),
    (1019, '2022-06-02', 1250.00, 'Card', 'Completed'),
    (1019, '2022-06-19', 1300.00, 'Card', 'Completed'),
    (1019, '2022-07-02', 1350.00, 'Cash', 'Completed'),
    (1019, '2022-07-19', 1400.00, 'Bank Transfer', 'Completed'),
    (1019, '2022-08-02', 1450.00, 'Card', 'Completed'),
    (1019, '2022-08-19', 1500.00, 'Card', 'Completed'),
    (1019, '2022-08-31', 1550.00, 'Cash', 'Completed');

-- Payments for Student 1020
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1020, '2022-03-20', 1050.00, 'Bank Transfer', 'Completed'),
    (1020, '2022-04-03', 1100.00, 'Card', 'Completed'),
    (1020, '2022-04-20', 1150.00, 'Card', 'Completed'),
    (1020, '2022-05-03', 1200.00, 'Cash', 'Completed'),
    (1020, '2022-05-20', 1250.00, 'Bank Transfer', 'Completed'),
    (1020, '2022-06-03', 1300.00, 'Card', 'Completed'),
    (1020, '2022-06-20', 1350.00, 'Card', 'Completed'),
    (1020, '2022-07-03', 1400.00, 'Cash', 'Completed'),
    (1020, '2022-07-20', 1450.00, 'Bank Transfer', 'Completed'),
    (1020, '2022-08-03', 1500.00, 'Card', 'Completed'),
    (1020, '2022-08-20', 1550.00, 'Card', 'Completed'),
    (1020, '2022-08-31', 1600.00, 'Cash', 'Completed');

-- Payments for Student 1021
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1021, '2022-03-21', 1100.00, 'Card', 'Completed'),
    (1021, '2022-04-04', 1150.00, 'Card', 'Completed'),
    (1021, '2022-04-21', 1200.00, 'Bank Transfer', 'Completed'),
    (1021, '2022-05-04', 1250.00, 'Cash', 'Completed'),
    (1021, '2022-05-21', 1300.00, 'Card', 'Completed'),
    (1021, '2022-06-04', 1350.00, 'Card', 'Completed'),
    (1021, '2022-06-21', 1400.00, 'Bank Transfer', 'Completed'),
    (1021, '2022-07-04', 1450.00, 'Cash', 'Completed'),
    (1021, '2022-07-21', 1500.00, 'Card', 'Completed'),
    (1021, '2022-08-04', 1550.00, 'Card', 'Completed'),
    (1021, '2022-08-21', 1600.00, 'Bank Transfer', 'Completed'),
    (1021, '2022-08-31', 1650.00, 'Cash', 'Completed');


-- Payments for Student 1022
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1022, '2022-03-22', 1150.00, 'Card', 'Completed'),
    (1022, '2022-04-05', 1200.00, 'Bank Transfer', 'Completed'),
    (1022, '2022-04-22', 1250.00, 'Card', 'Completed'),
    (1022, '2022-05-05', 1300.00, 'Card', 'Completed'),
    (1022, '2022-05-22', 1350.00, 'Cash', 'Completed'),
    (1022, '2022-06-05', 1400.00, 'Bank Transfer', 'Completed'),
    (1022, '2022-06-22', 1450.00, 'Card', 'Completed'),
    (1022, '2022-07-05', 1500.00, 'Card', 'Completed'),
    (1022, '2022-07-22', 1550.00, 'Bank Transfer', 'Completed'),
    (1022, '2022-08-05', 1600.00, 'Cash', 'Completed'),
    (1022, '2022-08-22', 1650.00, 'Card', 'Completed'),
    (1022, '2022-08-31', 1700.00, 'Card', 'Completed');

-- Payments for Student 1023
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1023, '2022-03-23', 1200.00, 'Cash', 'Completed'),
    (1023, '2022-04-06', 1250.00, 'Bank Transfer', 'Completed'),
    (1023, '2022-04-23', 1300.00, 'Card', 'Completed'),
    (1023, '2022-05-06', 1350.00, 'Card', 'Completed'),
    (1023, '2022-05-23', 1400.00, 'Cash', 'Completed'),
    (1023, '2022-06-06', 1450.00, 'Bank Transfer', 'Completed'),
    (1023, '2022-06-23', 1500.00, 'Card', 'Completed'),
    (1023, '2022-07-06', 1550.00, 'Card', 'Completed'),
    (1023, '2022-07-23', 1600.00, 'Bank Transfer', 'Completed'),
    (1023, '2022-08-06', 1650.00, 'Cash', 'Completed'),
    (1023, '2022-08-23', 1700.00, 'Card', 'Completed'),
    (1023, '2022-08-31', 1750.00, 'Card', 'Completed');

-- Payments for Student 1024
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1024, '2022-03-24', 1250.00, 'Card', 'Completed'),
    (1024, '2022-04-07', 1300.00, 'Bank Transfer', 'Completed'),
    (1024, '2022-04-24', 1350.00, 'Card', 'Completed'),
    (1024, '2022-05-07', 1400.00, 'Card', 'Completed'),
    (1024, '2022-05-24', 1450.00, 'Cash', 'Completed'),
    (1024, '2022-06-07', 1500.00, 'Bank Transfer', 'Completed'),
    (1024, '2022-06-24', 1550.00, 'Card', 'Completed'),
    (1024, '2022-07-07', 1600.00, 'Card', 'Completed'),
    (1024, '2022-07-24', 1650.00, 'Bank Transfer', 'Completed'),
    (1024, '2022-08-07', 1700.00, 'Cash', 'Completed'),
    (1024, '2022-08-24', 1750.00, 'Card', 'Completed'),
    (1024, '2022-08-31', 1800.00, 'Card', 'Completed');

-- Payments for Student 1025
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1025, '2022-03-25', 1300.00, 'Bank Transfer', 'Completed'),
    (1025, '2022-04-08', 1350.00, 'Card', 'Completed'),
    (1025, '2022-04-25', 1400.00, 'Card', 'Completed'),
    (1025, '2022-05-08', 1450.00, 'Cash', 'Completed'),
    (1025, '2022-05-25', 1500.00, 'Bank Transfer', 'Completed'),
    (1025, '2022-06-08', 1550.00, 'Card', 'Completed'),
    (1025, '2022-06-25', 1600.00, 'Card', 'Completed'),
    (1025, '2022-07-08', 1650.00, 'Bank Transfer', 'Completed'),
    (1025, '2022-07-25', 1700.00, 'Card', 'Completed'),
    (1025, '2022-08-08', 1750.00, 'Cash', 'Completed'),
    (1025, '2022-08-25', 1800.00, 'Card', 'Completed'),
    (1025, '2022-08-31', 1850.00, 'Card', 'Completed');

-- Payments for Student 1026
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1026, '2022-03-26', 1350.00, 'Bank Transfer', 'Completed'),
    (1026, '2022-04-09', 1400.00, 'Card', 'Completed'),
    (1026, '2022-04-26', 1450.00, 'Card', 'Completed'),
    (1026, '2022-05-09', 1500.00, 'Cash', 'Completed'),
    (1026, '2022-05-26', 1550.00, 'Bank Transfer', 'Completed'),
    (1026, '2022-06-09', 1600.00, 'Card', 'Completed'),
    (1026, '2022-06-26', 1650.00, 'Card', 'Completed'),
    (1026, '2022-07-09', 1700.00, 'Bank Transfer', 'Completed'),
    (1026, '2022-07-26', 1750.00, 'Card', 'Completed'),
    (1026, '2022-08-09', 1800.00, 'Cash', 'Completed'),
    (1026, '2022-08-26', 1850.00, 'Card', 'Completed'),
    (1026, '2022-08-31', 1900.00, 'Card', 'Completed');

-- Payments for Student 1027
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1027, '2022-03-27', 1400.00, 'Card', 'Completed'),
    (1027, '2022-04-10', 1450.00, 'Bank Transfer', 'Completed'),
    (1027, '2022-04-27', 1500.00, 'Cash', 'Completed'),
    (1027, '2022-05-10', 1550.00, 'Card', 'Completed'),
    (1027, '2022-05-27', 1600.00, 'Card', 'Completed'),
    (1027, '2022-06-10', 1650.00, 'Bank Transfer', 'Completed'),
    (1027, '2022-06-27', 1700.00, 'Card', 'Completed'),
    (1027, '2022-07-10', 1750.00, 'Card', 'Completed'),
    (1027, '2022-07-27', 1800.00, 'Bank Transfer', 'Completed'),
    (1027, '2022-08-10', 1850.00, 'Cash', 'Completed'),
    (1027, '2022-08-27', 1900.00, 'Card', 'Completed'),
    (1027, '2022-08-31', 1950.00, 'Card', 'Completed');

-- Payments for Student 1028
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1028, '2022-03-28', 1450.00, 'Bank Transfer', 'Completed'),
    (1028, '2022-04-11', 1500.00, 'Card', 'Completed'),
    (1028, '2022-04-28', 1550.00, 'Cash', 'Completed'),
    (1028, '2022-05-11', 1600.00, 'Card', 'Completed'),
    (1028, '2022-05-28', 1650.00, 'Bank Transfer', 'Completed'),
    (1028, '2022-06-11', 1700.00, 'Card', 'Completed'),
    (1028, '2022-06-28', 1750.00, 'Card', 'Completed'),
    (1028, '2022-07-11', 1800.00, 'Bank Transfer', 'Completed'),
    (1028, '2022-07-28', 1850.00, 'Cash', 'Completed'),
    (1028, '2022-08-11', 1900.00, 'Card', 'Completed'),
    (1028, '2022-08-28', 1950.00, 'Card', 'Completed'),
    (1028, '2022-08-31', 2000.00, 'Cash', 'Completed');

-- Payments for Student 1029
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1029, '2022-03-29', 1500.00, 'Bank Transfer', 'Completed'),
    (1029, '2022-04-12', 1550.00, 'Card', 'Completed'),
    (1029, '2022-04-29', 1600.00, 'Cash', 'Completed'),
    (1029, '2022-05-12', 1650.00, 'Card', 'Completed'),
    (1029, '2022-05-29', 1700.00, 'Bank Transfer', 'Completed'),
    (1029, '2022-06-12', 1750.00, 'Card', 'Completed'),
    (1029, '2022-06-29', 1800.00, 'Card', 'Completed'),
    (1029, '2022-07-12', 1850.00, 'Bank Transfer', 'Completed'),
    (1029, '2022-07-29', 1900.00, 'Cash', 'Completed'),
    (1029, '2022-08-12', 1950.00, 'Card', 'Completed'),
    (1029, '2022-08-29', 2000.00, 'Card', 'Completed'),
    (1029, '2022-08-31', 2050.00, 'Cash', 'Completed');

-- Payments for Student 1030
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1030, '2022-03-30', 1550.00, 'Card', 'Completed'),
    (1030, '2022-04-13', 1600.00, 'Bank Transfer', 'Completed'),
    (1030, '2022-04-30', 1650.00, 'Cash', 'Completed'),
    (1030, '2022-05-13', 1700.00, 'Card', 'Completed'),
    (1030, '2022-05-30', 1750.00, 'Card', 'Completed'),
    (1030, '2022-06-13', 1800.00, 'Bank Transfer', 'Completed'),
    (1030, '2022-06-30', 1850.00, 'Card', 'Completed'),
    (1030, '2022-07-13', 1900.00, 'Bank Transfer', 'Completed'),
    (1030, '2022-07-30', 1950.00, 'Cash', 'Completed'),
    (1030, '2022-08-13', 2000.00, 'Card', 'Completed'),
    (1030, '2022-08-30', 2050.00, 'Card', 'Completed'),
    (1030, '2022-08-31', 2100.00, 'Cash', 'Completed');

-- Payments for Student 1031
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1031, '2022-03-31', 1600.00, 'Bank Transfer', 'Completed'),
    (1031, '2022-04-14', 1650.00, 'Card', 'Completed'),
    (1031, '2022-05-01', 1700.00, 'Card', 'Completed'),
    (1031, '2022-05-14', 1750.00, 'Cash', 'Completed'),
    (1031, '2022-06-01', 1800.00, 'Bank Transfer', 'Completed'),
    (1031, '2022-06-14', 1850.00, 'Card', 'Completed'),
    (1031, '2022-07-01', 1900.00, 'Card', 'Completed'),
    (1031, '2022-07-14', 1950.00, 'Bank Transfer', 'Completed'),
    (1031, '2022-08-01', 2000.00, 'Card', 'Completed'),
    (1031, '2022-08-14', 2050.00, 'Cash', 'Completed'),
    (1031, '2022-08-31', 2100.00, 'Card', 'Completed');

-- Payments for Student 1032
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1032, '2022-04-02', 1650.00, 'Card', 'Completed'),
    (1032, '2022-04-15', 1700.00, 'Bank Transfer', 'Completed'),
    (1032, '2022-05-02', 1750.00, 'Card', 'Completed'),
    (1032, '2022-05-15', 1800.00, 'Cash', 'Completed'),
    (1032, '2022-06-02', 1850.00, 'Bank Transfer', 'Completed'),
    (1032, '2022-06-15', 1900.00, 'Card', 'Completed'),
    (1032, '2022-07-02', 1950.00, 'Card', 'Completed'),
    (1032, '2022-07-15', 2000.00, 'Bank Transfer', 'Completed'),
    (1032, '2022-08-02', 2050.00, 'Cash', 'Completed'),
    (1032, '2022-08-15', 2100.00, 'Card', 'Completed'),
    (1032, '2022-08-31', 2150.00, 'Card', 'Completed');

-- Payments for Student 1033
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1033, '2022-04-03', 1700.00, 'Bank Transfer', 'Completed'),
    (1033, '2022-04-16', 1750.00, 'Card', 'Completed'),
    (1033, '2022-05-03', 1800.00, 'Card', 'Completed'),
    (1033, '2022-05-16', 1850.00, 'Cash', 'Completed'),
    (1033, '2022-06-03', 1900.00, 'Bank Transfer', 'Completed'),
    (1033, '2022-06-16', 1950.00, 'Card', 'Completed'),
    (1033, '2022-07-03', 2000.00, 'Card', 'Completed'),
    (1033, '2022-07-16', 2050.00, 'Bank Transfer', 'Completed'),
    (1033, '2022-08-03', 2100.00, 'Cash', 'Completed'),
    (1033, '2022-08-16', 2150.00, 'Card', 'Completed'),
    (1033, '2022-08-31', 2200.00, 'Card', 'Completed');

-- Payments for Student 1034
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1034, '2022-04-04', 1750.00, 'Card', 'Completed'),
    (1034, '2022-04-17', 1800.00, 'Bank Transfer', 'Completed'),
    (1034, '2022-05-04', 1850.00, 'Card', 'Completed'),
    (1034, '2022-05-17', 1900.00, 'Cash', 'Completed'),
    (1034, '2022-06-04', 1950.00, 'Bank Transfer', 'Completed'),
    (1034, '2022-06-17', 2000.00, 'Card', 'Completed'),
    (1034, '2022-07-04', 2050.00, 'Card', 'Completed'),
    (1034, '2022-07-17', 2100.00, 'Bank Transfer', 'Completed'),
    (1034, '2022-08-04', 2150.00, 'Cash', 'Completed'),
    (1034, '2022-08-17', 2200.00, 'Card', 'Completed'),
    (1034, '2022-08-31', 2250.00, 'Card', 'Completed');

-- Payments for Student 1035
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1035, '2022-04-05', 1800.00, 'Card', 'Completed'),
    (1035, '2022-04-18', 1850.00, 'Bank Transfer', 'Completed'),
    (1035, '2022-05-05', 1900.00, 'Card', 'Completed'),
    (1035, '2022-05-18', 1950.00, 'Cash', 'Completed'),
    (1035, '2022-06-05', 2000.00, 'Bank Transfer', 'Completed'),
    (1035, '2022-06-18', 2050.00, 'Card', 'Completed'),
    (1035, '2022-07-05', 2100.00, 'Card', 'Completed'),
    (1035, '2022-07-18', 2150.00, 'Bank Transfer', 'Completed'),
    (1035, '2022-08-05', 2200.00, 'Cash', 'Completed'),
    (1035, '2022-08-18', 2250.00, 'Card', 'Completed'),
    (1035, '2022-08-31', 2300.00, 'Card', 'Completed');

-- Payments for Student 1036
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1036, '2022-04-06', 1850.00, 'Bank Transfer', 'Completed'),
    (1036, '2022-04-19', 1900.00, 'Card', 'Completed'),
    (1036, '2022-05-06', 1950.00, 'Card', 'Completed'),
    (1036, '2022-05-19', 2000.00, 'Cash', 'Completed'),
    (1036, '2022-06-06', 2050.00, 'Bank Transfer', 'Completed'),
    (1036, '2022-06-19', 2100.00, 'Card', 'Completed'),
    (1036, '2022-07-06', 2150.00, 'Card', 'Completed'),
    (1036, '2022-07-19', 2200.00, 'Bank Transfer', 'Completed'),
    (1036, '2022-08-06', 2250.00, 'Cash', 'Completed'),
    (1036, '2022-08-19', 2300.00, 'Card', 'Completed'),
    (1036, '2022-08-31', 2350.00, 'Card', 'Completed');

-- Payments for Student 1037
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1037, '2022-04-07', 1900.00, 'Card', 'Completed'),
    (1037, '2022-04-20', 1950.00, 'Bank Transfer', 'Completed'),
    (1037, '2022-05-07', 2000.00, 'Card', 'Completed'),
    (1037, '2022-05-20', 2050.00, 'Cash', 'Completed'),
    (1037, '2022-06-07', 2100.00, 'Bank Transfer', 'Completed'),
    (1037, '2022-06-20', 2150.00, 'Card', 'Completed'),
    (1037, '2022-07-07', 2200.00, 'Card', 'Completed'),
    (1037, '2022-07-20', 2250.00, 'Bank Transfer', 'Completed'),
    (1037, '2022-08-07', 2300.00, 'Cash', 'Completed'),
    (1037, '2022-08-20', 2350.00, 'Card', 'Completed'),
    (1037, '2022-08-31', 2400.00, 'Card', 'Completed');

-- Payments for Student 1038
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1038, '2022-04-08', 1950.00, 'Bank Transfer', 'Completed'),
    (1038, '2022-04-21', 2000.00, 'Card', 'Completed'),
    (1038, '2022-05-08', 2050.00, 'Card', 'Completed'),
    (1038, '2022-05-21', 2100.00, 'Cash', 'Completed'),
    (1038, '2022-06-08', 2150.00, 'Bank Transfer', 'Completed'),
    (1038, '2022-06-21', 2200.00, 'Card', 'Completed'),
    (1038, '2022-07-08', 2250.00, 'Card', 'Completed'),
    (1038, '2022-07-21', 2300.00, 'Bank Transfer', 'Completed'),
    (1038, '2022-08-08', 2350.00, 'Cash', 'Completed'),
    (1038, '2022-08-21', 2400.00, 'Card', 'Completed'),
    (1038, '2022-08-31', 2450.00, 'Card', 'Completed');

-- Payments for Student 1039
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1039, '2022-04-09', 2000.00, 'Card', 'Completed'),
    (1039, '2022-04-22', 2050.00, 'Bank Transfer', 'Completed'),
    (1039, '2022-05-09', 2100.00, 'Card', 'Completed'),
    (1039, '2022-05-22', 2150.00, 'Cash', 'Completed'),
    (1039, '2022-06-09', 2200.00, 'Bank Transfer', 'Completed'),
    (1039, '2022-06-22', 2250.00, 'Card', 'Completed'),
    (1039, '2022-07-09', 2300.00, 'Card', 'Completed'),
    (1039, '2022-07-22', 2350.00, 'Bank Transfer', 'Completed'),
    (1039, '2022-08-09', 2400.00, 'Cash', 'Completed'),
    (1039, '2022-08-22', 2450.00, 'Card', 'Completed'),
    (1039, '2022-08-31', 2500.00, 'Card', 'Completed');

-- Payments for Student 1040
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1040, '2022-04-10', 2050.00, 'Bank Transfer', 'Completed'),
    (1040, '2022-04-23', 2100.00, 'Card', 'Completed'),
    (1040, '2022-05-10', 2150.00, 'Card', 'Completed'),
    (1040, '2022-05-23', 2200.00, 'Cash', 'Completed'),
    (1040, '2022-06-10', 2250.00, 'Bank Transfer', 'Completed'),
    (1040, '2022-06-23', 2300.00, 'Card', 'Completed'),
    (1040, '2022-07-10', 2350.00, 'Card', 'Completed'),
    (1040, '2022-07-23', 2400.00, 'Bank Transfer', 'Completed'),
    (1040, '2022-08-10', 2450.00, 'Cash', 'Completed'),
    (1040, '2022-08-23', 2500.00, 'Card', 'Completed'),
    (1040, '2022-08-31', 2550.00, 'Card', 'Completed');

-- Payments for Student 1041
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1041, '2022-04-11', 2100.00, 'Card', 'Completed'),
    (1041, '2022-04-24', 2150.00, 'Bank Transfer', 'Completed'),
    (1041, '2022-05-11', 2200.00, 'Card', 'Completed'),
    (1041, '2022-05-24', 2250.00, 'Cash', 'Completed'),
    (1041, '2022-06-11', 2300.00, 'Bank Transfer', 'Completed'),
    (1041, '2022-06-24', 2350.00, 'Card', 'Completed'),
    (1041, '2022-07-11', 2400.00, 'Card', 'Completed'),
    (1041, '2022-07-24', 2450.00, 'Bank Transfer', 'Completed'),
    (1041, '2022-08-11', 2500.00, 'Cash', 'Completed'),
    (1041, '2022-08-24', 2550.00, 'Card', 'Completed'),
    (1041, '2022-08-31', 2600.00, 'Card', 'Completed');

-- Payments for Student 1042
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1042, '2022-04-12', 2150.00, 'Bank Transfer', 'Completed'),
    (1042, '2022-04-25', 2200.00, 'Card', 'Completed'),
    (1042, '2022-05-12', 2250.00, 'Card', 'Completed'),
    (1042, '2022-05-25', 2300.00, 'Cash', 'Completed'),
    (1042, '2022-06-12', 2350.00, 'Bank Transfer', 'Completed'),
    (1042, '2022-06-25', 2400.00, 'Card', 'Completed'),
    (1042, '2022-07-12', 2450.00, 'Card', 'Completed'),
    (1042, '2022-07-25', 2500.00, 'Bank Transfer', 'Completed'),
    (1042, '2022-08-12', 2550.00, 'Cash', 'Completed'),
    (1042, '2022-08-25', 2600.00, 'Card', 'Completed'),
    (1042, '2022-08-31', 2650.00, 'Card', 'Completed');

-- Payments for Student 1043
INSERT INTO StudentPayments (StudentID, PaymentDate, Amount, PaymentMode, PaymentStatus) VALUES
    (1043, '2022-04-13', 2200.00, 'Bank Transfer', 'Completed'),
    (1043, '2022-04-26', 2250.00, 'Card', 'Completed'),
    (1043, '2022-05-13', 2300.00, 'Card', 'Completed'),
    (1043, '2022-05-26', 2350.00, 'Cash', 'Completed'),
    (1043, '2022-06-13', 2400.00, 'Bank Transfer', 'Completed'),
    (1043, '2022-06-26', 2450.00, 'Card', 'Completed'),
    (1043, '2022-07-13', 2500.00, 'Card', 'Completed'),
    (1043, '2022-07-26', 2550.00, 'Bank Transfer', 'Completed'),
    (1043, '2022-08-13', 2600.00, 'Cash', 'Completed'),
    (1043, '2022-08-26', 2650.00, 'Card', 'Completed'),
    (1043, '2022-08-31', 2700.00, 'Card', 'Completed');

-- Grade Reports for Campus 1 (Section IDs 1-27)
INSERT INTO GradeReports (StudentID, SectionID, GradeType, CourseworkName, Grade) VALUES
    (1000, 1, 'Assignment', 'Introduction to CS Assignment 1', 95.0),
    (1000, 2, 'Quiz', 'Data Structures Quiz 1', 88.0),
    (1000, 3, 'Exam', 'Database Systems Midterm', 90.0),
    (1000, 4, 'Test', 'Web Development Test 1', 85.0),
    (1001, 5, 'Assignment', 'Operating Systems Assignment 1', 80.0),
    (1001, 6, 'Quiz', 'Linear Algebra Quiz 1', 92.0),
    (1001, 7, 'Exam', 'Calculus I Midterm', 85.0),
    (1001, 8, 'Test', 'Discrete Mathematics Test 1', 89.0),
    (1002, 9, 'Assignment', 'Psychology 101 Assignment 1', 25.0),
    (1002, 10, 'Quiz', 'Philosophy Quiz 1', 91.0),
    (1002, 11, 'Exam', 'Computer Networks Midterm', 88.0),
    (1002, 12, 'Test', 'AI Test 1', 92.0),
    (1003, 13, 'Assignment', 'Economics Assignment 1', 94.0),
    (1003, 14, 'Quiz', 'Statistics and Probability Quiz 1', 85.0),
    (1003, 15, 'Exam', 'Human-Computer Interaction Midterm', 92.0),
    (1003, 16, 'Test', 'Game Development Test 1', 78.0),
    (1004, 17, 'Assignment', 'Algorithms for Data Science Assignment 1', 60.0),
    (1004, 18, 'Quiz', 'Business Management Quiz 1', 90.0),
    (1004, 19, 'Exam', 'Digital Signal Processing Midterm', 85.0),
    (1004, 20, 'Test', 'Mobile Application Development Test 1', 88.0),
    (1005, 21, 'Assignment', 'Machine Learning Assignment 1', 32.0),
    (1005, 22, 'Quiz', 'Creative Writing Quiz 1', 77.0),
    (1005, 23, 'Exam', 'Network Security Midterm', 91.0),
    (1005, 24, 'Test', 'Game Development Test 1', 89.0),
    (1006, 25, 'Assignment', 'Artificial Intelligence Assignment 1', 25.0),
    (1006, 26, 'Quiz', 'Computer Networks Quiz 1', 93.0),
    (1006, 27, 'Exam', 'Psychology 101 Midterm', 17.0),
    (1006, 28, 'Test', 'Linear Algebra Test 1', 90.0);

-- Grade Reports for Campus 2 (Section IDs 28-45)
INSERT INTO GradeReports (StudentID, SectionID, GradeType, CourseworkName, Grade) VALUES
    (1028, 28, 'Assignment', 'Introduction to Programming Assignment 1', 85.0),
    (1028, 29, 'Quiz', 'Data Science Quiz 1', 78.0),
    (1028, 30, 'Exam', 'Advanced Algorithms Midterm', 92.0),
    (1028, 31, 'Test', 'Discrete Structures Test 1', 19.0),
    (1029, 32, 'Assignment', 'AI Fundamentals Assignment 1', 88.0),
    (1029, 33, 'Quiz', 'Digital Electronics Quiz 1', 0),
    (1029, 34, 'Exam', 'Linear Programming Midterm', 85.0),
    (1029, 35, 'Test', 'Sociology Test 1', 82.0),
    (1030, 36, 'Assignment', 'Database Management Systems Assignment 1', 95.0),
    (1030, 37, 'Quiz', 'Web Application Development Quiz 1', 91.0),
    (1030, 38, 'Exam', 'Machine Learning Midterm', 59.0),
    (1030, 39, 'Test', 'Digital Electronics Test 1', 88.0),
    (1031, 40, 'Assignment', 'Digital Marketing Assignment 1', 76.0),
    (1031, 41, 'Quiz', 'Networking Fundamentals Quiz 1', 85.0),
    (1031, 42, 'Exam', 'Computer Vision Midterm', 0),
    (1031, 43, 'Test', 'Software Development Life Cycle Test 1', 79.0),
    (1032, 44, 'Assignment', 'Machine Learning Fundamentals Assignment 1', 92.0),
    (1032, 45, 'Quiz', 'Introduction to Programming Quiz 1', 93.0),
    (1032, 46, 'Exam', 'Data Structures Midterm', 40.0),
    (1032, 47, 'Test', 'Artificial Intelligence Test 1', 56.0);

-- Grade Reports for Campus 3 (Section IDs 46-67)
INSERT INTO GradeReports (StudentID, SectionID, GradeType, CourseworkName, Grade) VALUES
    (1033, 46, 'Assignment', 'Introduction to Programming Assignment 1', 85.0),
    (1033, 47, 'Quiz', 'Data Science Quiz 1', 88.0),
    (1033, 48, 'Exam', 'Advanced Algorithms Midterm', 90.0),
    (1033, 49, 'Test', 'Discrete Structures Test 1', 79.0),
    (1034, 50, 'Assignment', 'AI Fundamentals Assignment 1', 89.0),
    (1034, 51, 'Quiz', 'Digital Electronics Quiz 1', 0),
    (1034, 52, 'Exam', 'Linear Programming Midterm', 87.0),
    (1034, 53, 'Test', 'Sociology Test 1', 81.0),
    (1035, 54, 'Assignment', 'Database Management Systems Assignment 1', 91.0),
    (1035, 55, 'Quiz', 'Web Application Development Quiz 1', 84.0),
    (1036, 56, 'Exam', 'Machine Learning Midterm', 85.0),
    (1036, 57, 'Test', 'Digital Electronics Test 1', 18.0),
    (1037, 58, 'Assignment', 'Digital Marketing Assignment 1', 90.0),
    (1037, 59, 'Quiz', 'Networking Fundamentals Quiz 1', 93.0),
    (1037, 60, 'Exam', 'Computer Vision Midterm', 83.0),
    (1037, 61, 'Test', 'Software Development Life Cycle Test 1', 80.0),
    (1038, 62, 'Assignment', 'Machine Learning Fundamentals Assignment 1', 86.0),
    (1038, 63, 'Quiz', 'Introduction to Programming Quiz 1', 85.0),
    (1038, 64, 'Exam', 'Data Structures Midterm', 2.0),
    (1038, 65, 'Test', 'Artificial Intelligence Test 1', 8.0);
