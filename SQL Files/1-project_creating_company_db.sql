-- ================================================================
-- Database Creation and Table Setup Script for 'Company' Database
-- ================================================================

-- Switch to the master database
USE master;


-- ================================================================
-- Drop the 'Company' database if it already exists
-- ================================================================
DROP DATABASE IF EXISTS company_project;


-- ================================================================
-- Create a fresh 'Company' database
-- ================================================================
CREATE DATABASE company_project;


-- Switch context to the newly created database
USE company_project;


-- ================================================================
-- Create Table: department
-- ================================================================
CREATE TABLE department (
    dname         VARCHAR(50),
    dnumber       INT,
    mgrssn        CHAR(9),
    mgrstartdate  DATE
);

ALTER TABLE department
ADD CONSTRAINT DEPARTMENT_PK PRIMARY KEY (dnumber);
-- ================================================================
-- Create Table: employee
-- ================================================================
CREATE TABLE employee (
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
ALTER TABLE employee ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE employee
DROP id ;

-- ================================================================
-- Create Table: project
-- ================================================================
CREATE TABLE project (
    pname      VARCHAR(100),
    pnumber    INT,
    plocation  VARCHAR(100),
    dnum       INT
);

ALTER TABLE project ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- ================================================================
-- Create Table: works_on
-- Represents the many-to-many relationship between employees and projects
-- ================================================================
CREATE TABLE works_on (
    essn    CHAR(9),
    pno     INT,
    w_hours   INT
);

