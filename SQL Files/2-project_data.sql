-- ================================================================
-- Populate Data for Company Database with Data Cleaning Issues
-- ================================================================

-- Use the created database
USE company_project;


-- ================================================================
-- Insert Data into DEPARTMENT
-- Introduce inconsistencies (e.g., mixed case in dname, varying date formats)
-- Introduce missing values (e.g., NULL in mgrstartdate for some records)
-- Use realistic department names and start dates
-- ================================================================
DELETE FROM department;


INSERT INTO department (dname, dnumber, mgrssn, mgrstartdate)
VALUES 
    ('Human Resources', 1, NULL, '2020-01-15'),          
    ('Information Technology', 2, NULL, '2019-07-10'),  
    ('finance',         3, NULL, '2021-03-01'),           -- Inconsistent case
    ('Marketing',       4, NULL, NULL),                   -- Missing mgrstartdate
    ('Operations',      5, NULL, '2023-02-15'),
    ('Sales',           6, NULL, '2021-09-20'),
    ('Research & Development', 7, NULL, '2020-11-01'),
    ('Legal',           8, NULL, '2022/01/10'),
    ('Customer Support', 9, NULL, '2023-05-15'),
    ('Engineering',    10, NULL, '2019-12-01'),           
    ('Logistics',      11, NULL, '2021-07-01'),
    ('Procurement',    12, NULL, NULL),                   -- Missing mgrstartdate
    ('Quality Assurance', 13, NULL, '2020-08-20'),
    ('Training',       14, NULL, '2023-01-10'),
    ('Facilities Management', 15, NULL, '2021-11-01'),
    ('Security',       16, NULL, '2022-09-15'),
    ('Data Analytics', 17, NULL, '2020-06-01'),
    ('Compliance',     18, NULL, '2023-04-01'),
    ('Software Development', 19, NULL, '2021-02-15'),
    ('Technical Support', 20, NULL, '2022-07-01');

SELECT *
FROM department;
-- ================================================================
-- Insert Data into EMPLOYEE
-- Introduce duplicates (e.g., duplicate Michael Johnson)
-- Introduce missing values (e.g., NULL in salary, address, bdate)
-- Introduce outliers (e.g., extreme salary, invalid bdate)
-- Introduce noisy data (e.g., invalid gender values)
-- Ensure dno reflects the department the employee works for
-- Use realistic names, salaries, and addresses
-- ================================================================
DELETE FROM employee;


INSERT INTO employee (fname, lname, ssn, bdate, e_address, gender, salary, superssn, dno)
VALUES 
    -- Managers (dno matches the department they manage)
    ('Jennifer', 'Martinez', '123456789', '1978-05-12', '1234 Peachtree St, Atlanta, GA', 'F', 85000.00, NULL,  1),   -- Human Resources Manager
    ('Robert',   'Patel',    '987654321', '1982-08-22', '456 Oakwood Dr, Boston, MA',   'M', 500.00,   NULL,  2),   -- IT Manager, outlier: low salary
    ('Elizabeth','Thompson', '555443333', '1980-03-10', '789 Elm St, Chicago, IL',      'F', 90000.00, NULL,  3),   -- Finance Manager
    ('William',  'Nguyen',   '111223344', '1975-09-15', NULL,                          'M', 87000.00, NULL,  4),   -- Marketing Manager, missing address
    ('David',    'Garcia',   '222334455', '1983-12-05', '202 Maple Ave, Seattle, WA',   'M', 82000.00, NULL,  5),   -- Operations Manager
    ('Susan',    'Kim',      '333445566', '1981-02-20', '303 Cedar Rd, Miami, FL',      'F', 83000.00, NULL,  6),   -- Sales Manager
    ('Thomas',   'Wong',     '444556677', '1979-06-15', '404 Birch Ln, Austin, TX',     NULL, 88000.00, NULL,  7),   -- R&D Manager, missing gender
    ('Margaret','Chen',      '555667788', '1984-11-10', '505 Spruce Dr, Denver, CO',    'F', 86000.00, NULL,  8),   -- Legal Manager
    ('James',    'Rodriguez','666778899', '1986-04-18', '606 Pine St, Phoenix, AZ',     'M', 84000.00, NULL,  9),   -- Customer Support Manager
    ('Emily',    'Singh',    '777889900', '1988-07-22', '707 Walnut Ave, Houston, TX',  'X', 89000.00, NULL, 10),   -- Engineering Manager, noisy: invalid gender
    ('Michael',  'Johnson',  '888990011', '1990-11-30', '808 Chestnut Dr, Dallas, TX',  'M', 81000.00, NULL, 11),   -- Logistics Manager
    ('Patricia','Lee',       '999001122', '1985-03-25', '909 Magnolia Blvd, Orlando, FL','F', NULL,      NULL, 12),   -- Procurement Manager, missing salary
    ('Steven',   'Davis',    '101112233', '1987-07-15', '1010 Laurel St, Portland, OR', 'M', 85000.00, NULL, 13),   -- Quality Assurance Manager
    ('Linda',    'Brown',    '112223344', '1989-09-10', '1111 Cedar Ave, San Diego, CA','F', 86000.00, NULL, 14),   -- Training Manager
    ('Charles',  'Wilson',   '123334455', '1986-04-20', '1212 Oak St, Las Vegas, NV',   'M', 83000.00, NULL, 15),   -- Facilities Manager
    ('Karen',    'Taylor',   '134445566', '1990-02-15', '1313 Maple Dr, Charlotte, NC', 'F', 84000.00, NULL, 16),   -- Security Manager
    ('Daniel',   'Moore',    '145556677', '1988-08-25', '1414 Elm Rd, Minneapolis, MN', 'M', 87000.00, NULL, 17),   -- Data Analytics Manager
    ('Nancy',    'Clark',    '156667788', '1985-12-30', '1515 Pine Ave, Los Angeles, CA','F', 88000.00, NULL, 18),   -- Compliance Manager
    ('Andrew',   'Lewis',    '167778899', '1987-03-05', '1616 Birch St, New York, NY',  'M', 86000.00, NULL, 19),   -- Software Development Manager
    ('Jessica',  'Walker',   '178889900', '1991-06-10', '1717 Spruce Dr, Remote',       'F', 85000.00, NULL, 20),   -- Technical Support Manager
    -- Non-manager employees
    ('Michael',  'Johnson',  '189990011', '1992-04-18', '1818 Elm St, Atlanta, GA',     'M', 55000.00, '123456789', 1),   -- HR Employee, duplicate name
    ('Sarah',    'Khan',     '190001122', '1993-06-10',         '1919 Pine Ave, Boston, MA',    'F', 52000.00, '987654321', 2),   -- IT Employee, missing bdate
    ('Christopher','Lopez',  '201112233', '1987-11-25', '2020 Oak Dr, Chicago, IL',     'M', 53000.00, '555443333', 3),   -- Finance Employee
    ('Amanda',   'Gupta',    '212223344', '1993-01-25', '2121 Maple St, Seattle, WA',   'F', 54000.00, '111223344', 4),   -- Marketing Employee
    ('Matthew',  'Hernandez','223334455', '2026-06-10', '2222 Birch Ln, Miami, FL',     'M', 51000.00, '222334455', 5);   -- Operations Employee, outlier: future bdate

SELECT *
FROM employee;
-- ================================================================
-- Insert Data into PROJECT
-- Introduce duplicates (e.g., duplicate Cloud Migration)
-- Introduce missing values (e.g., NULL in plocation)
-- Introduce inconsistencies (e.g., invalid dnum)
-- Use realistic project names and locations
-- ================================================================
DELETE FROM project;
TRUNCATE TABLE project;

INSERT INTO project (pname, pnumber, plocation, dnum)
VALUES 
    ('Cloud Migration',     101, 'New York, NY',    2),   -- IT project
    ('Cloud Migration',     101, 'New York, NY',    2),   -- Duplicate project
    ('ERP Implementation',  102, NULL,              2),   -- Missing plocation
    ('Financial Audit',     103, 'Chicago, IL',      3),   -- Finance project
    ('Marketing Campaign',  104, 'Remote',           4),   -- Marketing project
    ('Supply Chain Opt',    105, 'Seattle, WA',      5),   -- Operations project
    ('CRM Upgrade',         106, 'Miami, FL',        6),   -- Sales project
    ('AI Research',         107, 'Austin, TX',       7),   -- R&D project
    ('Contract Review',     108, 'Denver, CO',       8),   -- Legal project
    ('Support Portal',      109, 'Phoenix, AZ',      9),   -- Customer Support project
    ('Product Development', 110, 'Houston, TX',     10),   -- Engineering project
    ('Inventory System',    111, 'Dallas, TX',      11),   -- Logistics project
    ('Vendor Sync',         112, 'Orlando, FL',     12),   -- Procurement project
    ('QA Automation',       113, 'Portland, OR',    13),   -- Quality Assurance project
    ('Training Platform',   114, 'San Diego, CA',   14),   -- Training project
    ('Facility Upgrade',    115, 'Las Vegas, NV',   15),   -- Facilities project
    ('Security Audit',      116, 'Charlotte, NC',   16),   -- Security project
    ('Data Pipeline',       117, 'Minneapolis, MN', 17),   -- Data Analytics project
    ('Compliance Review',   118, 'Los Angeles, CA', 18),   -- Compliance project
    ('App Development',     119, 'New York, NY',    19),   -- Software Development project
    ('Tech Support System', 120, 'Remote',          20),   -- Technical Support project
    ('Blockchain Pilot',    121, 'Boston, MA',      99);  -- Inconsistent: invalid dnum
    
SELECT *
FROM project;


-- ================================================================
-- Insert Data into WORKS_ON
-- Introduce outliers (e.g., negative or excessive hours)
-- Introduce missing values (e.g., NULL in hours)
-- Introduce noisy data (e.g., invalid pno)
-- Use realistic hours and project assignments
-- ================================================================
DELETE FROM works_on;


INSERT INTO works_on (essn, pno, w_hours)
VALUES 
    ('123456789', 101, 35.5),  -- HR Manager on Cloud Migration
    ('987654321', 102, -5.0),  -- IT Manager on ERP Implementation, outlier: negative hours
    ('555443333', 103, 38.0),  -- Finance Manager on Financial Audit
    ('111223344', 104, NULL),  -- Marketing Manager on Marketing Campaign, missing hours
    ('222334455', 105, 40.0),  -- Operations Manager on Supply Chain Opt
    ('333445566', 106, 36.0),  -- Sales Manager on CRM Upgrade
    ('444556677', 107, 39.0),  -- R&D Manager on AI Research
    ('555667788', 108, 35.0),  -- Legal Manager on Contract Review
    ('666778899', 109, 38.5),  -- Customer Support Manager on Support Portal
    ('777889900', 110, 100.0), -- Engineering Manager on Product Development, outlier: excessive hours
    ('888990011', 111, 36.5),  -- Logistics Manager on Inventory System
    ('999001122', 112, 35.0),  -- Procurement Manager on Vendor Sync
    ('101112233', 113, 38.0),  -- Quality Assurance Manager on QA Automation
    ('112223344', 114, 37.5),  -- Training Manager on Training Platform
    ('123334455', 115, 36.0),  -- Facilities Manager on Facility Upgrade
    ('134445566', 116, 39.0),  -- Security Manager on Security Audit
    ('145556677', 117, 35.5),  -- Data Analytics Manager on Data Pipeline
    ('156667788', 118, 38.0),  -- Compliance Manager on Compliance Review
    ('167778899', 119, 37.0),  -- Software Development Manager on App Development
    ('178889900', 120, 35.0),  -- Technical Support Manager on Tech Support System
    ('189990011', 101, 25.0),  -- HR Employee on Cloud Migration
    ('190001122', 999, 22.0),  -- IT Employee on invalid project, noisy: invalid pno
    ('201112233', 103, 24.0),  -- Finance Employee on Financial Audit
    ('212223344', 104, 23.0),  -- Marketing Employee on Marketing Campaign
    ('223334455', 105, 21.0);  -- Operations Employee on Supply Chain Opt

SELECT *
FROM works_on;
-- ================================================================
-- Update DEPARTMENT with Manager SSNs
-- Assign realistic manager SSNs to departments
-- ================================================================
UPDATE department SET mgrssn = '123456789' WHERE dnumber = 1;  # Human Resources
UPDATE department SET mgrssn = '987654321' WHERE dnumber = 2;  # Information Technology
UPDATE department SET mgrssn = '555443333' WHERE dnumber = 3;  # Finance
UPDATE department SET mgrssn = '111223344' WHERE dnumber = 4;  # Marketing
UPDATE department SET mgrssn = '222334455' WHERE dnumber = 5;  # Operations
UPDATE department SET mgrssn = '333445566' WHERE dnumber = 6;  # Sales
UPDATE department SET mgrssn = '444556677' WHERE dnumber = 7;  # Research & Development
UPDATE department SET mgrssn = '555667788' WHERE dnumber = 8;  # Legal
UPDATE department SET mgrssn = '666778899' WHERE dnumber = 9;  # Customer Support
UPDATE department SET mgrssn = '777889900' WHERE dnumber = 10; # Engineering
UPDATE department SET mgrssn = '888990011' WHERE dnumber = 11; # Logistics
UPDATE department SET mgrssn = '999001122' WHERE dnumber = 12; # Procurement
UPDATE department SET mgrssn = '101112233' WHERE dnumber = 13; # Quality Assurance
UPDATE department SET mgrssn = '112223344' WHERE dnumber = 14; # Training
UPDATE department SET mgrssn = '123334455' WHERE dnumber = 15; # Facilities Management
UPDATE department SET mgrssn = '134445566' WHERE dnumber = 16; # Security
UPDATE department SET mgrssn = '145556677' WHERE dnumber = 17; # Data Analytics
UPDATE department SET mgrssn = '156667788' WHERE dnumber = 18; # Compliance
UPDATE department SET mgrssn = '167778899' WHERE dnumber = 19; # Software Development
UPDATE department SET mgrssn = '178889900' WHERE dnumber = 20; # Technical Support

SELECT *
FROM department;