-- GROUP 12
-- Date: Nov 23, 2019
-- Pupose: assignment 2

Prompt ******  Dropping existing tables (IF THEY ARE THERE) ....
DROP TABLE a2departments CASCADE CONSTRAINTS;
DROP TABLE a2term CASCADE CONSTRAINTS;
DROP TABLE a2employees CASCADE CONSTRAINTS;
DROP TABLE a2countries CASCADE CONSTRAINTS;
DROP TABLE a2courses CASCADE CONSTRAINTS;
DROP TABLE a2programs CASCADE CONSTRAINTS;
DROP TABLE a2students CASCADE CONSTRAINTS;
DROP TABLE a2jnc_students_courses CASCADE CONSTRAINTS;
DROP TABLE a2jnc_prog_courses CASCADE CONSTRAINTS;
DROP TABLE a2jnc_prog_students CASCADE CONSTRAINTS;
DROP TABLE a2advisors CASCADE CONSTRAINTS;
DROP TABLE a2professors CASCADE CONSTRAINTS;
DROP TABLE a2sections CASCADE CONSTRAINTS;

Prompt ******  Creating a2departments table ....

CREATE TABLE a2departments 
 (
    deptCode INTEGER ,
    deptName VARCHAR2(50),
    OfficeNumber VARCHAR(5) NOT NULL,
    DisplayOrder INTEGER NOT NULL,
    CONSTRAINT a2department_pk PRIMARY KEY (deptCode) 
 );
 
 
Prompt ******  Creating a2term table ....
 CREATE TABLE a2term 
 (
    termCode INTEGER,
    termName VARCHAR2(20) NOT NULL,
    startDate Date NOT NULL,
    EndDate Date NOT NULL,
    CONSTRAINT a2term_pk PRIMARY KEY (termCode)
    
 );
 
 
Prompt ******  Creating a2courses table ....
 CREATE TABLE a2courses 
 (
    courseCode VARCHAR2(10),
    CourseName VARCHAR2(50) NOT NULL,
    isAvailable INTEGER,
    field VARCHAR2(100),
    CONSTRAINT a2courses_pk PRIMARY KEY (courseCode) 
 );
 
Prompt ******  Creating a2countries  table ....
 CREATE TABLE a2countries
 (
    CountryCode VARCHAR2(5),
    CountryName VARCHAR2(30) NOT NULL,
    Continent VARCHAR2(20) NOT NULL,
    isActive INTEGER DEFAULT 1,
    CONSTRAINT a2countries_pk PRIMARY KEY (CountryCode)
 );
 
 
Prompt ******  Creating a2employees  table ....
 CREATE TABLE a2employees
 (
    empID INTEGER,
    FirstName VARCHAR2(20) NOT NULL,
    LastName VARCHAR2(30) NOT NULL,
    prefix VARCHAR2(10),
    suffix VARCHAR2(10),
    isActive INTEGER,
    SIN INTEGER NOT NULL,
    DOB date NOT NULL,
    email VARCHAR2(50) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT a2employees_pk PRIMARY KEY (empID),
    CONSTRAINT a2employees_sin_unq UNIQUE (SIN),
    CONSTRAINT a2employees_email_unq UNIQUE (email),
    CONSTRAINT a2employees_phone_unq UNIQUE (phone)
    
 );
 
Prompt ******  Creating a2programs  table ....
 CREATE TABLE a2programs
 (
    progCode VARCHAR2(5),
    progName VARCHAR2(50) NOT NULL,
    lengthYears INTEGER NOT NULL,
    isCurrent INTEGER,
    deptCode INTEGER NOT NULL,
    CONSTRAINT a2programs_pk PRIMARY KEY (progCode),
    CONSTRAINT a2programs_deptCode_fk FOREIGN KEY (deptCode) REFERENCES a2departments(deptCode),
    CONSTRAINT a2programs_lengthYears_ck CHECK (lengthYears > 0)
 );
 
Prompt ******  Creating a2professors  table ....
 CREATE TABLE a2professors 
 (
    empID INTEGER,
    deptCode INTEGER ,
    isActive INTEGER,
    CONSTRAINT a2professors_pk PRIMARY KEY (empID),
            CONSTRAINT a2professors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID),
        CONSTRAINT a2professors_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode)
    
    
 );
 
Prompt ******  Creating a2sections  table ....
 
 CREATE TABLE a2sections 
 (
    sectionID INTEGER GENERATED AS IDENTITY,
    sectionLetter VARCHAR(5) NOT NULL,
    courseCode VARCHAR2(10) NOT NULL,
    termCode INTEGER NOT NULL,
    profID INTEGER,
    
    CONSTRAINT a2sections_pk PRIMARY KEY(sectionID),
    CONSTRAINT a2sections_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
    CONSTRAINT a2sections_termCode_fk FOREIGN KEY(termCode)
            REFERENCES a2term(termCode),
    CONSTRAINT a2sections_profID_fk FOREIGN KEY(profID)
            REFERENCES a2professors(empID)
    
 );
 
 
Prompt ******  Creating a2jnc_prog_courses  table ....
 CREATE TABLE a2jnc_prog_courses
 (
     progCourseID INTEGER GENERATED AS IDENTITY,
     progCode VARCHAR2(5),
     courseCode VARCHAR2(10),
     isActive INTEGER,
     
     CONSTRAINT a2jnc_prog_courses_pk PRIMARY KEY (progCourseID),
     CONSTRAINT a2prog_courses_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
    CONSTRAINT a2prog_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode)
);

Prompt ******  Creating a2advisors  table ....
 CREATE TABLE a2advisors 
(
    empID INTEGER,
    isActive INTEGER,
    
     CONSTRAINT a2advisors_pk PRIMARY KEY(empID),
    CONSTRAINT a2advisors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID)
);
 
 
Prompt ******  Creating a2students  table .... 
 CREATE TABLE a2students
 (
    studentID   INTEGER  ,
    firstName   VARCHAR2(20)      NOT NULL,
    lastName    VARCHAR2(25)      NOT NULL,
    dob         DATE             NOT NULL,
    gender      CHAR(1),
    email       VARCHAR2(25)      NOT NULL,
    homeCountry VARCHAR2(5),
    phone       VARCHAR2(14),
    advisorID   INTEGER,
    
        CONSTRAINT a2students_pk PRIMARY KEY (studentID),
        CONSTRAINT a2students_homeCountry_fk FOREIGN KEY(homeCountry)
            REFERENCES a2countries(countryCode),
        CONSTRAINT a2students_advisorID_fk FOREIGN KEY(advisorID)
            REFERENCES a2advisors(empID)
);
 
 
Prompt ******  Creating a2jnc_students_courses  table ....
 
CREATE TABLE a2jnc_students_courses (

    courseCode      VARCHAR2(8),
    studentID       INTEGER,
    isActive        INTEGER  NOT NULL,

        CONSTRAINT a2stud_courses_pk PRIMARY KEY(courseCode, studentID),
        CONSTRAINT a2stud_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2stud_courses_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

Prompt ******  Creating a2jnc_students_courses  table ....
    
CREATE TABLE a2jnc_prog_students (

    progCode VARCHAR2(5),
    studentID   INTEGER,
    isActive    INTEGER DEFAULT 1,

        CONSTRAINT a2prog_students_pk PRIMARY KEY(progCode, studentID),
        CONSTRAINT a2prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)
);
 
 
 INSERT INTO a2departments VALUES (100, 'School of ICT', 'A3002', 111 );
 INSERT INTO a2departments VALUES (
	200 , 'School of English', 'B3000', 222
);
Prompt ******  Creating a2courses  table ....
 INSERT INTO a2courses VALUES (
	'IPC144', 'Introduction to Programming Using C', 1, NULL
);
INSERT INTO a2courses VALUES (
	'APC100', 'Applied Professional Communications', 1, NULL
);

INSERT INTO a2courses VALUES (
	'COM101', 'Communicating Across Contexts', 1, NULL
);

INSERT INTO a2courses VALUES (
	'CPR101', 'Computer Principles for Programmers', 1, NULL
);

INSERT INTO a2courses VALUES (
	'ULI101', 'Introduction to UNIX/Linux and the Internet', 1, NULL
);

INSERT INTO a2courses VALUES (
    'EAC149', 'English and Communications', 1, NULL
);

INSERT INTO a2courses VALUES (
	'DBS201', 'Introduction to Database Design and SQL', 1, NULL
);

INSERT INTO a2courses VALUES (
	'DCF255', 'Data Communications Fundamentals', 1, NULL
);

INSERT INTO a2courses VALUES (
	'OOP244', 'Introduction to Object Oriented Programming', 1, NULL
);

INSERT INTO a2courses VALUES (
	'WEB222', 'Web Programming Principles', 1, NULL
);
 INSERT INTO a2courses VALUES (
	'DBS301', 'Database Design || and SQL Using Oracle', 1, NULL
);

INSERT INTO a2courses VALUES (
	'OOP345', 'Object-Oriented Software Development Using C++', 1, NULL
);

INSERT INTO a2courses VALUES (
	'SYS366', 'Requirements Gathering Using OO Models', 1, NULL
);

INSERT INTO a2courses VALUES (
	'WEB322', 'Web Programming Tools and Framework', 1, NULL
);
INSERT INTO a2courses VALUES (
    'WTP100', 'Work Term Preparation', 1, NULL
);
INSERT INTO a2courses VALUES (
	'BCI433', 'IBM Business Computing', 1, NULL
);

INSERT INTO a2courses VALUES (
	'EAC397', 'Business Report Writing', 1, NULL
);

INSERT INTO a2courses VALUES (
	'EAC594', 'Business Communication for the Digital Workplace', 1, NULL
);

INSERT INTO a2courses VALUES (
	'JAC444', 'Introduction to Java for C++ Programmers', 1, NULL
);

INSERT INTO a2courses VALUES (
    'WEB422', 'Web Programming for Apps and Services', 1, NULL
);

INSERT INTO a2courses VALUES (
    'SYS466', 'Analysis and Design Using OO Models', 1, NULL
);
INSERT INTO a2courses VALUES (
    'PRJ566', 'Project Planning and Management', 1, NULL
);

INSERT INTO a2courses VALUES (
    'PRJ666', 'Project Implementation', 1, NULL
);

Prompt ******  Creating a2employees  table ....
INSERT INTO a2employees VALUES (
    0, 'Un', 'known', NULL, NULL, 0, 0, 
        to_date('1970-01-01', 'yyyy-mm-dd'), '?',
        '0'
);

INSERT INTO a2employees VALUES (
	444555666, 'Stanley', 'Ukah', NULL, NULL, 1, 999888777,
		to_date('1979-08-15', 'yyyy-mm-dd'),
		'stanley.ukah1@senecacollege.ca', '416.491.505'
);

INSERT INTO a2employees VALUES (
	222333444, 'Nathan', 'Misener', NULL, NULL, 1, 67890123, 
		to_date('1990-07-12', 'yyyy-mm-dd'),
		'nathan.misener@senecacollege.ca', '111.222.3456'
);
INSERT INTO a2employees VALUES (
	123456789, 'Clint', 'MacDonald', NULL, NULL, 1, 123456789, 
		to_date('1999-03-10', 'yyyy-mm-dd'), 
		'clint.macdonald@senecacollege.ca', '416.491.5050'
);
INSERT INTO a2employees VALUES (
	666777888, 'James', 'Mwangi', NULL, NULL, 1, 111111111,
		to_date('1970-03-18', 'yyyy-mm-dd'),
		'james.mwangi@senecacollege.ca', '416.491.5045'
);
INSERT INTO a2employees VALUES (
    789789789, 'Mary', 'Saith', NULL, NULL, 1, 666666666,
        to_date('1965-09-20', 'yyyy-mm-dd'),
        'mary.saith@senecacollege.ca', '416.491.5342'
);
INSERT INTO a2employees VALUES (
    888999000, 'Betrice', 'Brangman', NULL, NULL, 1, 333333333,
        to_date('1980-04-10', 'yyyy-mm-dd'),
        'betrice.brangman@senecacollege.ca',
        '416.491.9876'
);

Prompt ******  Creating a2professors  table ....
-- Unknown prof
INSERT INTO a2professors VALUES (
    0, 200, 0
);
INSERT INTO a2professors VALUES (
	123456789, 100, 1
);
-- Nathan
INSERT INTO a2professors VALUES (
	222333444, 100, 1
);
-- Stanley
INSERT INTO a2professors VALUES (
	444555666, 100, 1
);
-- James
INSERT INTO a2professors VALUES (
	666777888, 100, 1
);
-- Mary
INSERT INTO a2professors VALUES (
    789789789, 200, 1
);

Prompt ******  Creating a2programs  table ....


INSERT INTO a2programs VALUES (
    'CPD', 'Computer Programmer', 2, 1, 100
);

INSERT INTO a2programs VALUES (
    'CPA', 'Computer Programming and Analysis', 3, 1, 100
);


Prompt ******  Creating a2terms  table ....
INSERT INTO a2term VALUES (
    1, 'Fall 2019', to_date('2019-09-03', 'yyyy-mm-dd'),
        to_date('2019-12-13', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    2, 'Winter 2020', to_date('2020-01-06', 'yyyy-mm-dd'),
        to_date('2020-04-17', 'yyyy-mm-dd')
);
INSERT INTO a2term VALUES (
    3, 'Summer 2019', to_date('2019-05-04', 'yyyy-mm-dd'),
        to_date('2019-08-14', 'yyyy-mm-dd')
);
INSERT INTO a2term VALUES (
    4, 'Fall 2018', to_date('2018-09-03', 'yyyy-mm-dd'),
        to_date('2018-12-13', 'yyyy-mm-dd')
);
Prompt ******  Creating a2sections  table ....
-- sectionID, sectionLetter, courseCode, termCode, profID
INSERT INTO a2sections VALUES (
    DEFAULT, 'B', 'OOP345', 1, 222333444
);
INSERT INTO a2sections VALUES (
    DEFAULT, 'A', 'OOP345', 1, 222333444
);
INSERT INTO a2sections VALUES (
    DEFAULT, 'A', 'DBS301', 1, 123456789
);

INSERT INTO a2sections VALUES (
    DEFAULT, 'B', 'DBS301', 1, 123456789
);
INSERT INTO a2sections VALUES (
    DEFAULT, 'D', 'SYS366', 1, 444555666
);

INSERT INTO a2sections VALUES (
    DEFAULT, 'E', 'SYS366', 1, 444555666
);
INSERT INTO a2sections VALUES (
    DEFAULT, 'C', 'WTP100', 1, 789789789
);
INSERT INTO a2sections VALUES (
    DEFAULT, 'E', 'WEB322', 1, 666777888
);
Prompt ******  Creating a2jnc_prog_courses  table ....
-- progCourseID, progCode, courseCode, isActive
INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'IPC144', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'ULI101', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'APC100', 0
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'CPR101', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'COM101', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'DBS201', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'DCF255', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'OOP244', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'WEB222', 1
);
INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'OOP345', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'DBS301', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'SYS366', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'WEB322', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'BCI433', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'EAC397', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'EAC594', 1
);

INSERT INTO a2jnc_prog_courses VALUES (
    DEFAULT, 'CPD', 'JAC444', 1
);

Prompt ******  Creating a2countries  table ....
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
    'BR', 'Brazil', 'SA', 1
);
Prompt ******  Creating a2advisors  table ....
-- Betrice
INSERT INTO a2advisors VALUES (
    888999000, 1
);

Prompt ******  Creating a2students  table ....
INSERT INTO a2students VALUES (
    333333333, 'Nicholas', 'Defranco', to_date('2000-06-16', 'yyyy-mm-dd'),
        'M', 'ndefranco@myseneca.ca', 'IT', '111.222.3333', 888999000
);

INSERT INTO a2students VALUES (
    111111111, 'Alex', 'Hai', to_date('1996-11-18', 'yyyy-mm-dd'),
        'M', 'amchai@myseneca.ca', 'CA', '222.333.4444', 888999000
);
INSERT INTO a2students VALUES (
    222222222, 'Henry', 'Nguyen', to_date('1996-11-18', 'yyyy-mm-dd'),
        'M', 'vqdnguyen@myseneca.ca', 'CA', '444.555.6666', 888999000
);