/*
===============================================================================
**Salary Progression & Performance Analytics** — window functions (LAG/LEAD, ROW_NUMBER), salary trend analysis.
===============================================================================
Purpose:
    - Show salary progression per employee, 
    - Compute previous salaries
	- Next salaries, show salary deltas
    - And rank employees by salary growth.
    

SQL Functions Used:
    - LAG(): Retrieves the previous row’s value within a partition (used for salary change comparison).
    - LEAD(): Retrieves the next row’s value within a partition (used for forecasting or forward comparisons).
    - ROW_NUMBER(): Assigns a unique row index within each partition based on ordering.
===============================================================================
*/

/* Goal: Show salary progression per employee, compute previous and 
next salaries, show salary deltas, and rank employees by salary growth. */

SELECT
emp.emp_no,
emp.first_name,
emp.last_name,
s.salary AS current_salary,
LAG(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date) AS previous_salary,
LEAD(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date) AS next_salary,
s.from_date,
s.to_date,
(s.salary - LAG(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date)) AS diff_from_prev,
(LEAD(s.salary) OVER (PARTITION BY s.emp_no ORDER BY s.from_date) - s.salary) AS diff_to_next
FROM salaries s
JOIN employees emp ON emp.emp_no = s.emp_no
WHERE s.salary > 80000 -- focus on higher-paid contracts
ORDER BY emp.emp_no, s.from_date;