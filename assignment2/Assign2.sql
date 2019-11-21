DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE term CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE coutries CASCADE CONSTRAINTS;

CREATE TABLE a2departments (
    deptCode NUMBER(4) GENERATED AS IDENTITY CONSTRAINT deptCode_pk PRIMARY KEY,
    deptName VARCHAR2(30) CONSTRAINT department_name_nn NOT NULL,
    OfficeNumber NUMBER(4) CONSTRAINT OfficeNumber_nn NOT NULL,
    DisplayOrder NUMBER(1, 0)
    
);

CREATE TABLE a2term (
    term_code NUMBER(4) GENERATED AS IDENTITY CONSTRAINT term_code_pk PRIMARY KEY,
    term_name VARCHAR2(15) CONSTRAINT term_name_nn NOT NULL,
    start_date DATE DEFAULT sysdate CONSTRAINT start_date_nn NOT NULL,
    end_date DATE
);

CREATE TABLE a2employees (

    empID NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT emp_ID_pk PRIMARY KEY,
    FirstName VARCHAR2(25) CONSTRAINT FirstName_nn NOT NULL,
    LastName VARCHAR2(25) CONSTRAINT LastName_nn NOT NULL,
    Prefix VARCHAR(5),
    Suffix VARCHAR(5),
    isActive NUMBER(1, 0) DEFAULT 1 NOT NULL,
    SIN NUMBER(9, 0) CONSTRAINT SIN_nn NOT NULL 
        CONSTRAINT SIN_uk UNIQUE,
    DOB DATE,
    email VARCHAR2(25) CONSTRAINT email_nn NOT NULL 
        CONSTRAINT email_uk UNIQUE,
    phone VARCHAR2(12) CONSTRAINT phone_nn NOT NULL 
        CONSTRAINT phone_uk UNIQUE

);


CREATE TABLE a2continents (

    ContinentID NUMBER(1, 0) GENERATED AS IDENTITY CONSTRAINT ContinentCode_pk PRIMARY KEY,
    name VARCHAR(13) CONSTRAINT Continent_nn NOT NULL
        CONSTRAINT name_nn UNIQUE

);

CREATE TABLE a2countries (

    CountryCode NUMBER(3, 0) GENERATED AS IDENTITY CONSTRAINT CountryCode_pk PRIMARY KEY,
    CountryName VARCHAR2(56) CONSTRAINT CountryName_nn NOT NULL
        CONSTRAINT CountryName_uk UNIQUE,
    ContinentID NUMBER(1, 0) CONSTRAINT ContinentID_nn NOT NULL,
    IsActive NUMBER(1, 0) DEFAULT 1 CONSTRAINT IsActive_nn NOT NULL
        CONSTRAINT IsActive_ck CHECK(IsActive IN(1, 0)),
        
        CONSTRAINT ContinentID_fk FOREIGN KEY(ContinentID)
            REFERENCES a2continents(ContinentID)
);

CREATE TABLE a2courses (

    courseCode NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT CourseCode_pk PRIMARY KEY,
    CourseName VARCHAR(30) CONSTRAINT CourseName_nn NOT NULL,
    isAvailable NUMBER(1, 0) DEFAULT 1 CONSTRAINT isAvailable_nn NOT NULL
        CONSTRAINT isAvailable_ck CHECK(isAvaiable IN(1, 0)),
    desc VARCHAR2(38)
    
);

DROP TABLE a2programs CASCADE CONSTRAINTS;

CREATE TABLE a2programs (

    progCode NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT a2programs_progCode_pk PRIMARY KEY,
    progName VARCHAR(30) CONSTRAINT a2programs_progName_nn NOT NULL,
    lengthYears NUMBER(1, 0) CONSTRAINT a2programs_lengthYears_nn NOT NULL,
    isCurrent NUMBER(1, 0) CONSTRAINT a2programs_isCurrent_nn NOT NULL,
    deptCode NUMBER(4) CONSTRAINT a2programs_depCode_nn NOT NULL,
        CONSTRAINT a2programs_deptCode_fk FOREIGN KEY(deptCode)
            REFERENCES a2departments(deptCode),
        CONSTRAINT a2programs_isCurrent_ck CHECK(isCurrent IN (0, 1)),
        CONSTRAINT a2programs_lengthYears_ck CHECK(lengthYears > 0)
);


CREATE TABLE a2students (

    studentID NUMBER(5, 0) GENERATED AS IDENTITY CONSTRAINT a2students_studentID_pk PRIMARY KEY,
    FirstName VARCHAR(20) CONSTRAINT a2students_FirstName_nn NOT NULL,
    LastName VARCHAR(25) CONSTRAINT a2students_LastName_nn NOT NULL,
    DOB DATE CONSTRAINT a2students_DOB_nn NOT NULL,
    Gender CHAR(1),
    Email VARCHAR(25) CONSTRAINT a2students_Email_nn NOT NULL,
    HomeCountry NUMBER(3, 0),
    Phone VARCHAR(14),
    advisorID NUMBER(5, 0),
        CONSTRAINT a2students_HomeCountry_fk FOREIGN KEY(HomeCountry)
            REFERENCES a2countries(CountryCode)
);

CREATE TABLE a2jnc_students_courses (

    courseCode NUMBER(5, 0) CONSTRAINT CourseCode_pk PRIMARY KEY,
    studentID NUMBER(5, 0) CONSTRAINT CourseCode_pk PRIMARY KEY,
    isActive NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2jnc_students_courses_isActive_nn NOT NULL
        CONSTRAINT a2jnc_students_courses_isActive_ck CHECK(IsActive IN(1, 0)),
        CONSTRAINT a2jnc_students_courses_fk FOREIGN KEY(courseCode)
            REFERENCES a2courses(courseCode),
        CONSTRAINT a2jnc_students_courses_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)

);

CREATE TABLE a2jnc_prog_courses (

    progCourseID NUMBER(5) GENERATED AS IDENTITY CONSTRAINT a2jnc_prog_courses_progCourseID_pk PRIMARY KEY,
    progCode NUMBER(5, 0) CONSTRAINT a2jnc_prog_courses_progCode_nn NOT NULL,
    courseCode NUMBER(5, 0),
    isActive NUMBER(1, 0) DEFAULT 1 CONSTRAINT a2jnc_prog_courses_isActive_nn NOT NULL

);

CREATE TABLE a2jnc_prog_students (

    progCode    NUMBER(5, 0),
    studentID   NUMBER(5, 0),
    isActive NUMBER(1, 0) DEFAULT 1,
        CONSTRAINT a2jnc_prog_students_isActive_ck CHECK(IsActive IN(1, 0)),      
        CONSTRAINT a2jnc_prog_students_progCode_fk FOREIGN KEY(progCode)
            REFERENCES a2programs(progCode),
        CONSTRAINT a2jnc_prog_students_studentID_fk FOREIGN KEY(studentID)
            REFERENCES a2students(studentID)
);





SELECT length('Education, Community   Social Services')
    FROM dual;


CREATE TABLE locations
    ( location_id    NUMBER(4)
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30)
	CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)
    ) ;
    
    
    CREATE TABLE departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    ) ;