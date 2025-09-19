# SQL__Company__DWH
End-to-end Data Warehouse project (MySQL): OLTP → Bronze → Silver → Gold, with ETL scripts, validation, and workforce analytics.
____________

## 📌 Project Context

This project was developed during the National Telecommunication Institute (NTI), Egypt — Data Analytics 
It simulates real-world SQL practices used in companies to design and implement a **Data Warehouse (DWH)** for workforce and project management analytics.

## 🏯The focus is on building a layered architecture:

➢ **Bronze Layer →** Raw OLTP data ingestion ***(staging)***

➢ **Silver Layer →** Data cleaning, validation, and normalization

➢ **Gold Layer →** Analytical-ready Star Schema ***(fact + dimensions)***
__________________________________

## 📂 Deliverables

**✔ Database creation and initial schema setup**
**✔ ETL scripts for Bronze → Silver → Gold transitions**
**✔ Data validation checks** *(duplicates, NULLs, inconsistent values)*
**✔ Business queries on the Gold Layer for HR, Salary, Projects, KPIs**
**✔ Advanced SQL using JOINs, Window Functions, GROUP BY, HAVING, COALESCE, UNION**
**✔ ERD for the Gold Layer** *(Star Schema)*
______________________________

## 📊 Business Questions Answered

**📍 Who are the top employees by salary in each department?**

**📍 Which projects consume the most hours?**

**📍 How efficient is each department (project hours vs. salaries)?**

**📍 Which employees are unassigned to projects or supervisors?**

**📍 Salary distribution by gender and department.**

**📍 Department–Project relationships, including gaps (no projects, no managers).**
____________________

## ⚠ Notes on SQL Compatibility

All scripts and queries are written in **<ins>MySQL syntax</ins>**.

**SQL dialects differ across platforms →** opening in *Microsoft SQL Server* **,** *PostgreSQL* **,** or *Oracle* **<ins>will produce syntax errors</ins>**.

**✅ For correct execution,** use **<ins>MySQL Workbench </ins>**  or **<ins>MySQL CLI</ins>** *(tested on MySQL 8.0 CE)*.
________________________

## 🎯 Why This Project Matters

*➢ Mimics real-world corporate SQL workflows for building analytical Data Warehouses.*

*➢ Provides hands-on experience in data cleaning, ETL, and Star Schema modeling.*

*➢ Bridges the gap between academic training and business-driven analytics.*

*➢ A practical showcase of Data Analytics skills gained at NTI, Egypt.*
