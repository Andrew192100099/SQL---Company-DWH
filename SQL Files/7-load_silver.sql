use SILVER_layer;

-- =====================================================
-- 1. SILVER_layer → Clean department
-- =====================================================

DROP procedure IF exists LOAD_DEPARTMENT_SILVER_layer;

DELIMITER //
CREATE PROCEDURE LOAD_DEPARTMENT_SILVER_layer ()
BEGIN
    TRUNCATE TABLE SILVER_layer.Clean_department;
    INSERT INTO SILVER_layer.Clean_department (dname, dnumber, mgrssn, mgrstartdate)
    SELECT
        dname,
        dnumber,
        mgrssn,
        mgrstartdate  
    FROM BRONZE_layer.department;
END //
DELIMITER ;

CALL LOAD_DEPARTMENT_SILVER_layer;
  



-- =====================================================
-- 2. SILVER_layer → Clean employee
-- =====================================================

DROP procedure IF exists LOAD_EMPLOYEE_SILVER_layer;

delimiter //
CREATE procedure LOAD_EMPLOYEE_SILVER_layer ()
BEGIN
	TRUNCATE TABLE SILVER_layer.Clean_employee;
	INSERT INTO SILVER_layer.Clean_employee (fname,lname,ssn,bdate,e_address,gender,salary,superssn,dno)
	SELECT
		fname,
		lname,
		ssn,
		bdate,
		e_address,
		gender,
		salary,
		superssn,
		dno
	FROM BRONZE_layer.employee;
END //
delimiter ; 

CALL LOAD_EMPLOYEE_SILVER_layer;

-- =====================================================
-- 3. SILVER_layer → Clean project
-- =====================================================
  
DROP procedure IF exists LOAD_PROJECT_SILVER_layer;

delimiter //
CREATE procedure LOAD_PROJECT_SILVER_layer ()
BEGIN
	TRUNCATE TABLE SILVER_layer.Clean_project;
	INSERT INTO SILVER_layer.Clean_project ( pname, pnumber, plocation, dnum )
	SELECT
		pname, 
        pnumber, 
        plocation, 
        dnum
	FROM BRONZE_layer.project;
END //
delimiter ; 

CALL LOAD_PROJECT_SILVER_layer;

-- =====================================================
-- 4. SILVER_layer → Clean works_on
-- =====================================================
  
DROP procedure IF exists LOAD_WORKS_ON_SILVER_layer;

delimiter //
CREATE procedure LOAD_WORKS_ON_SILVER_layer ()
BEGIN
	TRUNCATE TABLE SILVER_layer.Clean_works_on;
	INSERT INTO SILVER_layer.Clean_works_on ( essn, pno, w_hours )
	SELECT
		essn, 
        pno, 
        w_hours
	FROM BRONZE_layer.works_on;
END //
delimiter ; 

CALL LOAD_WORKS_ON_SILVER_layer;
  
  
  
  
SELECT*
FROM SILVER_layer.employee;

SELECT*
FROM SILVER_layer.department;

SELECT*
FROM SILVER_layer.project;

SELECT*
FROM SILVER_layer.works_on;