USE BRONZE_LAYER;

DROP procedure LOAD_BRONZE_LAYER;


delimiter //
CREATE procedure LOAD_BRONZE_LAYER ()
BEGIN

drop table BRONZE_LAYER.department;
CREATE TABLE BRONZE_LAYER.department AS
SELECT *
FROM company_project.department;

drop table BRONZE_LAYER.employee;
CREATE TABLE BRONZE_LAYER.employee AS
SELECT *
FROM company_project.employee;

drop table BRONZE_LAYER.project;
CREATE TABLE BRONZE_LAYER.project AS
SELECT *
FROM company_project.project;

drop table BRONZE_LAYER.works_on;
CREATE TABLE BRONZE_LAYER.works_on AS
SELECT *
FROM company_project.works_on;

END //
delimiter ; 

CALL LOAD_BRONZE_LAYER;

SELECT *
FROM BRONZE_LAYER.employee;

SELECT *
FROM BRONZE_LAYER.department;

SELECT *
FROM BRONZE_LAYER.project;

SELECT *
FROM BRONZE_LAYER.works_on;

SELECT *
FROM employee;

