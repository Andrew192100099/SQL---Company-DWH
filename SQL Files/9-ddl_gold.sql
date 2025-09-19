USE DWH;

-- 										   ==========================
-- 										|| Data Mart (Star Schema ✨) ||
--  						 			   ==========================

--   ===========================================================
-- | IF OBJECT_ID ('GOLD_layer.dim_department', 'U') IS NOT NULL |
-- | BEGIN														 |		 ===============================================
-- |  DROP TABLE GOLD_layer.dim_department						 | 	=  | DROP TABLE IF EXISTS GOLD_layer.dim_department |
-- | END													     |	     ===============================================
--  ============================================================
--   ---------------------------------------
-- | Create The dimension table → departments|
--   ---------------------------------------
DROP TABLE IF EXISTS GOLD_layer.dim_department;
CREATE TABLE GOLD_layer.dim_department (
    department_key INT,
    department_number INT,
    department_name VARCHAR(50),
    department_manager_ssn VARCHAR(9),
    department_manager_name VARCHAR(30),
    dpartment_manager_startdate DATE,
    
    CONSTRAINT GOLD_DIM_DEPARTMENT_PK PRIMARY KEY (department_key)
);

--   ------------------------------------
-- | Create The dimension table → employee|
--   ------------------------------------
DROP TABLE IF EXISTS GOLD_layer.dim_employee;
CREATE TABLE GOLD_layer.dim_employee (
    employee_key INT,
    employee_ssn VARCHAR(9),
    employee_name VARCHAR(60),
    employee_age INT,
    employee_address VARCHAR(255),
    employee_gender CHAR(10),
    employee_salary DECIMAL(10,2),
    employee_dept_number INT,
    employee_supersn VARCHAR(9),
    
    CONSTRAINT GOLD_DIM_EMPLOYEE_PK PRIMARY KEY (employee_key)
);

--   ------------------------------------
-- | Create The dimension table → projects|
--   ------------------------------------
DROP TABLE IF EXISTS GOLD_layer.dim_project;
CREATE TABLE GOLD_layer.dim_project (
    project_key INT ,
    project_number INT,
    project_name VARCHAR(100),
    project_location VARCHAR(100),
    project_dept_number INT,
    
    CONSTRAINT GOLD_DIM_PROJECT_PK PRIMARY KEY (project_key)
);

--   --------------------------------
-- | Create fact table → work records |
--   --------------------------------
DROP TABLE IF EXISTS GOLD_layer.fact_work;
CREATE TABLE GOLD_layer.fact_work (
    department_key INT,
    project_key INT,
    employee_key INT,
    work_hours INT,
    
    CONSTRAINT FACT_WORK_DEPARTMENT_FK FOREIGN KEY (department_key) 
	REFERENCES GOLD_layer.dim_department(department_key),
        
    CONSTRAINT FACT_WORK_PROJECT_FK FOREIGN KEY (project_key) 
	REFERENCES GOLD_layer.dim_project(project_key),
        
    CONSTRAINT FACT_WORK_EMPLOYEE_FK FOREIGN KEY (employee_key) 
	REFERENCES GOLD_layer.dim_employee(employee_key)
);

--   -----------------------------
-- | Switch FOREIGN KEY→ ON & OFF |
--   -----------------------------
 SET FOREIGN_KEY_CHECKS = 0;    
-- SET FOREIGN_KEY_CHECKS = 1;

--   ---------------------------------
-- | Switch SQL_SAFE_UPDATES→ ON & OFF |
--   ---------------------------------
-- SET SQL_SAFE_UPDATES = 0;
-- SET SQL_SAFE_UPDATES = 1;

