-- GROUP 12
-- Date: Nov 23, 2019
-- Pupose: assignment 2

Prompt ******  Dropping existing tables (IF THEY ARE THERE) ....
DROP TABLE a2departments CASCADE CONSTRAINTS;
DROP TABLE a2term CASCADE CONSTRAINTS;
DROP TABLE a2employees CASCADE CONSTRAINTS;
DROP TABLE a2continents CASCADE CONSTRAINTS;
DROP TABLE a2countries CASCADE CONSTRAINTS;
DROP TABLE a2courses CASCADE CONSTRAINTS;
DROP TABLE a2programs CASCADE CONSTRAINTS;
DROP TABLE a2students CASCADE CONSTRAINTS;
DROP TABLE a2jnc_students_courses CASCADE CONSTRAINTS;
DROP TABLE a2jnc_prog_courses CASCADE CONSTRAINTS;
DROP TABLE a2jnc_prog_students CASCADE CONSTRAINTS;
DROP TABLE a2advisors CASCADE CONSTRAINTS;
DROP TABLE a2professors CASCADE CONSTRAINTS;
DROP TABLE a2professors CASCADE CONSTRAINTS;
DROP TABLE a2sections CASCADE CONSTRAINTS;

Prompt ******  Creating Departments table ....

CREATE TABLE a2departments 
 (
    deptCode integer ,
    deptName varchar2(20),
    OfficeNumber integer NOT NULL,
    DisplayOrder integer NOT NULL,
    CONSTRAINT a2department_pk PRIMARY KEY (deptCode) 
 );
 
 
 Prompt  ******  Creating a2term  table ....
 CREATE TABLE a2term 
 (
    termCode integer,
    termName varchar2(20) NOT NULL,
    startDate Date NOT NULL,
    EndDate Date NOT NULL,
    CONSTRAINT a2term_pk PRIMARY KEY (termCode
    
 );
 
 
 Prompt ******  Creating a2courses  table ....
 CREATE TABLE a2courses 
 (
    courseCode varchar2(10),
    CourseName varchar2(50) NOT NULL,
    isAvailable integer,
    _field varchar2(100),
    CONSTRAINT a2courses_pk PRIMARY KEY (courseCode) 
 );
 
 
  Prompt ******  Creating a2countries  table ....
 CREATE TABLE a2countries
 (
    CountryCode varchar2(5),
    CountryName varchar2(30) NOT NULL,
    Continent varchar2(20) NOT NULL,
    isActive integer DEFAULT 1,
    CONSTRAINT a2countries_pk PRIMARY KEY (CountryCode)
 );
 
 
   Prompt ******  Creating a2employees  table ....
 CREATE TABLE a2employees
 (
    empID integer,
    FirstName varchar2(20) NOT NULL,
    LastName varchar2(30) NOT NULL,
    prefix varchar2(10),
    suffix varchar2(10),
    isActive integer,
    SIN integer NOT NULL,
    DOB date NOT NULL,
    email varchar2(50) NOT NULL,
    phone varchar(15) NOT NULL,
    CONSTRAINT a2employees_pk PRIMARY KEY (empID),
    CONSTRAINT a2employees_sin_unq UNIQUE (SIN),
    CONSTRAINT a2employees_email_unq UNIQUE (email),
    CONSTRAINT a2employees_phone_unq UNIQUE (phone)
    
 )
 
    Prompt ******  Creating a2programs  table ....
 CREATE TABLE a2programs
 (
    progCode varchar2(5),
    progName varchar2(50) NOT NULL,
    lengthYears integer NOT NULL,
    isCurrent integer,
    deptCode integer NOT NULL,
    CONSTRAINT a2programs_pk PRIMARY KEY (progCode),
    CONSTRAINT a2programs_deptCode_fk FOREIGN KEY (deptCode) REFERENCES a2departments(deptCode)
    CONSTRAINT a2programs_lengthYears_ck CHECK (lengthYears > 0)
 )
 
    Prompt ******  Creating a2professors  table ....
 CREATE TABLE a2professors 
 (
    empID integer,
    deptCode integer ,
    isActive integer,
    CONSTRAINT a2professors_pk PRIMARY KEY (empID),
            CONSTRAINT a2professors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID),
        CONSTRAINT a2professors_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode)
    
    
 )
 
     Prompt ******  Creating a2sections  table ....
 
 CREATE TABLE a2sections 
 (
    sectionID varchar2(5),
    sectionLetter varchar(5) NOT NULL,
    courseCode varchar2(10) NOT NULL,
    termCode integer NOT NULL,
    profID integer,
    
    CONSTRAINT a2sections_pk PRIMARY KEY(sectionID),
    CONSTRAINT a2sections_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
    CONSTRAINT a2sections_termCode_fk FOREIGN KEY(termCode)
            REFERENCES a2term(termCode),
    CONSTRAINT a2sections_profID_fk FOREIGN KEY(profID)
            REFERENCES a2professors(empID)
    
 )
 
    Prompt ******  Creating a2jnc_prog_courses  table ....
 CREATE TABLE a2jnc_prog_courses
 (
     progCourseID integer,
     progCode varchar2(5),
     courseCode varchar2(10),
     isActive integer,
     
     CONSTRAINT a2jnc_prog_courses_pk PRIMARY KEY (progCourseID),
     CONSTRAINT a2prog_courses_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
    CONSTRAINT a2prog_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode)
)

    Prompt ******  Creating a2advisors  table ....
 CREATE TABLE a2advisors 
(
    empID integer,
    isActive integer,
    
     CONSTRAINT a2advisors_pk PRIMARY KEY(empID),
    CONSTRAINT a2advisors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID)
)
 
 
    Prompt ******  Creating a2students  table .... 
 CREATE TABLE a2students
 (
      studentID   integer    GENERATED AS IDENTITY,
    firstName   VARCHAR2(20)      NOT NULL,
    lastName    VARCHAR2(25)      NOT NULL,
    dob         DATE             NOT NULL,
    gender      CHAR(1),
    email       VARCHAR2(25)      NOT NULL,
    CountryCode varchar2(5),
    phone       VARCHAR2(14),
    advisorID   integer,
    
        CONSTRAINT a2students_pk PRIMARY KEY (studentID),
        CONSTRAINT a2students_homeCountry_fk FOREIGN KEY(homeCountry)
            REFERENCES a2countries(countryCode),
        CONSTRAINT a2students_advisorID_fk FOREIGN KEY(advisorID)
            REFERENCES a2advisors(empID)
)
 
 
    Prompt ******  Creating a2jnc_students_courses  table ....
 
CREATE TABLE a2jnc_students_courses (

    courseCode      VARCHAR2(8),
    studentID       integer,
    isActive        integer  NOT NULL,

        CONSTRAINT a2stud_courses_pk PRIMARY KEY(courseCode, studentID),
        CONSTRAINT a2stud_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2stud_courses_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

    Prompt ******  Creating a2jnc_students_courses  table ....
    
CREATE TABLE a2jnc_prog_students (

    progCode varchar2(5),
    studentID   integer,
    isActive    integer DEFAULT 1,

        CONSTRAINT a2prog_students_pk PRIMARY KEY(progCode, studentID),
        CONSTRAINT a2prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)
);
 
 