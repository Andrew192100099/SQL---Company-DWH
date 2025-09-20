╔════════════════════════════════════════════════════════════════════╗
║                FINAL PROJECT — Company Workforce DWH   	         ║
╚════════════════════════════════════════════════════════════════════╝

Tagline: From raw OLTP chaos → to a structured, analytical-ready Data Mart.

────────────────────────────────────────────────────────────────────────
OVERVIEW
────────────────────────────────────────────────────────────────────────
This project implements a full Data Warehouse pipeline for company workforce data.
The goal is to clean, validate, and transform raw OLTP data into analytical-ready
Gold Layer tables, enabling HR and management to answer workforce and project-related
business questions.

Dataset & Context: Company data (employees, departments, projects, works_on).  
Layers used: Bronze → Silver → Gold (standard DWH architecture).  

────────────────────────────────────────────────────────────────────────
DELIVERABLES
────────────────────────────────────────────────────────────────────────
I.   project_creating_company_db   — Database creation script  
II.  project_data                  — Sample dataset inserts  
III. init_dwh                      — Initialize schemas (company_dwh)  
IV.  load_bronze                   — Load raw data into staging tables  
V.   ddl_silver                    — Create Silver layer tables  
VI.  vali_checks_bronze            — Validation checks on Bronze layer  
VII. load_silver                   — ETL into Silver layer  
VIII. vali_checks_silver           — Validation checks on Silver layer  
IX.  ddl_gold                      — Create Gold layer tables  
X.   load_gold                     — ETL into Gold layer  
XI.  que_gold                      — Business queries & reports  

────────────────────────────────────────────────────────────────────────
PROJECT LAYERS
────────────────────────────────────────────────────────────────────────
BRONZE — Raw ingestion (no cleaning, raw OLTP copied into stg_ tables).  
SILVER — Cleaned & standardized (duplicates removed, invalid values fixed, FK validated).  
GOLD   — Star Schema (fact + dimension tables for reporting, dashboards, KPIs).  

────────────────────────────────────────────────────────────────────────
BUSINESS QUESTIONS ANSWERED
────────────────────────────────────────────────────────────────────────
1. Top 5 projects based on total hours worked.  
2. Number of employees per project.  
3. Participation rates across departments.  

────────────────────────────────────────────────────────────────────────
FINAL DELIVERABLES
────────────────────────────────────────────────────────────────────────
✔ Gold Layer ERD (Star Schema)  
✔ Stored Procedures for ETL across layers  
✔ Business Queries on Gold Layer  
✔ Validation checks for data quality  

────────────────────────────────────────────────────────────────────────
QUERY LIST
────────────────────────────────────────────────────────────────────────
1. Employees in Engineering (dno=10) sorted by salary  
2. Top 5 most common employee addresses  
3. Managers with names starting 'J' and containing 'e'  
4. Employees without department OR supervisor  
5. Departments and their managers (showing "No Manager" if null)  
6. Employees earning 40K–60K not in HR/IT/Finance  
7. Average salary by gender per department  
8. Departments with >1 employee AND avg salary > 50K  
9. Total work hours per project location (>30 hours)  
10. Projects with department & manager details  
11. Employees with/without projects (COALESCE "No Project")  
12. Departments ↔ Projects (including no matches, using UNION)  
13. Employees with projects vs. without projects  
14. Employees earning more than ALL in Customer Service (dno=9)  
15. Employees earning above their department average  
17. Project workload % of department total hours  
    • Standard GROUP BY solution  
    • Alternative solution using Window Functions  
18. Invalid assignments:  
    • Employees in non-existent departments  
    • Projects in non-existent departments  
19. Department efficiency score = (Total Project Hours / Total Salaries) × 100  

────────────────────────────────────────────────────────────────────────
HIGHLIGHTS
────────────────────────────────────────────────────────────────────────
• Use of **JOINs, GROUP BY, HAVING, COALESCE, UNION** for complex logic.  
• Advanced **Window Functions (ROW_NUMBER, SUM OVER, PARTITION)** to simplify queries.  
• Business-driven KPIs: efficiency scores, project % contributions, salary gaps.  

────────────────────────────────────────────────────────────────────────
NOTES ON SQL COMPATIBILITY ⚠
────────────────────────────────────────────────────────────────────────
• These scripts are written in **MySQL** syntax.  
• SQL dialects vary across database systems.  
• If opened in Microsoft SQL Server (T-SQL) or Oracle, syntax errors will occur.  
• For correct execution → **use MySQL Workbench / MySQL CLI**.  

────────────────────────────────────────────────────────────────────────
LICENSE & CREDITS
────────────────────────────────────────────────────────────────────────
Author: <Andrew Wageh>  
Institute: National Telecommunication Institute (NTI), Egypt  
Track: Data Analytics 

════════════════════════════════════════════════════════════════════════

