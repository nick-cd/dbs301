REVOKE ALL
    ON user_objects
    FROM PUBLIC;

-- TODO: find out how to check for existance of a table before 
-- dropping it
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

-- NOTE: Display order is a column to be used as a ordering
-- precendence column

Prompt **************************************************
Prompt Table creations
Prompt **************************************************

Prompt Creating Departments Table

CREATE TABLE a2departments (

    deptCode        INTEGER         GENERATED AS IDENTITY(START WITH 1),
    deptName        VARCHAR2(55)    NOT NULL,
    officeNumber    INTEGER,
    displayOrder    INTEGER,
    
        CONSTRAINT a2departments_deptCode_pk PRIMARY KEY
    
);

Prompt Creating Terms Table

CREATE TABLE a2term (

    termCode    INTEGER         GENERATED AS IDENTITY,
    termName    VARCHAR2(11)    NOT NULL,
    startDate   DATE            NOT NULL,
    endDate     DATE            NOT NULL,
    
        CONSTRAINT a2term_termCode_pk PRIMARY KEY(termCode)
);

Prompt Creating Employees Table

CREATE TABLE a2employees (

    empID       INTEGER         GENERATED AS IDENTITY,
    firstName   VARCHAR2(25),
    lastName    VARCHAR2(25)    NOT NULL,
    prefix      VARCHAR2(5),
    suffix      VARCHAR2(5),
    isActive    INTEGER         DEFAULT 1 CONSTRAINT a2employees_isActive_req NOT NULL,
    sin         INTEGER         NOT NULL,
    dob         DATE            NOT NULL,
    email       VARCHAR2(35)    NOT NULL,
    phone       VARCHAR2(18),
        
        CONSTRAINT emp_ID_pk PRIMARY KEY,
        CONSTRAINT a2employees_sin_unq UNIQUE(sin),
        CONSTRAINT a2employees_email_unq UNIQUE(email),
        CONSTRAINT a2employees_phone_unq UNIQUE(phone)

);


Prompt Creating Advisors Table

CREATE TABLE a2advisors (

    empID       NUMBER(5, 0),
    isActive    NUMBER(1, 0) DEFAULT 1,

        CONSTRAINT a2advisors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2advisors_isActive_chk CHECK(isActive IN(1, 0)),  
        CONSTRAINT a2advisors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID)

);


Prompt Creating Countries Table

CREATE TABLE a2countries (

    countryCode     CHAR(2),
    countryName     VARCHAR2(56)    NOT NULL,
    continent       CHAR(2)         NOT NULL,
    isActive        NUMBER(1, 0)    DEFAULT 1 NOT NULL,
        
        CONSTRAINT a2countries_countryCode_pk PRIMARY KEY(countryCode),
        CONSTRAINT a2countries_countryName_unq UNIQUE(countryName),
        CONSTRAINT a2countries_isActive_chk CHECK(isActive IN(1, 0))
            
);

Prompt Creating Courses Table

CREATE TABLE a2courses (

    courseCode      VARCHAR2(8),
    courseName      VARCHAR2(50)    NOT NULL,
    isAvailable     NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    description     VARCHAR2(38),
    
        CONSTRAINT a2courses_courseCode_pk PRIMARY KEY(courseCode),
        CONSTRAINT a2courses_isAvailable_chk CHECK(isAvailable IN(1, 0))
    
);

Prompt Creating Programs Table

CREATE TABLE a2programs (

    progCode    CHAR(3),
    progName    VARCHAR2(55)    NOT NULL,
    lengthYears NUMBER(1, 0)    NOT NULL,
    isCurrent   NUMBER(1, 0)    DEFAULT 1 NOT NULL,
    deptCode    NUMBER(4)       NOT NULL,
    
        CONSTRAINT a2programs_progCode_pk PRIMARY KEY(progCode),
        CONSTRAINT a2programs_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode),
        CONSTRAINT a2programs_isCurrent_chk CHECK(isCurrent IN (0, 1)),
        CONSTRAINT a2programs_lengthYears_chk CHECK(lengthYears > 0)
);

Prompt Creating Students Table

CREATE TABLE a2students (

    studentID   NUMBER(5, 0)    GENERATED AS IDENTITY,
    firstName   VARCHAR2(20)    NOT NULL,
    lastName    VARCHAR2(25)    NOT NULL,
    dob         DATE            NOT NULL,
    gender      CHAR(1),
    email       VARCHAR2(25)    NOT NULL,
    homeCountry CHAR(2),
    phone       VARCHAR2(14),
    advisorID   NUMBER(5, 0),
    
        CONSTRAINT a2students_studentID_pk PRIMARY KEY,
        CONSTRAINT a2students_homeCountry_fk FOREIGN KEY(homeCountry)
            REFERENCES a2countries(countryCode),
        CONSTRAINT a2students_advisorID_fk FOREIGN KEY(advisorID)
            REFERENCES a2advisors(empID)
            
);

-- constraint names for this table were a little too long...
-- I was forced to shorten the identifiers

-- for ex:
-- instead of: a2jnc_students_courses_isActive_req
-- it was changed to: a2stud_courses_isActive_req

Prompt Creating Student_Courses Table

CREATE TABLE a2jnc_students_courses (

    courseCode      VARCHAR2(8),
    studentID       NUMBER(5, 0),
    mark            INTEGER,
    isActive        NUMBER(1, 0) DEFAULT 1 NOT NULL,

        CONSTRAINT a2stud_courses_pk PRIMARY KEY(courseCode, studentID),
        CONSTRAINT a2stud_courses_isActive_chk CHECK(IsActive IN(1, 0)),
        CONSTRAINT a2stud_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2stud_courses_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

Prompt Creating Prog_Courses Table

CREATE TABLE a2jnc_prog_courses (

    progCourseID    NUMBER(5, 0)    GENERATED AS IDENTITY,
    progCode        CHAR(3)         NOT NULL,
    courseCode      VARCHAR2(8),
    isActive        NUMBER(1, 0)    DEFAULT 1 NOT NULL,

        CONSTRAINT a2prog_courses_progCourseID_pk PRIMARY KEY,
        CONSTRAINT a2prog_courses_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode)

);


Prompt Creating Prog_Students Table

CREATE TABLE a2jnc_prog_students (

    progCode        CHAR(3),
    studentID       NUMBER(5, 0),
    isActive        NUMBER(1, 0) DEFAULT 1,

        CONSTRAINT a2prog_students_pk PRIMARY KEY(progCode, studentID),
        CONSTRAINT a2prog_students_isActive_chk CHECK(IsActive IN(1, 0)),      
        CONSTRAINT a2prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)
);


Prompt Creating Professors Table

CREATE TABLE a2professors (

    empID       NUMBER(5, 0),
    deptCode    NUMBER(3, 0),
    isActive    NUMBER(1, 0) DEFAULT 1,
    
        CONSTRAINT a2professors_isActive_chk CHECK(isActive IN(1, 0)),
        CONSTRAINT a2professors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2professors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID),
        CONSTRAINT a2professors_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode)
            
);


Prompt Creating Sections Table

CREATE TABLE a2sections (

    sectionID       NUMBER(4, 0) GENERATED AS IDENTITY,
    sectionLetter   CHAR(1),
    courseCode      VARCHAR2(8),
    termCode        NUMBER(5, 0),
    profID          NUMBER(5, 0),
    
        CONSTRAINT a2sections_sectionID_pk PRIMARY KEY(sectionID),
        CONSTRAINT a2sections_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2sections_termCode_fk FOREIGN KEY(termCode)
            REFERENCES a2term(termCode),
        CONSTRAINT a2sections_profID_fk FOREIGN KEY(profID)
            REFERENCES a2professors(empID)
);

-- TODO: add descriptions for each course
Prompt Semester 1 courses(CPD and CPA)

INSERT INTO a2courses VALUES (
	'IPC144', 'Introduction to Programming Using C', 1, NULL
);

INSERT INTO a2courses VALUES (
	'APC100', 'Applied Professional Communications', 0, NULL
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


Prompt Semester 2 courses(CPD and CPA)

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


Prompt Semester 3 courses(CPD and CPA)

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
	'WEB322', 'Web Programming Tools and Framework' , 1, NULL
);

-- TODO: add the rest of the CPA program
Prompt Semester 4 Courses(CPD and CPA)

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


Prompt Semester 4 professional option(CPD)

INSERT INTO a2courses VALUES (
	'UNX511', 'UNIX Systems Programming', 1, NULL
);


Prompt General Education Courses

INSERT INTO a2courses VALUES (
    'CAN190', 'Introduction to Canadian Politics', 1, NULL
);

Prompt Employees insertions

-- unknown prof, required for couses we have not taken yet
INSERT INTO a2employees VALUES (
    0, NULL, 'Unknown', NULL, NULL, 0, 0, 
        to_date('1970-01-01', 'yyyy-mm-dd'), '?',
        NULL
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Clint', 'MacDonald', NULL, NULL, 1, 123456789, 
		to_date('1999-03-10', 'yyyy-mm-dd'), 
		'clint.macdonald@senecacollege.ca', '416.491.5050e24158'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Ron', 'Tarr', NULL, NULL, 1, 444555666, 
		to_date('1990-09-20', 'yyyy-mm-dd'),
		'ron.tarr@senecacollege.ca', '416.491.5050e24026'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Robert' , 'Stewart', NULL, NULL, 1, 111222333,
		to_date('1986-04-29', 'yyyy-mm-dd'), 
		'rob.stewart@senecacollege.ca', '416.491.5050e22752'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Nathan', 'Misener', NULL, NULL, 1, 67890123, 
		to_date('1990-07-12', 'yyyy-mm-dd'),
		'nathan.misener@senecacollege.ca', NULL
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Asam', 'Gulaid', NULL, NULL, 1, 098765432,
		to_date('1867-07-01', 'yyyy-mm-dd'),
		'asam.gulaid1@senecacollege.ca', '647.470.6438'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Stanley', 'Ukah', NULL, NULL, 1, 999888777,
		to_date('1979-08-15', 'yyyy-mm-dd'),
		'stanley.ukah1@senecacollege.ca', '416.491.5050e33212'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Kadeem', 'Best', NULL, NULL, 1, 555666777,
		to_date('1985-04-12', 'yyyy-mm-dd'),
		'kadeem.best@senecacollege.ca', NULL
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'James', 'Mwangi', NULL, NULL, 1, 111111111,
		to_date('1970-03-18', 'yyyy-mm-dd'),
		'james.mwangi@senecacollege.ca', '416.491.5050e22553'
);

INSERT INTO a2employees VALUES (
	DEFAULT, 'Marc', 'Menard', NULL, NULL, 1, 222222222,
		to_date('1965-07-13', 'yyyy-mm-dd'), 
		'marc.menard@senecacollege.ca', '416.491.5050e26929'
);

INSERT INTO a2employees VALUES (
    DEFAULT, 'Betrice', 'Brangman', NULL, NULL, 1, 333333333,
        to_date('1980-04-10', 'yyyy-mm-dd'),
        'betrice.brangman@senecacollege.ca',
        '416.491.5050e26683'
);

Prompt Departments insertions

INSERT INTO a2departments VALUES (
	DEFAULT, 'School of Information and Communications Technology', NULL, NULL
);

INSERT INTO a2departments VALUES (
	DEFAULT, 'School of Software Design and Data Science', NULL, NULL
);

INSERT INTO a2departments VALUES (
	DEFAULT, 'School of English and Liberal Studies', NULL, NULL
);


Prompt Professor insertions

-- Unknown prof
INSERT INTO a2professors VALUES (
    0, 1, 0
);

-- Clint
INSERT INTO a2professors VALUES (
	1, 1, 1
);

-- Ron
INSERT INTO a2professors VALUES (
	2, 1, 1
);

-- Robert
INSERT INTO a2professors VALUES (
	3, 1, 1
);

-- Nathan
INSERT INTO a2professors VALUES (
	4, 1, 1
);

-- Asam
INSERT INTO a2professors VALUES (
	5, 1, 1
);

-- Stanley
INSERT INTO a2professors VALUES (
	6, 1, 1
);

-- Kadeem
INSERT INTO a2professors VALUES (
	7, 2, 1
);

-- James
INSERT INTO a2professors VALUES (
	8, 1, 1
);

-- Marc
INSERT INTO a2professors VALUES (
	9, 3, 1
);


Prompt Advisor Insertions

-- Betrice
INSERT INTO a2advisors VALUES (
    10, 1
);

Prompt Program Insertions

INSERT INTO a2programs VALUES (
    'CPD', 'Computer Programmer', 2, 1, 1
);

INSERT INTO a2programs VALUES (
    'CPA', 'Computer Programming and Analysis', 3, 1, 1
);

INSERT INTO a2programs VALUES (
    'BSD', 'Honours Bachelor of Technology - Software Development', 4, 1, 1
);

INSERT INTO a2programs VALUES (
    'CNS', 'Computer Networking and Technical Support', 2, 1, 1
);


Prompt Term Insertions

INSERT INTO a2term VALUES (
    DEFAULT, 'Fall 2019', to_date('2019-09-03', 'yyyy-mm-dd'),
        to_date('2019-12-13', 'yyyy-mm-dd')
);

INSERT INTO a2term VALUES (
    DEFAULT, 'Winter 2020', to_date('2020-01-06', 'yyyy-mm-dd'),
        to_date('2020-04-17', 'yyyy-mm-dd')
);

Prompt Section Insertions

INSERT INTO a2sections VALUES (
    DEFAULT, 'B', 'OOP345', 1, 4
);

INSERT INTO a2sections VALUES (
    DEFAULT, 'L', 'DBS301', 1, 1
);

INSERT INTO a2sections VALUES (
    DEFAULT, 'D', 'SYS366', 1, 6
);

INSERT INTO a2sections VALUES (
    DEFAULT, 'A', 'CAN190', 1, 9
);


Prompt Junction Program Courses Insertions

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


Prompt Country Insertions

INSERT INTO a2countries VALUES (
    'CA', 'Canada', 'NA', 1
);

INSERT INTO a2countries VALUES ( 
    'US', 'United States of America', 'NA', 1 
);


Prompt Student Insertions

INSERT INTO a2students VALUES (
    DEFAULT, 'Nicholas', 'Defranco', to_date('2000-06-16', 'yyyy-mm-dd'),
        'M', 'ndefranco@myseneca.ca', 'CA', NULL, 10
);

Prompt Junction Program Students Insertions

INSERT INTO a2jnc_prog_students VALUES (
    'CPD', 1, 1
);


Prompt Junction Student Courses

INSERT INTO a2jnc_prog_students VALUES (
    'OOP345', 1, 1
);

INSERT INTO a2jnc_prog_students VALUES (
    'SYS366', 1, 1
);

INSERT INTO a2jnc_prog_students VALUES (
    'DBS301', 1, 1
);

INSERT INTO a2jnc_prog_students VALUES (
    'CAN190', 1, 1
);

Prompt Junction Students Courses Insertions

-- courseCode, studentID, mark, isActive
INSERT INTO a2jnc_students_courses VALUES (
    'OOP345', 1, 90, 1
);

INSERT INTO a2jnc_students_courses VALUES (
    'SYS366', 1, 70, 1
);

INSERT INTO a2jnc_students_courses VALUES (
    'DBS301', 1, 80, 1
);

INSERT INTO a2jnc_students_courses VALUES (
    'CAN190', 1, 70, 1
);