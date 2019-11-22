-- TODO: find out how to check for existance of a table before 
-- dropping it
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
DROP TABLE a2lkp_continents CASCADE CONSTRAINTS;


-- NOTE: Display order is a column to be used as a ordering
-- precendence column

Prompt **************************************************
Prompt Table creations
Prompt **************************************************

CREATE TABLE a2departments (

    deptCode        NUMBER(3, 0)    GENERATED AS IDENTITY(START WITH 1) CONSTRAINT a2departments_deptCode_pk PRIMARY KEY,
    deptName        VARCHAR2(30)    CONSTRAINT a2departments_deptName_req NOT NULL,
    officeNumber    NUMBER(4, 0)       CONSTRAINT a2departments_officeNumber_req NOT NULL,
    displayOrder    NUMBER(1, 0)
    
);

CREATE TABLE a2term (

    termCode    NUMBER(4, 0)    GENERATED AS IDENTITY CONSTRAINT a2term_termCode_pk PRIMARY KEY,
    termName    VARCHAR2(15)    CONSTRAINT a2term_termName_req NOT NULL,
    startDate   DATE            CONSTRAINT a2term_startDate_req NOT NULL,
    endDate     DATE            CONSTRAINT a2term_endDate_req NOT NULL
    
);

CREATE TABLE a2employees (

    empID       NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT emp_ID_pk PRIMARY KEY,
    firstName   VARCHAR2(25),
    lastName    VARCHAR2(25) CONSTRAINT a2employees_lastName_req NOT NULL,
    prefix      VARCHAR(5),
    suffix      VARCHAR(5),
    isActive    NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2employees_isActive_req NOT NULL,
    sin         NUMBER(9, 0) CONSTRAINT a2employees_sin_req NOT NULL,
    dob         DATE,
    email       VARCHAR2(25) CONSTRAINT a2employees_email_req NOT NULL,
    phone       VARCHAR2(12) CONSTRAINT a2employees_phone_req NOT NULL,
        
        CONSTRAINT a2employees_sin_unq UNIQUE(sin),
        CONSTRAINT a2employees_email_unq UNIQUE(email),
        CONSTRAINT a2employees_phone_unq UNIQUE(phone)

);

---- extra table ----
CREATE TABLE a2lkp_continents (

    continentID NUMBER(1, 0)    GENERATED AS IDENTITY CONSTRAINT a2lkp_continents_pk PRIMARY KEY,
    name        VARCHAR(13)     CONSTRAINT a2lkp_continents_name_req NOT NULL,
        
        CONSTRAINT a2lkp_continents_name_unq UNIQUE(name)

);

CREATE TABLE a2countries (

    countryCode NUMBER(3, 0) GENERATED AS IDENTITY CONSTRAINT CountryCode_pk PRIMARY KEY,
    countryName VARCHAR2(56) CONSTRAINT a2countries_countryName_req NOT NULL,
    continentID NUMBER(1, 0) CONSTRAINT a2countries_continentID_req NOT NULL,
    isActive    NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2countries_isActive_req NOT NULL,
        
        CONSTRAINT a2countries_countryName_unq UNIQUE(countryName),
        CONSTRAINT a2countries_isActive_chk CHECK(isActive IN(1, 0)),
        CONSTRAINT a2countries_continentID_fk FOREIGN KEY(continentID)
            REFERENCES a2lkp_continents(continentID)
            
);

CREATE TABLE a2courses (

    courseCode  NUMBER(5, 0)    GENERATED AS IDENTITY CONSTRAINT a2courses_courseCode_pk PRIMARY KEY,
    courseName  VARCHAR(30)     CONSTRAINT a2courses_courseName_req NOT NULL,
    isAvailable NUMBER(1, 0)    DEFAULT 1 CONSTRAINT a2courses_isAvailable_req NOT NULL,
    description VARCHAR2(38),
    
        CONSTRAINT a2courses_isAvailable_chk CHECK(isAvailable IN(1, 0))
    
);

CREATE TABLE a2programs (

    progCode    NUMBER(5, 0)    GENERATED AS IDENTITY CONSTRAINT a2programs_progCode_pk PRIMARY KEY,
    progName    VARCHAR(30)     CONSTRAINT a2programs_progName_req NOT NULL,
    lengthYears NUMBER(1, 0)    CONSTRAINT a2programs_lengthYears_req NOT NULL,
    isCurrent   NUMBER(1, 0)    DEFAULT 1 CONSTRAINT a2programs_isCurrent_req NOT NULL,
    deptCode    NUMBER(4)       CONSTRAINT a2programs_depCode_req NOT NULL,
    
        CONSTRAINT a2programs_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode),
        CONSTRAINT a2programs_isCurrent_chk CHECK(isCurrent IN (0, 1)),
        CONSTRAINT a2programs_lengthYears_chk CHECK(lengthYears > 0)
);


CREATE TABLE a2students (

    studentID   NUMBER(5, 0)    GENERATED AS IDENTITY CONSTRAINT a2students_studentID_pk PRIMARY KEY,
    firstName   VARCHAR(20)     CONSTRAINT a2students_firstName_req NOT NULL,
    lastName    VARCHAR(25)     CONSTRAINT a2students_lastName_req NOT NULL,
    dob         DATE            CONSTRAINT a2students_dob_req NOT NULL,
    gender      CHAR(1),
    email       VARCHAR(25)     CONSTRAINT a2students_email_req NOT NULL,
    homeCountry NUMBER(3, 0),
    phone       VARCHAR(14),
    advisorID   NUMBER(5, 0),
    
        CONSTRAINT a2students_homeCountry_fk FOREIGN KEY(homeCountry)
            REFERENCES a2countries(countryCode)
            
);

-- constraint names for this table were a little too long...
-- I was forced to shorten the identifiers

-- for ex:
-- instead of: a2jnc_students_courses_isActive_req
-- it was changed to: a2stud_courses_isActive_req
CREATE TABLE a2jnc_students_courses (

    courseCode      NUMBER(5, 0),
    studentID       NUMBER(5, 0),
    isActive        NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2stud_courses_isActive_req NOT NULL,

        CONSTRAINT a2stud_courses_pk PRIMARY KEY(courseCode, studentID),
        CONSTRAINT a2stud_courses_isActive_chk CHECK(IsActive IN(1, 0)),
        CONSTRAINT a2stud_courses_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2stud_courses_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

CREATE TABLE a2jnc_prog_courses (

    progCourseID    NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT a2prog_courses_progCourseID_pk PRIMARY KEY,
    progCode        NUMBER(5, 0) CONSTRAINT a2prog_courses_progCode_req NOT NULL,
    courseCode      NUMBER(5, 0),
    isActive        NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2prog_courses_isActive_req NOT NULL

);

CREATE TABLE a2jnc_prog_students (

    progCode        NUMBER(5, 0),
    studentID       NUMBER(5, 0),
    isActive        NUMBER(1, 0) DEFAULT 1,

        CONSTRAINT a2prog_students_pk PRIMARY KEY(progCode, studentID),
        CONSTRAINT a2prog_students_isActive_chk CHECK(IsActive IN(1, 0)),      
        CONSTRAINT a2prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)
);

CREATE TABLE a2advisors (

    empID       NUMBER(5, 0),
    isActive    NUMBER(1, 0) DEFAULT 1,

        CONSTRAINT a2advisors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2advisors_isActive_chk CHECK(isActive IN(1, 0)),  
        CONSTRAINT a2advisors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID)

);

CREATE TABLE a2professors (

    empID       NUMBER(5, 0),
    deptCode    NUMBER(3, 0),
    isActive    NUMBER(1, 0),
    
        CONSTRAINT a2professors_isActive_chk CHECK(isActive IN(1, 0)),
        CONSTRAINT a2professors_empID_pk PRIMARY KEY(empID),
        CONSTRAINT a2professors_empID_fk FOREIGN KEY(empID)
            REFERENCES a2employees(empID),
        CONSTRAINT a2professors_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode)
            
);

CREATE TABLE a2sections (

    sectionID       NUMBER(4),
    sectionLetter   CHAR(3),
    courseCode      NUMBER(5, 0),
    termCode        NUMBER(4, 0),
    profID          NUMBER(5, 0),
    
        CONSTRAINT a2sections_courseCode_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2sections_termCode_fk FOREIGN KEY(termCode)
            REFERENCES a2term(termCode),
        CONSTRAINT a2sections_profID_fk FOREIGN KEY(profID)
            REFERENCES a2professors(empID)
);
