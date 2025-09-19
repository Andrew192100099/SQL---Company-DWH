USE GOLD_LAYER;

-- 		  --------------------------------------------------------
-- 		|			 										  	   |
-- 		| CALL PROCEDURE to all tables together ADDED at the end!  |
-- 		|			 									      	   |
-- 		  --------------------------------------------------------

-- =====================================================
-- 1- Load department dimension table 
-- =====================================================
DROP PROCEDURE IF EXISTS LOAD_DEPARTMENT_GOLD_LAYER;

DELIMITER //
CREATE PROCEDURE LOAD_DEPARTMENT_GOLD_LAYER()
BEGIN
    TRUNCATE TABLE GOLD_LAYER.dim_department;
    
    INSERT INTO GOLD_LAYER.dim_department (
        department_key, department_number, department_name,
        department_manager_ssn, department_manager_name,
        dpartment_manager_startdate
    )
    SELECT
        ROW_NUMBER() OVER(ORDER BY d.dnumber) AS Surrogate_Key,
        d.dnumber,
        d.dname,
        d.mgrssn,
        CONCAT(e.fname, ' ', e.lname) AS department_manager_name,
        d.mgrstartdate  
    FROM SILVER_LAYER.Clean_department d
    LEFT JOIN SILVER_LAYER.Clean_employee e ON d.mgrssn = e.ssn;
END //
DELIMITER ;


CALL LOAD_DEPARTMENT_GOLD_LAYER();

SELECT *
FROM GOLD_LAYER.dim_department;

-- =====================================================
-- 2. Load employee dimension table
-- =====================================================
DROP PROCEDURE IF EXISTS LOAD_EMPLOYEE_GOLD_LAYER;

DELIMITER //
CREATE PROCEDURE LOAD_EMPLOYEE_GOLD_LAYER()
BEGIN
    TRUNCATE TABLE GOLD_LAYER.dim_employee;
    
    INSERT INTO GOLD_LAYER.dim_employee (
        employee_key, employee_ssn, employee_name,
        employee_age, employee_address, employee_gender,
        employee_salary, employee_dept_number, employee_supersn
    )
    SELECT
        ROW_NUMBER() OVER(ORDER BY ssn) AS Surrogate_Key,
        ssn,
        CONCAT(fname, ' ', lname) AS employee_name,
        TIMESTAMPDIFF(YEAR, bdate, CURDATE()) AS employee_age,
        e_address,
        CASE
			WHEN gender = 'M' THEN 'Male'
            ELSE 'Female'
        END AS e_gender,
		salary,
        dno,
        superssn
    FROM SILVER_LAYER.Clean_employee;
END //
DELIMITER ;

CALL LOAD_EMPLOYEE_GOLD_LAYER();

SELECT *
FROM GOLD_LAYER.dim_employee;

-- =====================================================
-- 3. Load project dimension table
-- =====================================================
DROP PROCEDURE IF EXISTS LOAD_PROJECT_GOLD_LAYER;

DELIMITER //
CREATE PROCEDURE LOAD_PROJECT_GOLD_LAYER()
BEGIN
    TRUNCATE TABLE GOLD_LAYER.dim_project;
    
    INSERT INTO GOLD_LAYER.dim_project (
        project_key, project_number, project_name,
        project_location, project_dept_number
    )
    SELECT
        ROW_NUMBER() OVER(ORDER BY pnumber) AS Surrogate_Key,
        pnumber,
        pname,
        plocation,
        dnum
    FROM SILVER_LAYER.Clean_project;
END //
DELIMITER ;

CALL LOAD_PROJECT_GOLD_LAYER();

SELECT *
FROM GOLD_LAYER.dim_project;
-- =====================================================
-- 4. Load work fact table
-- =====================================================
DROP PROCEDURE IF EXISTS LOAD_WORK_FACT_GOLD_LAYER;

DELIMITER //
CREATE PROCEDURE LOAD_WORK_FACT_GOLD_LAYER()
BEGIN
    TRUNCATE TABLE GOLD_LAYER.fact_work;
    
    -- Temporarily disable foreign key checks
    SET FOREIGN_KEY_CHECKS = 0;
    
    INSERT INTO GOLD_LAYER.fact_work (
        department_key, project_key, employee_key, work_hours
    )
    SELECT
        d.department_key,
        p.project_key,
        e.employee_key,
        w.w_hours
    FROM SILVER_LAYER.Clean_works_on w
    JOIN GOLD_LAYER.dim_employee e ON w.essn = e.employee_ssn  
    JOIN GOLD_LAYER.dim_project p ON w.pno = p.project_number  
    JOIN GOLD_LAYER.dim_department d ON e.employee_dept_number = d.department_number;  
    
    -- Re-enable foreign key checks
    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;

CALL LOAD_WORK_FACT_GOLD_LAYER();

SELECT *
FROM GOLD_LAYER.fact_work;
-- =====================================================
-- 5. procedure to load all tables
-- =====================================================
DROP PROCEDURE IF EXISTS LOAD_ALL_GOLD_LAYER;

DELIMITER //
CREATE PROCEDURE LOAD_ALL_GOLD_LAYER()
BEGIN
    -- Load dimension tables first
    CALL LOAD_DEPARTMENT_GOLD_LAYER();
    CALL LOAD_EMPLOYEE_GOLD_LAYER();
    CALL LOAD_PROJECT_GOLD_LAYER();
    
    -- Then load fact table (depends on dimensions)
    CALL LOAD_WORK_FACT_GOLD_LAYER();
END //
DELIMITER ;

-- Temporarily disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;
CALL LOAD_ALL_GOLD_LAYER();
  