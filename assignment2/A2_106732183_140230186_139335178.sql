-- ***********************
-- Name: Nicholas Defranco, Alex Hai, Viet Nguyen
-- ID: 106732183. 140230186, 139335178
-- Date: Friday, November 23rd, 2019
-- Purpose: Assignment 2 - DBS301
-- ***********************
    
-- Drops a table only if it exists
CREATE OR REPLACE PROCEDURE DROP_TABLE_IF_EXISTS(name IN VARCHAR2) AS 

amt INTEGER;

BEGIN
    SELECT count(*) INTO amt
        FROM (
            SELECT object_name
                FROM all_objects
                WHERE lower(object_name) = lower(name)
                    AND lower(object_type) = 'table'
        );
        
    IF (amt > 0) THEN
        EXECUTE IMMEDIATE 'DROP TABLE ' || name;
    END IF;
    
END;
/

Prompt ****** Dropping tables ....

BEGIN
    DROP_TABLE_IF_EXISTS('a2jnc_students_sections');
    DROP_TABLE_IF_EXISTS('a2jnc_prog_students');
    DROP_TABLE_IF_EXISTS('a2jnc_prog_courses');
    DROP_TABLE_IF_EXISTS('a2sections');
    DROP_TABLE_IF_EXISTS('a2courses');
    DROP_TABLE_IF_EXISTS('a2term');
    DROP_TABLE_IF_EXISTS('a2programs');
    DROP_TABLE_IF_EXISTS('a2professors');
    DROP_TABLE_IF_EXISTS('a2departments');
    DROP_TABLE_IF_EXISTS('a2students');
    DROP_TABLE_IF_EXISTS('a2countries');
    DROP_TABLE_IF_EXISTS('a2advisors');
    DROP_TABLE_IF_EXISTS('a2employees');
END;
/

Prompt **************************************************
Prompt Table creations
Prompt **************************************************

Prompt ******  Creating a2departments table ....

-- NOTE: Display order is a column to be used as a ordering
-- precendence column
CREATE TABLE a2departments (

    deptCode        VARCHAR2(16),
    deptName        VARCHAR2(60)        NOT NULL,
    officeNumber    VARCHAR2(8)         NOT NULL,
    displayOrder    INTEGER,
    
        CONSTRAINT a2departments_deptCode_pk PRIMARY KEY(deptCode)
    
);

COMMENT ON COLUMN a2departments.deptCode
IS 'Primary Key, takes the form "faculty-department". Both of which are abbreviated';

Prompt ******  Creating a2term table ....

CREATE TABLE a2term (

    termCode    INTEGER,
    termName    VARCHAR2(11)    NOT NULL,
    startDate   DATE            NOT NULL,
    endDate     DATE            NOT NULL,
    
        CONSTRAINT a2term_termCode_pk PRIMARY KEY(termCode)
);

COMMENT ON COLUMN a2term.termCode
IS 'Primary Key, takes the form yymm, which represents the starting month of the term';

Prompt ******  Creating a2employees  table ....

CREATE TABLE a2employees (

    empID       INTEGER,
    firstName   VARCHAR2(20)    NOT NULL,
    lastName    VARCHAR2(30)    NOT NULL,
    prefix      VARCHAR2(5),
    suffix      VARCHAR2(5),
    isActive    INTEGER         DEFAULT 1 NOT NULL,
    sin         INTEGER         NOT NULL,
    dob         DATE            NOT NULL,
    email       VARCHAR2(50)    NOT NULL,
    phone       VARCHAR2(20)    NOT NULL,
        
        CONSTRAINT emp_ID_pk PRIMARY KEY(empID),
        CONSTRAINT a2employees_sin_unq UNIQUE(sin),
        CONSTRAINT a2employees_email_unq UNIQUE(email),
        CONSTRAINT a2employees_phone_unq UNIQUE(phone)

);

Prompt ******  Creating a2advisors  table ....

CREATE TABLE a2advisors (

    empID       INTEGER,
    isActive    INTEGER     DEFAULT 0 NOT NULL,

        CONSTRAINT a2advisors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2advisors_isActive_chk CHECK(isActive IN(1, 0)),  
        CONSTRAINT a2advisors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID)

);

Prompt ******  Creating a2countries  table ....

CREATE TABLE a2countries (

    countryCode     CHAR(2),
    countryName     VARCHAR2(56),
    continent       CHAR(2),
    isActive        INTEGER    DEFAULT 0,
        
        CONSTRAINT a2countries_countryCode_pk PRIMARY KEY(countryCode),
        CONSTRAINT a2countries_countryName_unq UNIQUE(countryName),
        CONSTRAINT a2countries_isActive_chk CHECK(isActive IN(1, 0))
            
);

Prompt ******  Creating a2courses table ....

CREATE TABLE a2courses (

    courseCode      VARCHAR2(8),
    courseName      VARCHAR2(50)    NOT NULL,
    isAvailable     INTEGER         DEFAULT 1 NOT NULL,
    description     VARCHAR2(256),
    
        CONSTRAINT a2courses_courseCode_pk PRIMARY KEY(courseCode),
        CONSTRAINT a2courses_isAvailable_chk CHECK(isAvailable IN(1, 0))
    
);

Prompt ******  Creating a2programs  table ....

CREATE TABLE a2programs (

    progCode    CHAR(3),
    progName    VARCHAR2(55)    NOT NULL,
    lengthYears INTEGER,
    isCurrent   INTEGER         DEFAULT 1 NOT NULL,
    deptCode    VARCHAR(16)     NOT NULL,
    
        CONSTRAINT a2programs_progCode_pk PRIMARY KEY(progCode),
        CONSTRAINT a2programs_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode),
        CONSTRAINT a2programs_isCurrent_chk CHECK(isCurrent IN (0, 1)),
        CONSTRAINT a2programs_lengthYears_chk CHECK(lengthYears > 0)
);

Prompt ******  Creating a2students  table ....

CREATE TABLE a2students (

    studentID   INTEGER,
    firstName   VARCHAR2(20)    NOT NULL,
    lastName    VARCHAR2(25)    NOT NULL,
    dob         DATE            NOT NULL,
    gender      CHAR(1),
    email       VARCHAR2(25)    NOT NULL,
    homeCountry CHAR(2)         NOT NULL,
    phone       VARCHAR2(14)    NOT NULL,
    advisorID   INTEGER,
    
        CONSTRAINT a2students_studentID_pk PRIMARY KEY(studentID),
        CONSTRAINT a2students_homeCountry_fk FOREIGN KEY(homeCountry)
            REFERENCES a2countries(countryCode),
        CONSTRAINT a2students_advisorID_fk FOREIGN KEY(advisorID)
            REFERENCES a2advisors(empID)
            
);

Prompt ******  Creating a2professors  table ....

CREATE TABLE a2professors (

    empID       INTEGER,
    deptCode    VARCHAR2(16),
    isActive    INTEGER DEFAULT 0,
    
        CONSTRAINT a2professors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2professors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID),
        CONSTRAINT a2professors_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode),
        CONSTRAINT a2professors_isActive_chk CHECK(isActive IN(1, 0))
            
);

Prompt ******  Creating a2sections  table ....

CREATE TABLE a2sections (

    sectionID       CHAR(11),
    sectionLetter   CHAR(1),
    courseCode      VARCHAR2(8),
    termCode        INTEGER,
    profID          INTEGER,
    
        CONSTRAINT a2sections_sectionID_pk PRIMARY KEY(sectionID),
        CONSTRAINT a2sections_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2sections_termCode_fk FOREIGN KEY(termCode)
            REFERENCES a2term(termCode),
        CONSTRAINT a2sections_profID_fk FOREIGN KEY(profID)
            REFERENCES a2professors(empID)
);

COMMENT ON COLUMN a2sections.sectionID
IS 'Primary key. It is a combination of the termCode, courseCode, and sectionLetter in that order.';

Prompt ******  Creating a2jnc_students_sections  table ..

CREATE TABLE a2jnc_students_sections (

    sectionID       CHAR(11),
    studentID       INTEGER,
    gradeObtained   INTEGER,
    isActive        INTEGER DEFAULT 0 NOT NULL,

        CONSTRAINT a2stud_sections_pk PRIMARY KEY(sectionID, studentID),
        CONSTRAINT a2stud_sections_isActive_chk CHECK(isActive IN(1, 0)),
        CONSTRAINT a2stud_sections_sectionID_fk FOREIGN KEY(sectionID)
            REFERENCES a2sections(sectionID),
        CONSTRAINT a2stud_sections_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

Prompt ******  Creating a2jnc_prog_courses  table ....

CREATE TABLE a2jnc_prog_courses (

    progCourseID    INTEGER         GENERATED AS IDENTITY,
    progCode        CHAR(3)         NOT NULL,
    courseCode      VARCHAR2(8)     NOT NULL,
    term_req        INTEGER         NOT NULL,
    isActive        INTEGER         DEFAULT 0,

        CONSTRAINT a2prog_courses_progCourseID_pk PRIMARY KEY(progCourseID),
        CONSTRAINT a2prog_courses_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode)

);

-- NOTE: We have decided to place the term_req field in the a2jnc_prog_courses instead of the a2courses table
-- the reason is multiple programs can have the same course as a requirement but at different terms
COMMENT ON COLUMN a2jnc_prog_courses.term_req
IS 'Indicates the term when a required course for a program is expected to be completed by a student';

COMMENT ON COLUMN a2jnc_prog_courses.isActive
IS 'Indicates whether or not the course is still part of the required courses list for a specific program';

Prompt ******  Creating a2jnc_prog_students table ....

CREATE TABLE a2jnc_prog_students (

    progCode        CHAR(3),
    studentID       INTEGER,
    isActive        INTEGER DEFAULT 1,

        CONSTRAINT a2prog_students_pk PRIMARY KEY(progCode, studentID),
        CONSTRAINT a2prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID),
        CONSTRAINT a2prog_students_isActive_chk CHECK(IsActive IN(1, 0))
       
);

Prompt Semester 1 courses(CPD and CPA)
-- courseCode, courseName, isAvailable, description

INSERT INTO a2courses VALUES (
	'IPC144', 'Introduction to Programming Using C', 1, 'The C programming language, which is widely used and forms the syntactical basis for object-oriented languages is used to introduce problem analysis, algorithm design, and program implementation.'
);

INSERT INTO a2courses VALUES (
	'APC100', 'Applied Professional Communications', 1, 'This course focuses on self-awareness, group work, team building, interpersonal communication, presentation skills, conflict, and time management with applications to industry-specific settings.'
);

INSERT INTO a2courses VALUES (
	'COM101', 'Communicating Across Contexts', 1, 'Students will cultivate an awareness of communication concepts by analyzing how they are used in a variety of texts and contexts, and they will apply these concepts strategically in their own writing.'
);

INSERT INTO a2courses VALUES (
	'CPR101', 'Computer Principles for Programmers', 1, 'Students learn how modern computer systems implement process control, multitasking, virtualization, file storage, and network communications.'
);

INSERT INTO a2courses VALUES (
	'ULI101', 'Introduction to UNIX/Linux and the Internet', 1, 'Students will learn to work in a Linux environment using the shell, configure their login accounts, manipulate data stored in files, use Linux commands and utilities, and write simple shell scripts.'
);

INSERT INTO a2courses VALUES (
    'EAC149', 'English and Communications', 1, 'Students will expand their vocabulary and learn how to express themselves more clearly and persuasively through analyzing texts, writing paragraphs and short essays; and participating in class discussions.'
);

Prompt Semester 2 courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'DBS201', 'Introduction to Database Design and SQL', 1, 'Students will be presented with a methodology for relational database design using Entity Relationship Diagrams and normalization of data. Students will be introduced to a subset of SQL.'
);

INSERT INTO a2courses VALUES (
	'DCF255', 'Data Communications Fundamentals', 1, 'Using well-known and widely-used Internet applications and standard networking technology as examples, students will study and learn topics that explain how distributed applications work on a network.'
);

INSERT INTO a2courses VALUES (
	'OOP244', 'Introduction to Object Oriented Programming', 1, 'Using the C++ programming language to introduce object-oriented programming the student learns to build reusable objects, encapsulate data and logic in a class, inheritance and implementing polymorphism.'
);

INSERT INTO a2courses VALUES (
	'WEB222', 'Web Programming Principles', 1, 'Students learn JavaScript and the Document Object Model. The Hypertext Markup Language defines structure and content. To modify the appearance and format of a document, students learn to apply Cascading Style Sheets.'
);


Prompt Semester 3 courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'DBS301', 'Database Design II and SQL Using Oracle', 1, 'This subject continues the study of database design and SQL begun in DBS201. Students will learn the entire set of SQL statements using the Oracle DBMS.'
);

INSERT INTO a2courses VALUES (
	'OOP345', 'Object-Oriented Software Development Using C++', 1, 'This subject expands the skill-set in object-oriented programming and introduces the student to threaded programming.  The student learns to model relationships between classes using containers.'
);

INSERT INTO a2courses VALUES (
	'SYS366', 'Requirements Gathering Using OO Models', 1, 'Students will be introduced to system development life cycles, interface design, and will learn how to use research, observation, interviews, prototypes and feedback to gather stakeholder requirements.'
);

INSERT INTO a2courses VALUES (
	'WEB322', 'Web Programming Tools and Framework', 1, 'This course teaches students to design and create simple web applications and services, in JavaScript, using widely-used and powerful tools and frameworks.'
);

Prompt Semester 3 course (CPA)

INSERT INTO a2courses VALUES (
    'WTP100', 'Work Term Preparation', 1, 'This course for WIL students prepares students to job search for their co-op terms. Students will reflect on their skills, attitudes, and expectations and evaluate and interpret available opportunities in the workplace.'
);

Prompt Semester 4 Courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'BCI433', 'IBM Business Computing', 1, 'Students will utilize IBM i tools to create business applications. These applications will be developed using the DB2 relational database, Control Language commands and programming, and the RPGLE programming language.'
);

INSERT INTO a2courses VALUES (
	'EAC397', 'Business Report Writing', 1, 'Through team and individual projects, students will learn the essentials of career management, as well as practice the skills they will need in the workplace to communicate effectively.'
);

INSERT INTO a2courses VALUES (
	'EAC594', 'Business Communication for the Digital Workplace', 1, 'This course will help you learn the principles, practices, and tools for communicating effectively in the workplace using cases and/or projects.'
);

INSERT INTO a2courses VALUES (
	'JAC444', 'Introduction to Java for C++ Programmers', 1, 'Topics include OOP, lambda expressions, functional interfaces, threads, exceptions, graphical user interface programming with Java FX, I/O, networking, client-server programming, servlets, and database access via JDBC.'
);

Prompt Semester 4 professional option (CPD)

INSERT INTO a2courses VALUES (
	'UNX511', 'UNIX Systems Programming', 1, 'This subject explores UNIX at a technical level. The primary focus will be system and network programming using C. Students will also learn advanced scripting techniques and the use of development tools and utilities.'
);

Prompt Semester 4 required courses (CPA)

INSERT INTO a2courses VALUES (
    'WEB422', 'Web Programming for Apps and Services', 1, 'This is the third course in the web programming course sequence. Students learn to design and create moderately complex web applications and services that can be deployed at scale.'
);

INSERT INTO a2courses VALUES (
    'SYS466', 'Analysis and Design Using OO Models', 1, 'Students will learn how to use object oriented analysis and design techniques to create software models of business systems using the Unified Modeling Language (UML) and the Rational Rose modeling tool.'
);

INSERT INTO a2courses VALUES (
    'CPA331', 'Computer Programming and Analysis, Co-op', 1, 'Students will apply skills learned in the academic setting and gain new workplace skills by interacting with industry professionals to develop and expand their critical thinking, problem-solving and decision-making skills.'
);

Prompt Semester 5 required courses (CPA)

INSERT INTO a2courses VALUES (
    'PRJ566', 'Project Planning and Management', 1, 'Project management concepts include scope development and management, creation of work breakdown structures, including task dependencies, and cost benefit analysis using return on investment and payback.'
);

--TODO: If Henry wants to add his own preferred courses
Prompt Semester 5 professional option (CPA)

INSERT INTO a2courses VALUES (
    'DBS501', 'Stored Procedures Using Oracles PL/SQL', 1, 'This subject uses Oracle PL/SQL language to code PL/SQL blocks, procedures, functions, packages, and database triggers for applications developed using Oracle relational databases.'
);

INSERT INTO a2courses VALUES (
    'DBS565', 'Database Connectivity Using Java', 1, 'The student will be introduced to connectivity issues that business deals with in todays environment, in creating a GUI front end to a back-end database.'
);

INSERT INTO a2courses VALUES (
    'VBA544', 'Visual Basic', 1, 'Visual Basic (VB) changed the way we develop Windows applications on the personal computer. VB is the first of the Rapid Application Development (RAD) tools, and continues to evolve with the recent release of the .NET framework.'
);

INSERT INTO a2courses VALUES (
    'MAP523', 'Mobile App Development - iOS', 1, 'Students will learn the foundations of programming applications for the Apple iOS operating system and become proficient with the development tool environment, and create graphical end-user iOS applications using MVC design pattern.'
);


Prompt Semester 6 required courses (CPA)

INSERT INTO a2courses VALUES (
    'PRJ666', 'Project Implementation', 1, 'As part of a team, students will plan and manage the development of an actual system using project planning, system design, system implementation, and unit and system testing methodologies.'
);

Prompt Semester 6 professional option (CPA)

INSERT INTO a2courses VALUES (
    'MAP524', 'Mobile App Development - Android', 1, 'Student will be familiarized with all aspects of planning, developing and testing mobile applications for the Android platform using the Java programming language, as well as achieving effective interaction on mobile devices.'
);

INSERT INTO a2courses VALUES (
    'WEB524', 'Web Programming Using ASP.NET', 1, 'Concepts, technical skills, and business knowledge required to develop data-driven web sites hosted on the Microsoft Web Platform. The course will focus on server-side ASP.NET programming technologies and the C# language.'
);

INSERT INTO a2courses VALUES (
    'DBA625', 'Database Administration', 1, 'The student will learn how the DBMS manages the data and controls such as recovery, locking and transaction logging and performance tuning.'
);

INSERT INTO a2courses VALUES (
    'GAM537', 'Game Development Fundamentals', 1, 'This subject will teach students the principles of game design and give them the opportunity to create a game using an existing game engine.'
);

Prompt General Education Courses

INSERT INTO a2courses VALUES (
    'CAN190', 'Introduction to Canadian Politics', 1, 'Political theorists have argued that Canada is one of the most successful democracies in the world. Yet, Canada is a country of contradictions. The historical, social and political foundations of the Canadian political process are examined.'
);

INSERT INTO a2courses VALUES (
    'NAT101', 'Is There Life Beyond Earth?', 1, 'This subject introduces students to the science of Astronomy. They will gain insights into ways that physical forces have shaped the environments of Earth and neighbouring planets.'
);

INSERT INTO a2courses VALUES (
    'SOC135', 'Global Economic Issues', 1, 'Global Economic Issues is designed to introduce the student to the key issues behind our complex and changing world from a social, political and economic point of view.'
);

Prompt Employees insertions
-- empID, firstName, lastName, prefix, suffix, isActive,
-- sin, dob, email, phone

-- unknown prof, required for most couses we have not taken yet
INSERT INTO a2employees VALUES (
    0, 'Unknown', 'Unknown', NULL, NULL, 0, 0, 
        to_date('1970-01-01', 'yyyy-mm-dd'), '?',
        '0'
);

INSERT INTO a2employees VALUES (
	123456789, 'Clint', 'MacDonald', NULL, NULL, 1, 123456789, 
		to_date('1999-03-10', 'yyyy-mm-dd'), 
		'clint.macdonald@senecacollege.ca', '416.491.5050e24158'
);

INSERT INTO a2employees VALUES (
	987654321, 'Ron', 'Tarr', NULL, NULL, 1, 444555666, 
		to_date('1990-09-20', 'yyyy-mm-dd'),
		'ron.tarr@senecacollege.ca', '416.491.5050e24026'
);

INSERT INTO a2employees VALUES (
	111222333, 'Robert' , 'Stewart', NULL, NULL, 1, 111222333,
		to_date('1986-04-29', 'yyyy-mm-dd'), 
		'rob.stewart@senecacollege.ca', '416.491.5050e22752'
);

INSERT INTO a2employees VALUES (
	222333444, 'Nathan', 'Misener', NULL, NULL, 1, 67890123, 
		to_date('1990-07-12', 'yyyy-mm-dd'),
		'nathan.misener@senecacollege.ca', '111.222.3333'
);

INSERT INTO a2employees VALUES (
	333444555, 'Asam', 'Gulaid', NULL, NULL, 1, 098765432,
		to_date('1867-07-01', 'yyyy-mm-dd'),
		'asam.gulaid1@senecacollege.ca', '647.470.6438'
);

INSERT INTO a2employees VALUES (
	444555666, 'Stanley', 'Ukah', NULL, NULL, 1, 999888777,
		to_date('1979-08-15', 'yyyy-mm-dd'),
		'stanley.ukah1@senecacollege.ca', '416.491.5050e33212'
);

INSERT INTO a2employees VALUES (
	555666777, 'Kadeem', 'Best', NULL, NULL, 1, 555666777,
		to_date('1985-04-12', 'yyyy-mm-dd'),
		'kadeem.best@senecacollege.ca', '444.333.4444'
);

INSERT INTO a2employees VALUES (
	666777888, 'James', 'Mwangi', NULL, NULL, 1, 111111111,
		to_date('1970-03-18', 'yyyy-mm-dd'),
		'james.mwangi@senecacollege.ca', '416.491.5050e22553'
);

INSERT INTO a2employees VALUES (
	777888999, 'Marc', 'Menard', NULL, NULL, 1, 222222222,
		to_date('1965-07-13', 'yyyy-mm-dd'), 
		'marc.menard@senecacollege.ca', '416.491.5050e26929'
);

INSERT INTO a2employees VALUES (
    888999000, 'Betrice', 'Brangman', NULL, NULL, 1, 333333333,
        to_date('1980-04-10', 'yyyy-mm-dd'),
        'betrice.brangman@senecacollege.ca', '416.491.5050e26683'
);

INSERT INTO a2employees VALUES (
    123123123, 'Nebojsa', 'Conkic', NULL, NULL, 1, 444444444,
        to_date('1975-01-29', 'yyyy-mm-dd'),
        'nebojsa.conkic@senecacollege.ca', '416.491.5050e24152'
);

INSERT INTO a2employees VALUES (
    321321321, 'Nour', 'Hossain', 'Md.', NULL, 1, 555555555,
        to_date('1960-05-18', 'yyyy-mm-dd'),
        'md-nour.hossain@senecacollege.ca', '416.491.5050e24124'
);

INSERT INTO a2employees VALUES (
    789789789, 'Mary', 'Saith', NULL, NULL, 1, 666666666,
        to_date('1965-09-20', 'yyyy-mm-dd'),
        'mary.saith@senecacollege.ca', '416.491.5050e24025'
);

INSERT INTO a2employees VALUES (
    333999777, 'Robert', 'Robson', NULL, NULL, 1, 777777777,
        to_date('1970-08-12', 'yyyy-mm-dd'),
        'robert.robson1@senecacollege.ca', '416.491.5050e24138'
);

INSERT INTO a2employees VALUES (
    222000999, 'John', 'Selmys', NULL, NULL, 1, 888888888,
        to_date('1970-01-01', 'yyyy-mm-dd'),
        'john.selmys@senecacollege.ca', '416.491.5050'
);

INSERT INTO a2employees VALUES (
    333555111, 'Tim', 'Mckenna', NULL, NULL, 1, 999999999,
        to_date('1965-10-09', 'yyyy-mm-dd'),
        'timothy.mckenna@senecacollege.ca', '416.491.5050e26724'
);

INSERT INTO a2employees VALUES (
    222777888, 'Michelle', 'Duhaney', NULL, NULL, 1, 000111222,
        to_date('1980-10-12', 'yyyy-mm-dd'),
        'michelle.duhaney@senecacollege.ca', '416.491.5050e55529'
);

INSERT INTO a2employees VALUES (
    333222666, 'Erik', 'Schomann', NULL, NULL, 1, 777666222,
        to_date('1980-10-12', 'yyyy-mm-dd'),
        'erik.schomann@senecacollege.ca', '416.491.5050e33131'
);

INSERT INTO a2employees VALUES (
    555111888, 'Nick', 'Romanidis', NULL, NULL, 1, 999555333,
        to_date('1985-04-12', 'yyyy-mm-dd'),
        'nick.romanidis@senecacollege.ca', '444.555.1111'
);

INSERT INTO a2employees VALUES (
    888111222, 'Shannon', 'Blake', NULL, NULL, 1, 555000222,
        to_date('1985-04-12', 'yyyy-mm-dd'),
        'shannon.blake@senecacollege.ca', '416.491.5050e33134'
);

INSERT INTO a2employees VALUES (
    777666444, 'Najma', 'Ismat', NULL, NULL, 1, 333999111,
        to_date('1950-03-18', 'yyyy-mm-dd'),
        'najma.ismat@senecacollege.ca', '416.491.5050e26452'
);

INSERT INTO a2employees VALUES (
    666111000, 'Beau', 'Sackey', NULL, NULL, 1, 111777333,
        to_date('1985-04-12', 'yyyy-mm-dd'),
        'beau.sackey@senecacollege.ca', '111.999.2222'
);

INSERT INTO a2employees VALUES (
    111444777, 'Hong', 'Huang', NULL, NULL, 1, 244009123,
        to_date('1990-09-09', 'yyyy-mm-dd'),
        'hong.huang@senecacollege.ca', '416.491.5050e24199'
);

INSERT INTO a2employees VALUES (
    222555888, 'Nasim', 'Razavi', NULL, NULL, 1, 201085789,
        to_date('1982-12-22', 'yyyy-mm-dd'),
        'nasim.razavi@senecacollege.ca', '416.491.5050e24187'
);

INSERT INTO a2employees VALUES (
    444222333, 'Peter', 'Miller', NULL, NULL, 1, 894326123,
        to_date('1970-02-09', 'yyyy-mm-dd'),
        'peter.miller@senecacollege.ca', '416.491.5050e22566'
);

INSERT INTO a2employees VALUES (
    777888444, 'Mehrnaz', 'Zhian', NULL, NULL, 1, 543632789,
        to_date('1980-05-16', 'yyyy-mm-dd'),
        'mehrnaz.zhian@senecacollege.ca', '416.491.5050e11111'
);

INSERT INTO a2employees VALUES (
    111999666, 'Maia', 'Nenkova', NULL, NULL, 1, 456928284,
        to_date('1985-09-19', 'yyyy-mm-dd'),
        'maia.nenkova@senecacollege.ca', '416.491.5050e26006'
);

INSERT INTO a2employees VALUES (
    666333999, 'Frank', 'Robbins', NULL, NULL, 1, 456097237,
        to_date('1987-10-10', 'yyyy-mm-dd'),
        'frank.robbins@senecacollee.ca', '416.491.5050e26439'
);

INSERT INTO a2employees VALUES (
    888222000, 'Ian', 'Tipson', NULL, NULL, 1, 789420174,
        to_date('1978-12-18', 'yyyy-mm-dd'),
        'ian.tipson@senecacollege.ca', '416.491.5050e26233'
);

INSERT INTO a2employees VALUES (
    777333555, 'Joshua', 'Sullivan', NULL, NULL, 1, 543213903,
        to_date('1983-03-12', 'yyyy-mm-dd'),
        'joshua.sullivan@canadorecollege.ca', 'Unknown'
);

INSERT INTO a2employees VALUES (
    333666999, 'Tom', 'Bartsiokas', NULL, NULL, 1, 325901456,
        to_date('1970-01-01', 'yyyy-mm-dd'),
        'tom.bartsiokas@senecacollege.ca', '416.491.5050e26170'
);

INSERT INTO a2employees VALUES (
    321456987, 'Russell', 'Pangborn', NULL, NULL, 1, 895234567,
        to_date('1968-01-19', 'yyyy-mm-dd'),
        'russell.pangborn@senecacollege.ca', '416.491.5050e24095'
);

INSERT INTO a2employees VALUES (
    123654789, 'Patrick', 'Crawford', NULL, NULL, 1, 456222649,
        to_date('1983-09-14', 'yyyy-mm-dd'),
        'patrick.crawford@senecacollege.ca', '416.491.5050e24066'
);

Prompt Departments insertions

-- deptCode, deptName, officeNumber, displayOrder

INSERT INTO a2departments VALUES (
    'ASET-SICT','School of Information and Communications Technology','K1234',1
);

INSERT INTO a2departments VALUES (
    'ASET-SA','School of Aviation','K1236',1
);

INSERT INTO a2departments VALUES (
    'ASET-SBSAC','School of Biological Sciences and Applied Chemistry','K1238',1
);

INSERT INTO a2departments VALUES (
    'ASET-SEMET','School of Electronics and Mechanical Engineering Technology','K1240',1
);

INSERT INTO a2departments VALUES (
    'ASET-SECET','School of Environmental and Civil Engineering Technology','K1242',1
);

INSERT INTO a2departments VALUES (
    'ASET-SFPET','School of Fire Protection Engineering Technology','K1244',1
);

INSERT INTO a2departments VALUES (
    'ASET-SSDDS','School of Software Design and Data Science','K1246',1
);

INSERT INTO a2departments VALUES (
    'SB-SELS', 'School of English and Liberal Studies', 'A1010', 1
);

Prompt Professor insertions
-- empID, deptCode, isActive

-- Unknown prof
INSERT INTO a2professors VALUES (
    0, 'ASET-SICT', 0
);

-- Clint
INSERT INTO a2professors VALUES (
	123456789, 'ASET-SICT', 1
);

-- Ron
INSERT INTO a2professors VALUES (
	987654321, 'ASET-SICT', 1
);

-- Robert
INSERT INTO a2professors VALUES (
	111222333, 'ASET-SICT', 1
);

-- Nathan
INSERT INTO a2professors VALUES (
	222333444, 'ASET-SICT', 1
);

-- Asam
INSERT INTO a2professors VALUES (
	333444555, 'ASET-SICT', 1
);

-- Stanley
INSERT INTO a2professors VALUES (
	444555666, 'ASET-SICT', 1
);

-- Kadeem
INSERT INTO a2professors VALUES (
	555666777, 'ASET-SSDDS', 1
);

-- James
INSERT INTO a2professors VALUES (
	666777888, 'ASET-SICT', 1
);

-- Marc
INSERT INTO a2professors VALUES (
	777888999, 'SB-SELS', 1
);

-- Nebojsa
INSERT INTO a2professors VALUES (
    123123123, 'ASET-SICT', 1
);

-- Nour
INSERT INTO a2professors VALUES (
    321321321, 'ASET-SICT', 1
);

-- Mary
INSERT INTO a2professors VALUES (
    789789789, 'ASET-SICT', 1
);

-- Robert Robson
INSERT INTO a2professors VALUES (
    333999777, 'ASET-SICT', 1
);

-- John Selmys
INSERT INTO a2professors VALUES (
    222000999, 'ASET-SICT', 1
);

-- Tim Mckenna
INSERT INTO a2professors VALUES (
    333555111, 'ASET-SICT', 1
);

-- Michelle Duhaney
INSERT INTO a2professors VALUES (
    222777888, 'SB-SELS', 1
);

-- Erik Schomann
INSERT INTO a2professors VALUES (
    333222666, 'SB-SELS', 1
);

-- Nick Romanidis
INSERT INTO a2professors VALUES (
    555111888, 'ASET-SICT', 1
);

-- Shannon Blake
INSERT INTO a2professors VALUES (
    888111222, 'SB-SELS', 1
);

-- Najma Ismat
INSERT INTO a2professors VALUES (
    777666444, 'ASET-SICT', 1
);

-- Beau Sackey
INSERT INTO a2professors VALUES (
    666111000, 'ASET-SICT', 1
);

-- Hong (Michael) Huang
INSERT INTO a2professors VALUES (
    111444777, 'ASET-SICT', 1
);

-- Nasim Razavi
INSERT INTO a2professors VALUES (
    222555888, 'ASET-SSDDS', 1
);

-- Frank Robbins
INSERT INTO a2professors VALUES (
    666333999, 'SB-SELS', 1
);

-- Maia Nenkova
INSERT INTO a2professors VALUES (
    111999666, 'SB-SELS', 1
);

-- Mehrnaz Zhian
INSERT INTO a2professors VALUES (
    777888444, 'ASET-SSDDS', 1
);

-- Peter Miller
INSERT INTO a2professors VALUES (
    444222333, 'SB-SELS', 1
);

-- Ian Timpson
INSERT INTO a2professors VALUES (
    888222000, 'ASET-SSDDS', 0
);

-- Josh Sullivan
INSERT INTO a2professors VALUES (
    777333555, 'ASET-SSDDS', 1
);

-- Tom Bartsiokas
INSERT INTO a2professors VALUES (
    333666999, 'SB-SELS', 1
);

-- Russell Pangborn
INSERT INTO a2professors VALUES (
    321456987, 'ASET-SSDDS', 1
);

-- Patrick Crawford
INSERT INTO a2professors VALUES (
    123654789, 'ASET-SSDDS', 1
);

Prompt Advisor Insertions
-- empID, isActive

-- Betrice
INSERT INTO a2advisors VALUES (
    888999000, 1
);

-- Ian Timpson
INSERT INTO a2advisors VALUES (
    888222000, 1
);

Prompt Program Insertions
-- progCode, progName, lengthYears, isCurrent, deptCode

INSERT INTO a2programs VALUES (
    'CPD', 'Computer Programmer', 2, 1, 'ASET-SICT'
);

INSERT INTO a2programs VALUES (
    'CPA', 'Computer Programming and Analysis', 3, 1, 'ASET-SICT'
);

INSERT INTO a2programs VALUES (
    'BSD', 'Honours Bachelor of Technology - Software Development', 4, 1, 'ASET-SICT'
);

INSERT INTO a2programs VALUES (
    'CNS', 'Computer Networking and Technical Support', 2, 1, 'ASET-SICT'
);


Prompt Term Insertions
-- termCode, termName, startDate, endDate

INSERT INTO a2term VALUES (
    1809, 'Fall 2018', to_date('2018-09-03', 'yyyy-mm-dd'),
        to_date('2018-12-13', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    1901, 'Winter 2019', to_date('2019-01-06', 'yyyy-mm-dd'),
        to_date('2020-04-17', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    1905, 'Summer 2019', to_date('2019-05-04', 'yyyy-mm-dd'),
        to_date('2019-08-14', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    1909, 'Fall 2019', to_date('2019-09-03', 'yyyy-mm-dd'),
        to_date('2019-12-13', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    2001, 'Winter 2020', to_date('2020-01-06', 'yyyy-mm-dd'),
        to_date('2020-04-17', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    2005, 'Summer 2020', to_date('2020-05-04', 'yyyy-mm-dd'),
        to_date('2020-08-14', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    2009, 'Fall 2020', to_date('2020-09-08', 'yyyy-mm-dd'),
        to_date('2020-12-11', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    2101, 'Winter 2021', to_date('2021-01-04', 'yyyy-mm-dd'),
        to_date('2021-04-16', 'yyyy-mm-dd')
);

Prompt Section Insertions
-- sectionID, sectionLetter, courseCode, termCode, profID

Prompt Current Term's Sections
INSERT INTO a2sections VALUES (
    '1909OOP345B', 'B', 'OOP345', 1909, 222333444
);

INSERT INTO a2sections VALUES (
    '1909OOP345A', 'A', 'OOP345', 1909, 222333444
);

INSERT INTO a2sections VALUES (
    '1909OOP345G', 'G', 'OOP345', 1909, 333444555
);

INSERT INTO a2sections VALUES (
    '1909OOP345F', 'F', 'OOP345', 1909, 333444555
);

INSERT INTO a2sections VALUES (
    '1909DBS301A', 'A', 'DBS301', 1909, 123456789
);

INSERT INTO a2sections VALUES (
    '1909DBS301B', 'B', 'DBS301', 1909, 123456789
);

INSERT INTO a2sections VALUES (
    '1909DBS301G', 'G', 'DBS301', 1909, 987654321
);

INSERT INTO a2sections VALUES (
    '1909DBS301C', 'C', 'DBS301', 1909, 111222333
);

INSERT INTO a2sections VALUES (
    '1909DBS301D', 'D', 'DBS301', 1909, 111222333
);

INSERT INTO a2sections VALUES (
    '1909SYS366D', 'D', 'SYS366', 1909, 444555666
);

INSERT INTO a2sections VALUES (
    '1909SYS366E', 'E', 'SYS366', 1909, 444555666
);

INSERT INTO a2sections VALUES (
    '1909WEB322D', 'D', 'WEB322', 1909, 321321321
);

INSERT INTO a2sections VALUES (
    '1909WEB322F', 'F', 'WEB322', 1909, 555666777
);

INSERT INTO a2sections VALUES (
    '1909WEB322E', 'E', 'WEB322', 1909, 666777888
);

INSERT INTO a2sections VALUES (
    '1909CAN190A', 'A', 'CAN190', 1909, 777888999
);

INSERT INTO a2sections VALUES (
    '1909WTP100C', 'C', 'WTP100', 1909, 789789789
);

Prompt Future Terms' sections (Winter 2020)

INSERT INTO a2sections VALUES (
    '2001JAC444E', 'E', 'JAC444', 2001, 777888444
);

INSERT INTO a2sections VALUES (
    '2001EAC594X', 'X', 'EAC594', 2001, 444222333
);

INSERT INTO a2sections VALUES (
    '2001NAT101A', 'A', 'NAT101', 2001, 111999666
);

INSERT INTO a2sections VALUES (
    '2001SOC135A', 'A', 'SOC135', 2001, 666333999
);

INSERT INTO a2sections VALUES (
    '2001EAC594P', 'P', 'EAC594', 2001, 333666999
);

INSERT INTO a2sections VALUES (
    '2001BCI433D', 'D', 'BCI433', 2001, 321456987
);

INSERT INTO a2sections VALUES (
    '2001WEB422B', 'B', 'WEB422', 2001, 123654789
);

INSERT INTO a2sections VALUES (
    '2001SYS466B', 'B', 'SYS466', 2001, 777888444
);

INSERT INTO a2sections VALUES (
    '2001CPA331C', 'C', 'CPA331', 2001, 0
);

INSERT INTO a2sections VALUES (
    '2001WEB422', NULL, NULL, 2001, 0
);

Prompt Previous Terms' Sections

Prompt Fall 2018

INSERT INTO a2sections VALUES (
    '1809IPC144P', 'P', 'IPC144', 1809, 333999777
); 

INSERT INTO a2sections VALUES (
    '1809ULI101P', 'P', 'ULI101', 1809, 222000999
);

INSERT INTO a2sections VALUES (
    '1809CPR101P', 'P', 'CPR101', 1809, 333555111
);

INSERT INTO a2sections VALUES (
    '1809APC100P', 'P', 'APC100', 1809, 333222666
);

INSERT INTO a2sections VALUES (
    '1809EAC149A', 'A', 'EAC149', 1809, 222777888
);

INSERT INTO a2sections VALUES (
    '1809COM101P', 'P', 'COM101', 1809, 222777888
);

Prompt Winter 2019

INSERT INTO a2sections VALUES (
    '1901OOP244K', 'K', 'OOP244', 1901, 555111888
);

INSERT INTO a2sections VALUES (
    '1901OOP244J', 'J', 'OOP244', 1901, 111444777
);

INSERT INTO a2sections VALUES (
    '1901WEB222A', 'A', 'WEB222', 1901, 555666777
);

INSERT INTO a2sections VALUES (
    '1901WEB222I', 'I', 'WEB222', 1901, 555666777
);

INSERT INTO a2sections VALUES (
    '1901DCF255B', 'B', 'DCF255', 1901, 777666444
);

INSERT INTO a2sections VALUES (
    '1901DCF255I', 'I', 'DCF255', 1901, 777666444
);

INSERT INTO a2sections VALUES (
    '1901DBS201C', 'C', 'DBS201', 1901, 222555888
);

INSERT INTO a2sections VALUES (
    '1901DBS201D', 'D', 'DBS201', 1901, 222555888
);

INSERT INTO a2sections VALUES (
    '1901DBS201P', 'P', 'DBS201', 1901, 777333555
);

INSERT INTO a2sections VALUES (
    '1901COM101A', 'A', 'COM101', 1901, 888111222
);

Prompt Junction Program Courses Insertions
-- progCourseID, progCode, courseCode, term_req, isActive

Prompt CPD Course Insertions

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'IPC144', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'ULI101', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'APC100', 1, 0
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'CPR101', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'COM101', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'DBS201', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'DCF255', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'OOP244', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'WEB222', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'OOP345', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'DBS301', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'SYS366', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'WEB322', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'BCI433', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'EAC397', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'EAC594', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'JAC444', 4, 1
);


Prompt CPA Course Insertions

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'IPC144', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'ULI101', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'APC100', 1, 0
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'CPR101', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'COM101', 1, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'DBS201', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'DCF255', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'OOP244', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'WEB222', 2, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'OOP345', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'DBS301', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'SYS366', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'WEB322', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'BCI433', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'WEB422', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'EAC397', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'EAC594', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'JAC444', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'WTP100', 3, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'SYS466', 4, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'PRJ566', 5, 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPA', 'PRJ666', 6, 1
);

Prompt Country Insertions
-- countryCode, countryName,continent, isActive

INSERT INTO a2countries VALUES (
    'CA', 'Canada', 'NA', 1
);

INSERT INTO a2countries VALUES ( 
    'US', 'United States of America', 'NA', 1 
);

INSERT INTO a2countries VALUES (
    'IT', 'Italy', 'EU' , 1
);

INSERT INTO a2countries VALUES ( 
    'JP', 'Japan', 'AS', 1
);

INSERT INTO a2countries VALUES ( 
    'CH', 'China', 'AS', 1
);

INSERT INTO a2countries VALUES (
    'IN', 'India', 'AS', 1
);

INSERT INTO a2countries VALUES ( 
    'AU', 'Australia', 'AU', 1
);

INSERT INTO a2countries VALUES ( 
    'ZI', 'Zimbabwe', 'AF', 1
);

INSERT INTO a2countries VALUES ( 
    'FR', 'France', 'AN', 1
);

INSERT INTO a2countries VALUES ( 
    'GE', 'Germany', 'EU', 1
);

INSERT INTO a2countries VALUES ( 
    'ZM', 'Zambia', 'AF', 1
);

INSERT INTO a2countries VALUES ( 
    'EG', 'Egypt', 'AF', 1
);

INSERT INTO a2countries VALUES ( 
    'BR', 'Brazil', 'SA', 1
);

INSERT INTO a2countries VALUES ( 
    'SZ', 'Switzerland', 'EU', 1
);

INSERT INTO a2countries VALUES ( 
    'DU', 'Netherlands', 'EU', 1
);

INSERT INTO a2countries VALUES ( 
    'MX', 'Mexico', 'NA', 1
);

INSERT INTO a2countries VALUES ( 
    'KU', 'Kuwait', 'AS', 1
);

INSERT INTO a2countries VALUES ( 
    'IS', 'Israel', 'AS', 1
);

INSERT INTO a2countries VALUES ( 
    'DE', 'Denmark', 'EU', 1
);
        
INSERT INTO a2countries VALUES ( 
    'NI', 'Nigeria', 'AF', 1 
);

INSERT INTO a2countries VALUES ( 
    'AR', 'Argentina', 'SA', 1
);

INSERT INTO a2countries VALUES ( 
    'BE', 'Belgium', 'EU', 1
);


Prompt Student Insertions
-- studentID, firstName, lastName, dob, gender, email,
-- homeCountry, phone, advisorID

INSERT INTO a2students VALUES (
    106732183, 'Nicholas', 'Defranco', to_date('2000-06-16', 'yyyy-mm-dd'),
        'M', 'ndefranco@myseneca.ca', 'IT', '111.222.3333', 888999000
);

INSERT INTO a2students VALUES (
    140230186, 'Alex', 'Hai', to_date('1990-10-18', 'yyyy-mm-dd'),
        'M', 'amchai@myseneca.ca', 'CA', '222.333.4444', 888999000
);
INSERT INTO a2students VALUES (
    139335178, 'Henry', 'Nguyen', to_date('1997-02-10', 'yyyy-mm-dd'),
        'M', 'vqdnguyen@myseneca.ca', 'CA', '444.555.6666', 888999000
);

INSERT INTO a2students VALUES (
    333333333, 'Some', 'Guy', to_date('1969-04-20', 'yyyy-mm-dd'),
        'M', 'email@myseneca.ca', 'CA', '999.888.7777', 888999000
);

Prompt Junction Program Students Insertions

-- progCode, studentID, isActive
-- Nicholas and some guy are in CPD
INSERT INTO a2jnc_prog_students VALUES (
    'CPD', 106732183, 1
);

INSERT INTO a2jnc_prog_students VALUES (
    'CPD', 333333333, 1
);

-- Alex and Henry are in CPA
INSERT INTO a2jnc_prog_students VALUES (
    'CPA', 139335178, 1
);

INSERT INTO a2jnc_prog_students VALUES (
    'CPA', 140230186, 1
);


Prompt Junction Students Sections Insertions
-- sectionID, studentID, gradeObtained, isActive

Prompt Some guy's insertions

INSERT INTO a2jnc_students_sections VALUES (
    '1901COM101A', 333333333, 80, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809IPC144P', 333333333, 85, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809CPR101P', 333333333, 70, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809APC100P', 333333333, 80, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809ULI101P', 333333333, 90, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901WEB222I', 333333333, 70, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DCF255I', 333333333, 75, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901OOP244J', 333333333, 80, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DBS201C', 333333333, 70, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1909OOP345A', 333333333, 80, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1909WEB322D', 333333333, 78, 1
);

INSERT INTO a2jnc_students_sections VALUES (
    '1909SYS366D', 333333333, 100, 1
);

-- TODO: fix section id

Prompt Inserting Nicholas's Current Courses
-- Nicholas's courses
-- OOP345 - B
INSERT INTO a2jnc_students_sections VALUES (
    '1909OOP345B', 106732183, 90, 1
);

-- SYS366 - D
INSERT INTO a2jnc_students_sections VALUES (
    '1909SYS366D', 106732183, 70, 1
);

-- DBS301 - B
INSERT INTO a2jnc_students_sections VALUES (
    '1909DBS301B', 106732183, 80, 1
);

-- CAN190 - A
INSERT INTO a2jnc_students_sections VALUES (
    '1909CAN190A', 106732183, 70, 1
);

Prompt Inserting Nicholas Future Courses

INSERT INTO a2jnc_students_sections VALUES (
    '2001NAT101A', 106732183, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001SOC135A', 106732183, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001JAC444E', 106732183, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001EAC594X', 106732183, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001WEB422', 106732183, NULL, 0
);

Prompt Inserting Nicholas Past Courses
INSERT INTO a2jnc_students_sections VALUES (
    '1809IPC144P', 106732183, 90, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809ULI101P', 106732183, 90, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809CPR101P', 106732183, 90, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809APC100P', 106732183, 75, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809EAC149A', 106732183, 80, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901OOP244K', 106732183, 90, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901WEB222A', 106732183, 80, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DCF255B', 106732183, 70, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DBS201P', 106732183, 90, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901COM101A', 106732183, 70, 0
);

-- Alex is too smart
-- OOP345 - B
INSERT INTO a2jnc_students_sections VALUES (
    '1909OOP345B', 140230186, 100, 1
);
-- SYS366 - D
INSERT INTO a2jnc_students_sections VALUES (
    '1909SYS366D', 140230186, 100, 1
);
-- DBS301 - B
INSERT INTO a2jnc_students_sections VALUES (
    '1909DBS301B', 140230186, 100, 1
);
-- WEB322 - E
INSERT INTO a2jnc_students_sections VALUES (
    '1909WEB322E', 140230186, 100, 1
);
-- WTP100 - C
INSERT INTO a2jnc_students_sections VALUES (
    '1909WTP100C', 140230186, 100, 1
);

Prompt Inserting Alex Future Courses

INSERT INTO a2jnc_students_sections VALUES (
    '2001EAC594P', 140230186, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001BCI433D', 140230186, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001JAC444E', 140230186, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001WEB422B', 140230186, NULL, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '2001SYS466B', 140230186, NULL, 0
);

Prompt Inserting Alex Past Courses

INSERT INTO a2jnc_students_sections VALUES (
    '1809IPC144P', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809ULI101P', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809CPR101P', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809APC100P', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901OOP244J', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901WEB222I', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DCF255I', 140230186, 88, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DBS201D', 140230186, 88, 0
);

-- Henry is also too smart
-- OOP345 - B
INSERT INTO a2jnc_students_sections VALUES (
    '1909OOP345B', 139335178, 100, 1
);
-- SYS366 - D
INSERT INTO a2jnc_students_sections VALUES (
    '1909SYS366D', 139335178, 100, 1
);
-- DBS301 - B
INSERT INTO a2jnc_students_sections VALUES (
    '1909DBS301B', 139335178, 100, 1
);
-- WEB322 - E
INSERT INTO a2jnc_students_sections VALUES (
    '1909WEB322E', 139335178, 100, 1
);
-- WTP100 - C
INSERT INTO a2jnc_students_sections VALUES (
    '1909WTP100C', 139335178, 100, 1
);

Prompt Inserting Henry Future Courses

INSERT INTO a2jnc_students_sections VALUES (
    '2001CPA331C', 139335178, NULL, 0
);

Prompt Inserting Henry Past Courses

INSERT INTO a2jnc_students_sections VALUES (
    '1809IPC144P', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809ULI101P', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809CPR101P', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809APC100P', 139335178, 99, 0
);

--TODO: double check section letters and elective
INSERT INTO a2jnc_students_sections VALUES (
    '1809COM101P', 106732183, 70, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901OOP244J', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901WEB222I', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DCF255I', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1901DBS201D', 139335178, 99, 0
);

INSERT INTO a2jnc_students_sections VALUES (
    '1809COM101P', 139335178, 84, 0
);

-- This procedure accepts 2 arguments, the user name of a user and 
-- an integer specifying the action taken

-- if opt is equal to 1, the procedure simply grants all DML permissions 
-- on all tables and views with the a2 prefix to that user

-- if opt is equal to anything else, the procedure simply revokes all DML 
-- permissions on all tables with the a2prefix from that user

Prompt Creating CREATE_REMOVE_GOD procedure

CREATE OR REPLACE PROCEDURE CREATE_REMOVE_GOD(name IN VARCHAR2, opt IN INTEGER) AS 

    tablename all_objects.object_name%type;

    CURSOR tablegroup IS
        SELECT object_name
            FROM all_objects
            WHERE (lower(object_type) = 'table' OR lower(object_type) = 'view')
                AND lower(object_name) LIKE 'a2%';

BEGIN

    OPEN tablegroup;
    
    LOOP
        
        FETCH tablegroup INTO tablename;
        EXIT WHEN tablegroup%NOTFOUND;
        
        IF(opt = 1) THEN
            EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, DELETE, '
                || 'INSERT ON ' || tablename || ' TO ' || name;
        ELSE 
            EXECUTE IMMEDIATE 'REVOKE SELECT, UPDATE, DELETE, '
                || 'INSERT ON ' || tablename || ' FROM ' || name;
        END IF;
        
    END LOOP;
    
    CLOSE tablegroup;

END;
/

Prompt Revoking all Permissions from Public

REVOKE ALL
    ON user_objects
    FROM PUBLIC;

/*

This part was only meant to be run by Nicholas, who was responible for granting permissions to others.
This part will not work if you ran it as you would be granting permissions on yourself which is not allowed.

This part is only here for proof that permissions were granted as requested by the assignment requiredments


Prompt Granting DML permissions to Group Members and Clint

BEGIN
    
    CREATE_REMOVE_GOD('dbs301_193a17', 1);
    CREATE_REMOVE_GOD('dbs301_193a45', 1);
    CREATE_REMOVE_GOD('dbs301_193b45', 1);

END;
/

*/

-- View 1

/*

For this first view, we have decided to use PIVOT. PIVOT allowed the data to 
be printed in a more readable form rather than displaying the data in the 
regular list form. 

However, the drawback of using PIVOT, is that we had to tell it how many columns 
and give each of them names manually. It cannot determine this automatically.

We have decided to have it display all the subjects starting from our first term
to the current term.

*/

-- NOTE: even though we are not calculating the sum of anything here, 
-- PIVOT requires an aggregate function

Prompt Creating View 1

CREATE OR REPLACE VIEW a2vwTranscript AS (

    SELECT *
        FROM (
            SELECT firstName || ' ' || lastName AS "Name", courseCode, gradeObtained
                FROM a2students JOIN a2jnc_students_sections USING(studentID)
                    JOIN a2sections USING(sectionID)
        )
        PIVOT (
            sum(gradeObtained)
            FOR courseCode
            IN (
                -- Aliases were required to remove single quotes from output
                'IPC144' AS IPC144, 'ULI101' AS ULI101, 'CPR101' AS CPR101, 'COM101' AS COM101, 
                'OOP244' AS OOP244, 'WEB222' AS WEB222, 'DBS201' AS DBS201, 'DCF255' AS DCF255,
                'OOP345' AS OOP345, 'WEB322' AS WEB322, 'DBS301' AS DBS301, 'SYS366' AS SYS366
            )
        ) 
        
);

Prompt Using View 1

SELECT * FROM a2vwTranscript;

/*
  
Original solution for View 1, in case you don't like the PIVOT solution 
   
CREATE OR REPLACE VIEW a2vwtranscript AS (

    SELECT firstName || ' ' || lastName AS "Name", courseCode, gradeObtained
        FROM a2students JOIN a2jnc_students_sections USING(studentID)
            JOIN a2sections USING(sectionID);
            
);

*/

-- View 2
Prompt Creating View 2
CREATE OR REPLACE VIEW a2vwSectionStudents AS (
    SELECT firstName ||' ' || lastName AS "Student Name",
            studentID AS "Student ID",
            sectionID AS "Section ID"
        FROM a2sections JOIN a2jnc_students_sections USING (sectionID)
            JOIN a2students USING (studentid)
        WHERE upper(termCode) LIKE upper('%&termCode_yymm%')
            AND upper(courseCode) LIKE upper('%&courseCode_ex_WEB222%')
            AND upper(sectionLetter) LIKE upper('%&sectionLetter_ex_I%')
);        

Prompt Using View 2
SELECT * FROM a2vwSectionStudents;

-- View 3
Prompt Creating View 3
CREATE OR REPLACE VIEW a2vwSectionAverage AS (
    SELECT sectionID AS "Section ID",
            round(avg(gradeObtained),2) AS "Section Average",
            (
            
                SELECT firstName || ' ' || lastName 
                    FROM a2employees e 
                    WHERE e.empID = a2sections.profID
            
            ) AS "Professor Name",
            profID AS "Professor ID"
        FROM a2jnc_students_sections JOIN a2sections USING (sectionID)
            JOIN a2employees ON a2employees.empID = a2sections.profID
            JOIN a2term USING(termCode)
        WHERE startDate < sysdate
        GROUP BY sectionID, profID    
);    

Prompt Using View 3
SELECT * FROM a2vwSectionAverage
    ORDER BY "Section ID";
    
-- View 4
Prompt Creating View 4

CREATE OR REPLACE VIEW a2vwProgramCoreCourses AS (
    SELECT progCode AS "Program",
            courseCode AS "Course Code",
            courseName AS "Required Course",
            term_Req AS "Term Required"
        FROM a2jnc_prog_courses JOIN a2courses USING (courseCode)
);

Prompt Using View 4
SELECT * FROM a2vwProgramCoreCourses
    ORDER BY "Program", "Term Required";
        
        
-- View 5
Prompt Creating View 5

CREATE OR REPLACE VIEW a2vwTermStats AS (
    SELECT courseCode ||' - '|| courseName AS "Course",
            sectionLetter AS "Section",
            firstName ||' '|| lastName AS "Professor Name",
            count(studentID) AS "Students Enrolled"
        FROM a2employees JOIN a2sections ON a2employees.empID = a2sections.profID
            RIGHT JOIN a2courses USING (courseCode)
            LEFT JOIN a2jnc_students_sections USING (sectionID)
        WHERE termCode LIKE '%&termCode_yymm%'
        GROUP BY termCode, firstName ||' '|| lastName, courseCode ||' - '|| courseName, sectionLetter
);        

Prompt Using View 5
SELECT * FROM a2vwTermStats
    ORDER BY "Course", "Section";
    
/*

Another method for view 5
This CREATE VIEW command works, but it issues a warning
that we were never able to solve.

CREATE OR REPLACE VIEW a2vwTermStats AS (

    SELECT courseCode ||' - '|| courseName AS "Course",
            sectionLetter AS "Section",
            firstName ||' '|| lastName AS "Professor Name",
            NVL((  
            
                SELECT count(studentID)
                    FROM a2jnc_students_sections
                    WHERE sectionID = a2sections.sectionID
                    GROUP BY sectionID
                    
            ), 0) AS "Students Enrolled"
        FROM a2employees JOIN a2sections ON a2employees.empID = a2sections.profID
            JOIN a2courses USING (courseCode)
        WHERE termCode LIKE '%&termCode%'
    
);        

SELECT * FROM a2vwtermstats;

*/

COMMIT;