/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - Create a trigger to prevent future hire dates; if hire_date > CURRENT_DATE(), set to CURRENT_DATE(). 
      Provide test cases.

SQL Functions Used:
    - CREATE TRIGGER: Defines an action executed automatically when data changes.
    - Conditional Logic: SET NEW.hire_date = CURRENT_DATE(): Overrides invalid data
    - Date Functions: Used in test cases to create a future date.
===============================================================================
*/
use employees;
-- Trigger: enforce hire_date not in the future
DELIMITER $$
CREATE TRIGGER trg_check_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
IF NEW.hire_date > CURRENT_DATE() THEN
SET NEW.hire_date = CURRENT_DATE();
END IF;
END$$
DELIMITER ;


-- Also create BEFORE UPDATE trigger to handle updates
DELIMITER $$
CREATE TRIGGER trg_check_hire_date_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
IF NEW.hire_date > CURRENT_DATE() THEN
SET NEW.hire_date = CURRENT_DATE();
END IF;
END$$
DELIMITER ;

-- Test cases for the trigger
-- 1) Insert with future date
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
VALUES (999999, '1990-01-01', 'Test', 'FutureHire', 'F', DATE_ADD(CURRENT_DATE(), INTERVAL 30 DAY));


-- 2) Verify the hire_date was adjusted
SELECT emp_no, first_name, last_name, hire_date FROM employees WHERE emp_no = 999999;


-- 3) Clean up
DELETE FROM employees WHERE emp_no = 999999;