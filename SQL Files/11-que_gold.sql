USE GOLD_LAYER;

-- 1. List all employees in the Engineering department (dno=10) sorted by salary
SELECT
    employee_name,
    CONCAT(FORMAT(employee_salary,0), 'LE') AS employee_salary,
    employee_dept_number
FROM dim_employee
WHERE employee_dept_number = 10
ORDER BY employee_salary DESC;

-- 2. Show the top 5 most common employee addresses (excluding NULL) and their employee counts
SELECT
    employee_address,
    COUNT(*) as employee_count
FROM dim_employee
WHERE employee_address IS NOT NULL AND employee_address != ''
GROUP BY employee_address
ORDER BY employee_count DESC
LIMIT 5;

-- 3. Find all managers whose first name starts with 'J' and last name contains 'e'
SELECT
    department_manager_name as manager_name,
    department_name
FROM dim_department
WHERE department_manager_name LIKE 'J%' AND department_manager_name LIKE '%e%';

-- 4. List employees without a department assignment OR without a supervisor
SELECT
    employee_name,
    CONCAT(FORMAT(employee_salary,0), 'LE') AS employee_salary, 
    employee_supersn
FROM dim_employee
WHERE employee_dept_number IS NULL OR employee_supersn IS NULL;

-- 5. Display all departments with their manager names, showing "No Manager" for departments without managers
SELECT
    department_name,
    COALESCE(department_manager_name, 'No Manager') as manager_name
FROM dim_department;

-- 6. Find employees earning between $40,000-$60,000 who are not in HR (dno=1), IT (dno=2), or Finance (dno=3)
SELECT
    employee_name,
    CONCAT(FORMAT(employee_salary,0), 'LE') AS employee_salary,
    employee_dept_number
FROM dim_employee
WHERE employee_salary BETWEEN 40000 AND 60000
  AND employee_dept_number NOT IN (1, 2, 3)
ORDER BY employee_salary DESC;

-- 7. Show average salary by gender per department including department name
SELECT
    d.department_name,
    e.employee_gender,
    CONCAT(FORMAT(AVG(e.employee_salary),0), 'LE') AS avg_salary
FROM dim_employee e
JOIN dim_department d ON e.employee_dept_number = d.department_number
GROUP BY d.department_name, e.employee_gender
ORDER BY avg_salary DESC;

-- 8. List departments with more than 1 employee AND average salary > $50,000
SELECT
    d.department_name,
    COUNT(e.employee_ssn) as employee_count,
    CONCAT(FORMAT(AVG(e.employee_salary),0), 'LE') AS avg_salary
FROM dim_department d
JOIN dim_employee e ON d.department_number = e.employee_dept_number
GROUP BY d.department_name
HAVING COUNT(e.employee_ssn) > 1 AND AVG(e.employee_salary) > 50000
ORDER BY avg_salary DESC;

SELECT *
FROM GOLD_layer.dim_employee;
-- 9. Calculate total work hours per project location, showing only locations with >30 total hours
SELECT
    p.project_location,
    SUM(f.work_hours) as total_hours
FROM fact_work f
JOIN dim_project p ON f.project_key = p.project_key
GROUP BY p.project_location
HAVING SUM(f.work_hours) > 30
ORDER BY total_hours DESC;

-- 10. List all projects with their department names and responsible manager names
SELECT
    p.project_name,
    d.department_name,
    d.department_manager_name
FROM dim_project p
LEFT JOIN dim_department d ON p.project_dept_number = d.department_number;

-- 11. Show all employees and their project names (include employees without projects)
SELECT
    e.employee_name,
    COALESCE(p.project_name, 'No Project') as project_name
FROM dim_employee e
LEFT JOIN fact_work f ON e.employee_key = f.employee_key
LEFT JOIN dim_project p ON f.project_key = p.project_key
GROUP BY e.employee_name, p.project_name;

-- 12. Display all departments and all projects, highlighting departments with no projects and projects with no departments
SELECT
    COALESCE(d.department_name, 'No Department') as department_name,
    COALESCE(p.project_name, 'No Project') as project_name
FROM dim_department d
LEFT JOIN dim_project p ON d.department_number = p.project_dept_number

UNION

SELECT
    COALESCE(d.department_name, 'No Department') as department_name,
    COALESCE(p.project_name, 'No Project') as project_name
FROM dim_department d
RIGHT JOIN dim_project P ON d.department_number = p.project_dept_number
ORDER BY department_name, project_name;

-- 13. Find employees who work on projects and employees with no project assignments
-- Employees with projects
SELECT employee_name 
FROM dim_employee e
WHERE EXISTS (
    SELECT 1 FROM fact_work f WHERE f.employee_key = e.employee_key
);

-- Employees without projects
SELECT employee_name 
FROM dim_employee e
WHERE NOT EXISTS (
    SELECT 1 FROM fact_work f WHERE f.employee_key = e.employee_key
);

-- 14. List employees earning more than all employees in the Customer Service department (dno=9)
SELECT
    employee_name,
    employee_salary
FROM dim_employee
WHERE employee_salary > ALL (
    SELECT employee_salary 
    FROM dim_employee 
    WHERE employee_dept_number = 9
)
ORDER BY employee_salary DESC;

-- 15. Show employees earning above their department's average salary
SELECT
    e.employee_name,
    d.department_name,
    e.employee_salary,
    e.employee_salary - dept_avg.avg_salary as salary_difference
FROM dim_employee e
JOIN dim_department d ON e.employee_dept_number = d.department_number
JOIN (
    SELECT employee_dept_number, AVG(employee_salary) as avg_salary
    FROM dim_employee
    GROUP BY employee_dept_number
) dept_avg ON e.employee_dept_number = dept_avg.employee_dept_number
WHERE e.employee_salary > dept_avg.avg_salary
ORDER BY salary_difference DESC;

-- 17. Generate a report showing Project Name, Department, Total Hours Worked, and % of Department's Total Hours
SELECT
    p.project_name,
    d.department_name,
    SUM(f.work_hours) as total_hours,
    (SUM(f.work_hours) / dept_total.total_dept_hours) * 100 as percent_of_dept_hours
FROM fact_work f
JOIN dim_project p ON f.project_key = p.project_key
JOIN dim_department d ON f.department_key = d.department_key
JOIN (
    SELECT p.project_dept_number, SUM(f.work_hours) as total_dept_hours
    FROM fact_work f
    JOIN dim_project p ON f.project_key = p.project_key
    GROUP BY p.project_dept_number
) dept_total ON p.project_dept_number = dept_total.project_dept_number
GROUP BY p.project_name, d.department_name, dept_total.total_dept_hours
ORDER BY p.project_name;

--   ---------------------------------------------------
-- | Another SOLUTION: Using Partition in Window Function|
--   ---------------------------------------------------
SELECT
    ROW_NUMBER() OVER (ORDER BY p.project_number) AS Count_Number,
    p.project_number AS Project_Number,
    p.project_name AS Project_Name,
    d.department_number AS Department_Number,
    d.department_name AS Department_Name,
    SUM(f.work_hours) OVER (PARTITION BY p.project_key) AS Project_TOTAL_HOURS,
    SUM(f.work_hours) OVER (PARTITION BY p.project_dept_number) AS Department_TOTAL_HOURS,
    
    (SUM(f.work_hours) OVER (PARTITION BY p.project_key) / 
     SUM(f.work_hours) OVER (PARTITION BY p.project_dept_number)) * 100 AS PERCENTAGE_OF_DEPARTMENT_TOTAL_HOURS
FROM GOLD_LAYER.fact_work f
JOIN dim_project p ON f.project_key = p.project_key
JOIN dim_department d ON p.project_dept_number = d.department_number
ORDER BY p.project_number;

-- 18. Identify employees in non-existent departments and projects assigned to non-existent departments
-- a) Employees in non-existent departments
SELECT
    employee_name,
    employee_dept_number
FROM dim_employee
WHERE employee_dept_number NOT IN (SELECT department_number FROM dim_department);

-- b) Projects assigned to non-existent departments
SELECT
    project_name,
    project_dept_number
FROM dim_project
WHERE project_dept_number NOT IN (SELECT department_number FROM dim_department);

-- 19. Calculate department efficiency scores: (Total Project Hours / Total Salary Cost) × 100
SELECT
    d.department_name,
    (COALESCE(SUM(f.work_hours), 0) / COALESCE(SUM(e.employee_salary), 1)) * 100 as efficiency_score
FROM dim_department d
LEFT JOIN dim_employee e ON d.department_Key = e.employee_dept_number
LEFT JOIN fact_work f ON e.employee_key = f.employee_key
GROUP BY d.department_name
ORDER BY efficiency_score DESC
LIMIT 3;
-- ========================================================================================
-- ========================================================================================

-- 		 ------------
-- 		|			 |
-- 		| Better Way |
-- 		|			 |
-- 		 ------------

SELECT department_key, SUM(work_hours) OVER(partition by department_key) AS TOTAL_PROJECT_HOURS,
SUM(E.employee_salary) OVER(partition by department_key) AS TOTAL_SALARIES_EACH_DEPARTMENT,


SUM(work_hours) OVER(partition by department_key) /
SUM(E.employee_salary) OVER(partition by department_key) * 100

FROM fact_work F
LEFT JOIN dim_employee E ON  E.employee_key = F.employee_key