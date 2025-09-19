USE DWH;

--   --------------------------------------
-- | Create Clean department Table [Silver] |
--   --------------------------------------
DROP TABLE SILVER_LAYER.Clean_department;
CREATE TABLE SILVER_LAYER.Clean_department (
    dname         VARCHAR(50),
    dnumber       INT,
    mgrssn        CHAR(9),
    mgrstartdate  DATE
);

--   ------------------------------------
-- | Create Clean employee Table [Silver] |
--   ------------------------------------
DROP TABLE SILVER_LAYER.Clean_employee;
CREATE TABLE SILVER_LAYER.Clean_employee (
    fname     VARCHAR(30),
    lname     VARCHAR(30),
    ssn       CHAR(9),
    bdate     DATE,
    e_address   VARCHAR(255),
    gender       CHAR(1),
    salary    DECIMAL(10,2),
    superssn  CHAR(9),
    dno       INT       
);

--   -----------------------------------
-- | Create Clean project Table [Silver] |
--   -----------------------------------
DROP TABLE SILVER_LAYER.Clean_project;
CREATE TABLE SILVER_LAYER.Clean_project (
    pname      VARCHAR(100),
    pnumber    INT,
    plocation  VARCHAR(100),
    dnum       INT
);

--   ------------------------------------
-- | Create Clean works on Table [Silver] |
--   ------------------------------------
DROP TABLE SILVER_LAYER.Clean_works_on;
CREATE TABLE SILVER_LAYER.Clean_works_on (
    essn    CHAR(9),
    pno     INT,
    w_hours   INT
);