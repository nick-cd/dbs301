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
    sectionID VARCHAR2(5),
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
     progCourseID INTEGER,
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
    studentID   INTEGER    GENERATED AS IDENTITY,
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
 
 