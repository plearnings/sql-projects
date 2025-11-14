/*
===============================================================================
Multi-Stage Salary Intelligence Pipeline (CTE)
===============================================================================
Purpose:
    - Use multiple CTEs to compute: company average salary, 
    - Each employee's maximum salary
    - And count male employees whose max salary < company average..
   
SQL Functions Used:
    - CTE Functions: Creates reusable temporary result sets.
    - Aggregate Functions: AVG(),MAX(),COUNT().
    - JOIN & CROSS JOIN: Used to attach the company’s average salary to all rows
===============================================================================
*/
-- Multi-Stage Salary Intelligence Pipeline
-- 1) company_avg: the all-time company average salary
-- 2) emp_max: each employee's maximum salary
-- 3) male_below_avg: male employees whose max salary is below company average

use employees;
WITH company_avg AS (
SELECT AVG(salary) AS avg_salary
FROM salaries
),
emp_max AS (
SELECT e.emp_no, e.first_name, e.last_name, e.gender, MAX(s.salary) AS max_salary
FROM employees e
JOIN salaries s ON s.emp_no = e.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name, e.gender
),
male_below_avg AS (
SELECT em.*
FROM emp_max em
CROSS JOIN company_avg ca
WHERE em.gender = 'M' AND em.max_salary < ca.avg_salary
)
SELECT COUNT(*) AS male_emp_count_below_company_avg
FROM male_below_avg;