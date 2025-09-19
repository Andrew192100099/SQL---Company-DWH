USE SILVER_layer;

-- 		  ------------------
-- 		|			 		 |
-- 		|  Duplicate values  |
-- 		|			 		 |
-- 		  ------------------

-- =====================================================
-- 1. DUPLICATES IN SILVER_layer_employee
-- =====================================================
-- Find duplicate employees → SSN 
SELECT 
    'SSN Duplicates' AS Duplicate_Type,
    ssn,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.employee
WHERE ssn IS NOT NULL
GROUP BY ssn
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- ==================================================================
-- ==================================================================

-- Find duplicate employees → full name + birth date
SELECT 
    'Name + Birth Date Duplicates' AS Duplicate_Type,
    fname,
    lname,
    bdate,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.employee
WHERE fname IS NOT NULL AND lname IS NOT NULL AND bdate IS NOT NULL
GROUP BY fname, lname, bdate
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- ==================================================================
-- ==================================================================

-- Find exact duplicate records (all fields match)
SELECT 
    'Exact Record Duplicates' AS Duplicate_Type,
    fname, lname, ssn, bdate, e_address, gender, 
    CONCAT(FORMAT(salary, 0), ' LE') AS Monthly_Salary, superssn, dno,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.employee
GROUP BY fname, lname, ssn, bdate, e_address, gender, salary, superssn, dno
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- =====================================================
-- 2. DUPLICATES IN SILVER_layer_department
-- =====================================================

-- Find duplicate departments → department number 
SELECT 
    'Department Number Duplicates' AS Duplicate_Type,
    dnumber,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.department
WHERE dnumber IS NOT NULL
GROUP BY dnumber
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- ==================================================================
-- ==================================================================

-- Find duplicate departments → department name
SELECT 
    'Department Name Duplicates' AS Duplicate_Type,
    dname,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.department
WHERE dname IS NOT NULL
GROUP BY dname
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- ==================================================================
-- ==================================================================

-- Find exact duplicate records (all fields match)
SELECT 
    'Exact Record Duplicates' AS Duplicate_Type,
    dname, dnumber, mgrssn, mgrstartdate,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.department
GROUP BY dname, dnumber, mgrssn, mgrstartdate
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- =====================================================
-- 3. DUPLICATES IN SILVER_layer_project
-- =====================================================

-- Find duplicate projects based on project number 		✅✅ There is Duplicate
SELECT 
    'Project Number Duplicates' AS Duplicate_Type,
    pnumber,plocation,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.project
WHERE pnumber IS NOT NULL
GROUP BY pnumber,plocation
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


--   -----------------------------------------------------
-- | SOLUTION:  Delete duplicate projects → project number |
--   -----------------------------------------------------
   WITH ranked_projects AS (
    SELECT
		id,
        pname,
        pnumber,
        plocation,
        dnum,
        ROW_NUMBER() OVER (PARTITION BY pnumber ORDER BY pname) AS rn
    FROM SILVER_layer.project
)
DELETE FROM SILVER_layer.project
WHERE (id,pname, pnumber, plocation, dnum) IN (
    SELECT id,pname, pnumber, plocation, dnum
    FROM ranked_projects
    WHERE rn > 1
);
    

    SELECT 
        pnumber,
        pname,
        plocation,
        dnum
    FROM SILVER_layer.project;

SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;

-- ==================================================================
-- ==================================================================

-- Find duplicate projects → project name  								✅✅ There is Duplicates
SELECT 
    'Project Name Duplicates' AS Duplicate_Type,
    pname,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.project
WHERE pname IS NOT NULL
GROUP BY pname
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--   -----------------------------------------------------
-- | SOLUTION:  Delete duplicate projects → project name   |
--   -----------------------------------------------------
   WITH ranked_projects AS (
    SELECT
		id,
        pname,
        pnumber,
        plocation,
        dnum,
        ROW_NUMBER() OVER (PARTITION BY pnumber ORDER BY pname) AS rn
    FROM SILVER_layer.project
)
DELETE FROM SILVER_layer.project
WHERE (id,pname, pnumber, plocation, dnum) IN (
    SELECT id,pname, pnumber, plocation, dnum
    FROM ranked_projects
    WHERE rn > 1
);
-- ==================================================================
-- ==================================================================

-- Find duplicate projects → name + location 					✅✅ There is Duplicates
SELECT 
    'Name + Location Duplicates' AS Duplicate_Type,
    pname,
    plocation,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.project
WHERE plocation IS NOT NULL
GROUP BY pname, plocation
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

--   ------------------------------------------------------
-- | SOLUTION:  Delete duplicate projects → location |
--   ------------------------------------------------------
   WITH ranked_projects AS (
    SELECT
		id,
        pname,
        pnumber,
        plocation,
        dnum,
        ROW_NUMBER() OVER (PARTITION BY pnumber ORDER BY pname) AS rn
    FROM SILVER_layer.project
)
DELETE FROM SILVER_layer.project
WHERE (id,pname, pnumber, plocation, dnum) IN (
    SELECT id,pname, pnumber, plocation, dnum
    FROM ranked_projects
    WHERE rn > 1
);
-- ==================================================================
-- ==================================================================

-- Find exact duplicate records (all fields match) 					✅✅ There is Duplicates
SELECT 
    'Exact Record Duplicates' AS Duplicate_Type,
    pname, pnumber, plocation, dnum,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.project
GROUP BY pname, pnumber, plocation, dnum
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- =====================================================
-- 4. DUPLICATES IN BRONZE_layer_works_on
-- =====================================================

SELECT 
    'Employee-Project Duplicates' AS Duplicate_Type,
    essn,
    pno,
    COUNT(*) AS duplicate_count,
    SUM(w_hours) AS total_hours,
    AVG(w_hours) AS avg_hours,
    MIN(w_hours) AS min_hours,
    MAX(w_hours) AS max_hours
FROM SILVER_layer.works_on
WHERE essn IS NOT NULL AND pno IS NOT NULL
GROUP BY essn, pno
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC, essn, pno;
-- ==================================================================
-- ==================================================================

-- Find exact duplicate records (all fields match)
SELECT 
    'Exact Record Duplicates' AS Duplicate_Type,
    essn, pno, w_hours,
    COUNT(*) AS duplicate_count
FROM SILVER_layer.works_on
GROUP BY essn, pno, w_hours
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- ==================================================================
-- ==================================================================

-- 		  -------------
-- 		|			 	|
-- 		|  Null values  |
-- 		|			 	|
-- 		  -------------

-- =====================================================
-- 1. NULL VALUES IN department TABLE
-- =====================================================

-- NULL values in dname (Department Name)
SELECT *, 'NULL dname (Department Name)' AS NULL_Type
FROM SILVER_layer.department
WHERE dname IS NULL;

-- NULL values in dnumber (Department Number) 
SELECT *, 'NULL dnumber (Department Number - PK)' AS NULL_Type
FROM SILVER_layer.department
WHERE dnumber IS NULL;

-- NULL values in mgrssn (Manager SSN)
SELECT *, 'NULL mgrssn (Manager SSN)' AS NULL_Type
FROM SILVER_layer.department
WHERE mgrssn IS NULL;

-- NULL values in mgrstartdate (Manager Start Date) 						 ✅✅ Null values
SELECT *, 'NULL mgrstartdate (Manager Start Date)' AS NULL_Type
FROM SILVER_layer.department
WHERE mgrstartdate IS NULL;

--   ----------------------------------------
-- | SOLUTION 1:  Default Value, set to today |
--   ----------------------------------------
UPDATE SILVER_layer.department
SET mgrstartdate = CURDATE()
WHERE mgrstartdate IS NULL;

--   -----------------------------------------------------
-- | SOLUTION 2: Central tendency: most common date (MODE) |
--   -----------------------------------------------------
UPDATE SILVER_layer.department
SET mgrstartdate = (
    SELECT mode_date
    FROM (
        SELECT mgrstartdate AS mode_date
        FROM SILVER_layer.department
        WHERE mgrstartdate IS NOT NULL
        GROUP BY mgrstartdate
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) t
)
WHERE mgrstartdate IS NULL;

SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;

SELECT mgrstartdate
FROM department;

-- =====================================================
-- 2. NULL VALUES IN employee TABLE
-- =====================================================

-- NULL values in fname (First Name)
SELECT *, 'NULL fname (First Name)' AS NULL_Type
FROM SILVER_layer.employee
WHERE fname IS NULL;

-- NULL values in lname (Last Name)
SELECT *, 'NULL lname (Last Name)' AS NULL_Type
FROM SILVER_layer.employee
WHERE lname IS NULL;

-- NULL values in ssn (Social Security Number) - Should be unique identifier!
SELECT *, 'NULL ssn (Social Security Number)' AS NULL_Type
FROM SILVER_layer.employee
WHERE ssn IS NULL;

-- NULL values in bdate (Birth Date)
SELECT *, 'NULL bdate (Birth Date)' AS NULL_Type
FROM SILVER_layer.employee
WHERE bdate IS NULL;

-- NULL values in e_address (Employee Address)   					✅✅ Null values
SELECT *, 'NULL e_address (Employee Address)' AS NULL_Type
FROM SILVER_layer.employee
WHERE e_address IS NULL;

--   ---------------------------------------
-- | SOLUTION 1: Default Value (safe choice) |
--   ---------------------------------------
UPDATE SILVER_layer.employee
SET e_address = 'Unknown Address'
WHERE e_address IS NULL;

-- ==================================================================
-- ==================================================================

-- NULL values in gender 											✅✅ Null values
SELECT *, 'NULL gender' AS NULL_Type
FROM SILVER_layer.employee
WHERE gender IS NULL;

--   ---------------------------------------
-- | SOLUTION 1: Default Value (safe choice) |
--   ---------------------------------------
UPDATE SILVER_layer.employee
SET gender = 'U' -- Unknown
WHERE gender IS NULL;

--   ----------------------------------------------------------
-- | SOLUTION 2: Mode (most frequent address) (Moderate choice) |
--   ----------------------------------------------------------
UPDATE SILVER_layer.employee
SET gender = (
    SELECT g_mode
    FROM (
        SELECT gender AS g_mode
        FROM SILVER_layer.employee
        WHERE gender IS NOT NULL
        GROUP BY gender
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) t
)
WHERE gender IS NULL;

SELECT gender, concat(fname,' ', lname) as FULL_NAME
FROM employee;
--   -------------------
-- | SOLUTION 3: Random  |
--   -------------------
UPDATE SILVER_layer.employee
SET gender = CASE WHEN RAND() < 0.5 THEN 'M' ELSE 'F' END
WHERE gender IS NULL;
-- ==================================================================
-- ==================================================================

-- NULL values in salary											✅✅ Null values
SELECT *, 'NULL salary' AS NULL_Type
FROM SILVER_layer.employee
WHERE salary IS NULL;

--   -------------------------------------------
-- | SOLUTION 1: Default Value (Moderate choice) |
--   -------------------------------------------
UPDATE SILVER_layer.employee
SET salary = 0
WHERE salary IS NULL;

--   ------------------------------------------
-- | SOLUTION 2: Mean (Bad: Outliers Sensetive) |
--   ------------------------------------------
UPDATE SILVER_layer.employee
SET salary = (
    SELECT AVG(salary)
    FROM SILVER_layer.employee
    WHERE salary IS NOT NULL
)
WHERE salary IS NULL;

--   -----------------------------------------------
-- | SOLUTION 3: Median (BEST: Outliers Insensetive) |
--   -----------------------------------------------

SET @total_count = (
    SELECT COUNT(*) 
    FROM SILVER_layer.employee 
    WHERE salary IS NOT NULL
);

SET @is_odd = @total_count % 2;

SET @pos1 = FLOOR(@total_count / 2);
SET @pos2 = @pos1 + 1;

SET @median_salary = (
    SELECT 
        CASE 
            WHEN @is_odd = 1 THEN 
                -- Odd count: get middle value at position (n+1)/2
                (SELECT salary 
                 FROM (SELECT salary, ROW_NUMBER() OVER (ORDER BY salary) as rn
                       FROM SILVER_layer.employee 
                       WHERE salary IS NOT NULL) ranked
                 WHERE rn = CEIL(@total_count / 2))
            ELSE 
                (SELECT AVG(salary)
                 FROM (SELECT salary, ROW_NUMBER() OVER (ORDER BY salary) as rn
                       FROM SILVER_layer.employee 
                       WHERE salary IS NOT NULL) ranked
                 WHERE rn IN (@pos1, @pos2))
        END
);

UPDATE SILVER_layer.employee
SET salary = @median_salary
WHERE salary IS NULL;

--   ------------------------------------------------------------------
-- | SOLUTION 4: Mode (Moderate: There is might be no repeated salaries |
--   ------------------------------------------------------------------
UPDATE SILVER_layer.employee
SET salary = (
    SELECT mode_salary
    FROM (
        SELECT salary AS mode_salary
        FROM SILVER_layer.employee
        WHERE salary IS NOT NULL
        GROUP BY salary
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) t
)
WHERE salary IS NULL;

--   --------------------------
-- | SOLUTION 5: Random (worst) |
--   --------------------------
UPDATE SILVER_layer.employee
SET salary = FLOOR(500 + (RAND() * (90000 - 500)))
WHERE salary IS NULL;

-- ==================================================================
-- ==================================================================
-- NULL values in superssn (Supervisor SSN)							✅✅ Null values
SELECT *, 'NULL superssn (Supervisor SSN)' AS NULL_Type
FROM SILVER_layer.employee
WHERE superssn IS NULL;

--   --------------------------
-- | SOLUTION 1:  Default Value |
--   --------------------------
UPDATE SILVER_layer.employee
SET superssn = '000000000'
WHERE superssn IS NULL;

-- ==================================================================
-- ==================================================================

-- NULL values in dno (Department Number)
SELECT *, 'NULL dno (Department Number)' AS NULL_Type
FROM SILVER_layer.employee
WHERE dno IS NULL;

-- =====================================================
-- 3. NULL VALUES IN project TABLE
-- =====================================================

SELECT '========== NULL VALUES IN project TABLE ==========' AS Section;

-- NULL values in pname (Project Name)
SELECT *, 'NULL pname (Project Name)' AS NULL_Type
FROM SILVER_layer.project
WHERE pname IS NULL;

-- NULL values in pnumber (Project Number) - Should be unique identifier!
SELECT *, 'NULL pnumber (Project Number)' AS NULL_Type
FROM SILVER_layer.project
WHERE pnumber IS NULL;

-- NULL values in plocation (Project Location)								✅✅ Null values
SELECT *, 'NULL plocation (Project Location)' AS NULL_Type
FROM SILVER_layer.project
WHERE plocation IS NULL;

--   ---------------------------------
-- | SOLUTION 1:  Default Value (Safe) |
--   ---------------------------------
UPDATE SILVER_layer.project
SET plocation = 'Unknown'
WHERE plocation IS NULL;

--   -----------------------------------------------------
-- | SOLUTION 2: Central tendency: most common date (MODE) |
--   -----------------------------------------------------
UPDATE SILVER_layer.project
SET plocation = (
    SELECT loc_mode
    FROM (
        SELECT plocation AS loc_mode
        FROM SILVER_layer.project
        WHERE plocation IS NOT NULL
        GROUP BY plocation
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) t
)
WHERE plocation IS NULL;
-- ==================================================================
-- ==================================================================

-- NULL values in dnum (Department Number)
SELECT *, 'NULL dnum (Department Number)' AS NULL_Type
FROM SILVER_layer.project
WHERE dnum IS NULL;

-- =====================================================
-- 4. NULL VALUES IN works_on TABLE
-- =====================================================

-- NULL values in essn (Employee SSN)
SELECT *, 'NULL essn (Employee SSN)' AS NULL_Type
FROM SILVER_layer.works_on
WHERE essn IS NULL;

-- NULL values in pno (Project Number)
SELECT *, 'NULL pno (Project Number)' AS NULL_Type
FROM SILVER_layer.works_on
WHERE pno IS NULL;

-- NULL values in w_hours (Work Hours)							✅✅ Null values
SELECT *, 'NULL w_hours (Work Hours)' AS NULL_Type
FROM SILVER_layer.works_on
WHERE w_hours IS NULL;

--   -------------------------------------------
-- | SOLUTION 1: Default Value (Moderate choice) |
--   -------------------------------------------
UPDATE SILVER_layer.works_on
SET w_hours = 0
WHERE w_hours IS NULL;


--   ------------------------------------------
-- | SOLUTION 2: Mean (Bad: Outliers Sensetive) |
--   ------------------------------------------
UPDATE SILVER_layer.works_on
SET w_hours = (
    SELECT AVG(w_hours)
    FROM SILVER_layer.works_on
    WHERE w_hours IS NOT NULL
)
WHERE w_hours IS NULL;


--   -----------------------------------------------
-- | SOLUTION 3: Median (BEST: Outliers Insensetive) |
--   -----------------------------------------------
-- Step 1: Get the count of non-NULL work hours
SET @total_count = (
    SELECT COUNT(*) 
    FROM SILVER_layer.works_on 
    WHERE w_hours IS NOT NULL
);

-- Step 2: Check odd/even
SET @is_odd = @total_count % 2;

-- Step 3: Calculate middle positions
SET @pos1 = FLOOR(@total_count / 2);
SET @pos2 = @pos1 + 1;

-- Step 4: Find the median value
SET @median_hours = (
    SELECT 
        CASE 
            WHEN @is_odd = 1 THEN 
                -- Odd: take the middle value
                (SELECT w_hours
                 FROM (SELECT w_hours, ROW_NUMBER() OVER (ORDER BY w_hours) AS rn
                       FROM SILVER_layer.works_on
                       WHERE w_hours IS NOT NULL) ranked
                 WHERE rn = CEIL(@total_count / 2))
            ELSE 
                -- Even: average the two middle values
                (SELECT AVG(w_hours)
                 FROM (SELECT w_hours, ROW_NUMBER() OVER (ORDER BY w_hours) AS rn
                       FROM SILVER_layer.works_on
                       WHERE w_hours IS NOT NULL) ranked
                 WHERE rn IN (@pos1, @pos2))
        END
);

-- Step 5: Update NULL w_hours with median
UPDATE SILVER_layer.works_on
SET w_hours = @median_hours
WHERE w_hours IS NULL;

--   ------------------------------------------------------------------
-- | SOLUTION 4: Mode (Moderate: There is might be no repeated salaries |
--   ------------------------------------------------------------------
UPDATE SILVER_layer.works_on
SET w_hours = (
    SELECT mode_hours
    FROM (
        SELECT w_hours AS mode_hours
        FROM SILVER_layer.works_on
        WHERE w_hours IS NOT NULL
        GROUP BY w_hours
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) t
)
WHERE w_hours IS NULL;

--   --------------------------
-- | SOLUTION 5: Random (worst) |
--   --------------------------
UPDATE SILVER_layer.works_on
SET w_hours = FLOOR(10 + RAND()*30) -- 10–40 hours
WHERE w_hours IS NULL;
-- ==================================================================
-- ==================================================================

-- 		 ------------
-- 		|			 |
-- 		|  Outliars  |
-- 		|			 |
-- 		 ------------

--   -------------------------------------
-- | Outlier detection for employee.salary |
--   -------------------------------------
-- salaries far below Q1 - 1.5*IQR (too low) or above Q3 + 1.5*IQR (too high)

-- Outliers in employee.salary using IQR (MySQL 8 compatible)
WITH ordered_salary AS (
  SELECT
    salary,
    ROW_NUMBER() OVER (ORDER BY salary) AS rn,
    COUNT(*) OVER () AS cnt
  FROM SILVER_layer.employee
  WHERE salary IS NOT NULL
),
stats AS (
  -- get the total count once (cnt is same for all rows)
  SELECT MAX(cnt) AS cnt FROM ordered_salary
),
quartiles AS (
  -- get Q1 and Q3 values by position: CEIL(cnt*0.25), CEIL(cnt*0.75)
  SELECT
    (SELECT salary FROM ordered_salary, stats WHERE ordered_salary.rn = CEIL(stats.cnt * 0.25) LIMIT 1) AS q1,
    (SELECT salary FROM ordered_salary, stats WHERE ordered_salary.rn = CEIL(stats.cnt * 0.75) LIMIT 1) AS q3
)
SELECT
  e.ssn,
  e.fname,
  e.lname,
  e.salary,
  q.q1,
  q.q3,
  (q.q3 - q.q1) AS iqr
FROM SILVER_layer.employee e
CROSS JOIN quartiles q
WHERE e.salary IS NOT NULL
  AND ( e.salary < q.q1 - 1.5 * (q.q3 - q.q1)
     OR e.salary > q.q3 + 1.5 * (q.q3 - q.q1) )
ORDER BY e.salary;

--   ------------------------------------------------------
-- | SOLUTION: Replace employee.salary Outliers with Median |
--   ------------------------------------------------------
-- Step 1: Calculate median salary
SET @total_count = (
    SELECT COUNT(*) 
    FROM SILVER_layer.employee 
    WHERE salary IS NOT NULL
);

SET @is_odd = @total_count % 2;
SET @pos1 = FLOOR(@total_count / 2);
SET @pos2 = @pos1 + 1;

SET @median_salary = (
    SELECT CASE 
        WHEN @is_odd = 1 THEN 
            -- Odd count: pick middle value
            (SELECT salary
             FROM (SELECT salary, ROW_NUMBER() OVER (ORDER BY salary) AS rn
                   FROM SILVER_layer.employee
                   WHERE salary IS NOT NULL) ranked
             WHERE rn = CEIL(@total_count / 2))
        ELSE
            -- Even count: average of two middle values
            (SELECT AVG(salary)
             FROM (SELECT salary, ROW_NUMBER() OVER (ORDER BY salary) AS rn
                   FROM SILVER_layer.employee
                   WHERE salary IS NOT NULL) ranked
             WHERE rn IN (@pos1, @pos2))
        END
);

-- Step 2: Replace outliers with median
WITH ordered_salary AS (
  SELECT
    ssn, salary,
    ROW_NUMBER() OVER (ORDER BY salary) AS rn,
    COUNT(*) OVER () AS cnt
  FROM SILVER_layer.employee
  WHERE salary IS NOT NULL
),
quartiles AS (
  SELECT
    (SELECT salary FROM ordered_salary WHERE rn = CEIL(cnt*0.25) LIMIT 1) AS q1,
    (SELECT salary FROM ordered_salary WHERE rn = CEIL(cnt*0.75) LIMIT 1) AS q3
)
UPDATE SILVER_layer.employee e
JOIN quartiles q
SET e.salary = @median_salary
WHERE e.salary IS NOT NULL
  AND (e.salary < q.q1 - 1.5 * (q.q3 - q.q1)
    OR e.salary > q.q3 + 1.5 * (q.q3 - q.q1));


SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;

SELECT MIN(salary), MAX(salary)
FROM employee;

SELECT salary
FROM employee;
--   --------------------------------------
-- | Outlier detection for works_on.w_hours |
--   --------------------------------------
-- salaries far below Q1 - 1.5*IQR (too low) or above Q3 + 1.5*IQR (too high)

WITH ordered_wh AS (
  SELECT
    w_hours,
    ROW_NUMBER() OVER (ORDER BY w_hours) AS rn,
    COUNT(*) OVER () AS cnt
  FROM SILVER_layer.works_on
  WHERE w_hours IS NOT NULL
),
quartiles AS (
  -- Step 2: Pick Q1 (25th percentile) and Q3 (75th percentile)
  SELECT
    (SELECT w_hours FROM ordered_wh WHERE rn = CEIL(cnt * 0.25) LIMIT 1) AS q1,
    (SELECT w_hours FROM ordered_wh WHERE rn = CEIL(cnt * 0.75) LIMIT 1) AS q3
)
-- Step 3: Compare actual w_hours to IQR boundaries
SELECT w.essn, w.pno, w.w_hours,
       q.q1, q.q3, (q.q3 - q.q1) AS iqr
FROM SILVER_layer.works_on w
CROSS JOIN quartiles q
WHERE w.w_hours IS NOT NULL
  AND (w.w_hours < q.q1 - 1.5 * (q.q3 - q.q1)
    OR w.w_hours > q.q3 + 1.5 * (q.q3 - q.q1));

--   -----------------------------------------------------
-- | SOLUTION: Replace works_on.w_hours Outliers with Mode |
--   -----------------------------------------------------
-- Step 1: Calculate mode (most common work hours value)
SET @mode_whours = (
    SELECT w_hours
    FROM SILVER_layer.works_on
    WHERE w_hours IS NOT NULL
    GROUP BY w_hours
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Step 2: Replace outliers with mode
WITH ordered_wh AS (
  SELECT
    w_hours,
    ROW_NUMBER() OVER (ORDER BY w_hours) AS rn,
    COUNT(*) OVER () AS cnt
  FROM SILVER_layer.works_on
  WHERE w_hours IS NOT NULL
),
quartiles AS (
  SELECT
    (SELECT w_hours FROM ordered_wh WHERE rn = CEIL(cnt*0.25) LIMIT 1) AS q1,
    (SELECT w_hours FROM ordered_wh WHERE rn = CEIL(cnt*0.75) LIMIT 1) AS q3
)
UPDATE SILVER_layer.works_on w
JOIN quartiles q
SET w.w_hours = @mode_whours
WHERE w.w_hours IS NOT NULL
  AND (w.w_hours < q.q1 - 1.5 * (q.q3 - q.q1)
    OR w.w_hours > q.q3 + 1.5 * (q.q3 - q.q1));
    


SELECT MIN(w_hours), MAX(w_hours)
FROM works_on;

SELECT w_hours
FROM works_on;
-- ==================================================================
-- ==================================================================

-- 		 ------------
-- 		|			 |
-- 		| Noisy data |
-- 		|			 |
-- 		 ------------

--   ----------------------------------------------
-- | Detect detect invalid genders (not 'F' or 'M') |
--   ----------------------------------------------

SELECT ssn, fname, lname, gender
FROM SILVER_layer.employee
WHERE gender NOT IN ('F','M') OR gender IS NULL;
-- ==================================================================
--   ------------------------------------------
-- | SOLUTION: Replace invalid gender with Mode |
--   ------------------------------------------

-- Find most common gender (Mode)
SET @mode_gender = (
  SELECT gender
  FROM SILVER_layer.employee
  WHERE gender IN ('F','M')
  GROUP BY gender
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

UPDATE SILVER_layer.employee
SET gender = @mode_gender
WHERE gender NOT IN ('F','M') OR gender IS NULL;
-- ==================================================================
--   --------------------------------------------------
-- | Manually correct genders [Emily Singh → F , not M] |
--   --------------------------------------------------

UPDATE SILVER_layer.employee
SET gender = 'F'
WHERE fname = 'Emily';

SELECT gender, concat(fname,' ', lname)as FULL_NAME
FROM employee;

-- ==================================================================
-- ==================================================================

--   ----------------------------------------------------
-- | DETECTION: Find invalid work hours (negative values) |
--   ----------------------------------------------------
SELECT essn, pno, w_hours
FROM SILVER_layer.works_on
WHERE w_hours < 0;

-- ==================================================================
--   -------------------------------------------------------
-- | SOLUTION: Replace negative work hours with Median value |
--   -------------------------------------------------------

SET @total_count = (
    SELECT COUNT(*) 
    FROM SILVER_layer.works_on 
    WHERE w_hours >= 0
);

SET @is_odd = @total_count % 2;
SET @pos1 = FLOOR(@total_count / 2);
SET @pos2 = @pos1 + 1;


SET @median_whours = (
    SELECT CASE 
        WHEN @is_odd = 1 THEN 
		
            (SELECT w_hours
             FROM (SELECT w_hours, ROW_NUMBER() OVER (ORDER BY w_hours) AS rn
                   FROM SILVER_layer.works_on
                   WHERE w_hours >= 0) ranked
             WHERE rn = CEIL(@total_count / 2))
             
        ELSE
        
            (SELECT AVG(w_hours)
             FROM (SELECT w_hours, ROW_NUMBER() OVER (ORDER BY w_hours) AS rn
                   FROM SILVER_layer.works_on
                   WHERE w_hours >= 0) ranked
             WHERE rn IN (@pos1, @pos2))
        END
);


UPDATE SILVER_layer.works_on
SET w_hours = @median_whours
WHERE w_hours < 0;


SELECT MIN(w_hours) AS min_hours, MAX(w_hours) AS max_hours
FROM SILVER_layer.works_on;


-- ==================================================================
-- ==================================================================

-- 		  -----------------
-- 		|			 		|
-- 		| Incosistancy data |
-- 		|			 		|
-- 		  -----------------

--   ------------------------------------------------------------------------------------------
-- | Detect Incosistancy at department names with Starting Letters not starting with uppercases |
--   ------------------------------------------------------------------------------------------
SELECT dname, dnumber										-- utf8mb4_0900_ai_ci → utf8mb4_bin
FROM SILVER_layer.department
WHERE dname COLLATE utf8mb4_bin REGEXP '^[a-z]';
-- ==================================================================
--   ---------------------------------------------------------------
-- | SOLUTION: changes first letter → uppercase, rest → lowercase. |
--   ---------------------------------------------------------------
UPDATE SILVER_layer.department
SET dname = CONCAT(UCASE(LEFT(dname,1)), LCASE(SUBSTRING(dname,2)))
WHERE dname COLLATE utf8mb4_bin REGEXP '^[a-z]';

SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;


SELECT dname, dnumber
FROM SILVER_layer.department;
-- ==================================================================
-- ==================================================================

--   ----------------------------------------------------------------------------------
-- | Detect inequality in Project num and Department num (dnum not in department table) |
--   ----------------------------------------------------------------------------------
SELECT p.*
FROM SILVER_layer.project p
LEFT JOIN SILVER_layer.department d
  ON p.dnum = d.dnumber
WHERE d.dnumber IS NULL;
-- =================================================================================================
--   --------------------------------------------------------------------------------------------------------
-- | SOLUTION: Reassign to a valid department 'Blockchain Pilot Project' → 'Information Technology Department'|
--   --------------------------------------------------------------------------------------------------------

DROP procedure IF exists LOAD_SILVER;
delimiter //
CREATE procedure LOAD_SILVER_UPDATE_PROJECT_DNUM ()
BEGIN
UPDATE SILVER_layer.project
SET dnum = 2   
WHERE pnumber = 121;
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;
END //
delimiter ; 

CALL LOAD_SILVER_UPDATE_PROJECT_DNUM;

SELECT dnumber, dname
FROM department;

SELECT pnumber, dnum, pname
FROM project;
