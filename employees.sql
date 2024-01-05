use employees;

-- 1.  what is the present employee count??

SET @max_to_date =
	(SELECT 
		MAX(to_date) 
    FROM 						-- created variable and set the value = maximum to_date from salaries (9999-01-01) 
		salaries);
        
SELECT
    COUNT(emp_no) AS total_existing_employees
FROM
    salaries
WHERE
    to_date = @max_to_date;
    
    
    
SELECT 							-- alternate query using subquery instead of variable
    COUNT(emp_no) AS total_existing_employees
FROM																							
    salaries
WHERE
    to_date = (SELECT 
            MAX(to_date)
        FROM
            salaries);                   
    
    
-- 2. Extract latest salaries and department of employees

SELECT 
    l.emp_no, de.dept_no, s.salary
FROM
    (SELECT 
        emp_no, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no) AS l                                 -- extracted emp_no & latest date of employees in dept_emp table
JOIN
    dept_emp AS de ON l.emp_no = de.emp_no AND l.to_date = de.to_date    -- self joined dept_emp with itself for obtaining latest dept_no 
JOIN
    (SELECT 
        se.emp_no, s.salary
    FROM
        (SELECT 
        emp_no, MAX(to_date) AS to_date                            -- subquery from salaries table to obtain emp_no & latest date of employees in salaries table        
		FROM
        salaries
		GROUP BY emp_no) AS se
    JOIN salaries AS s ON se.emp_no = s.emp_no 					-- self joined salaries table to obtain latest salary for respective employee
        AND se.to_date = s.to_date
        ) AS s ON s.emp_no = l.emp_no;							-- joined both tables to acquire emp.no with latest dept_no and latest salary
        
                
-- 3. Assign employee number 110022 as a manager to all employees from 10001 to 10020 and employee number 110039 as a manager to all employees from 10021 to 10040

SELECT 
    A.*
FROM
    (SELECT 
    e.emp_no, MIN(de.dept_no) AS dept_no, 110022 AS manager
	FROM
		employees e
        JOIN
		dept_emp de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no BETWEEN 10001 AND 10020
	GROUP BY e.emp_no
	ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
    e.emp_no, MIN(de.dept_no), 110039
	FROM
		employees e
			JOIN
		dept_emp de ON e.emp_no = de.emp_no
	WHERE
		e.emp_no > 10020
	GROUP BY e.emp_no
	ORDER BY e.emp_no
	LIMIT 20) AS B;


-- 4. write a query to retrieve Number of female employees are drawing more than average salary of total employees

WITH cte AS 
(SELECT 
    AVG(salary) AS avg_salary
FROM
    salaries)

SELECT 
    SUM(CASE
			WHEN s.salary > c.avg_salary THEN 1
        ELSE 0
    END) AS no_of_female_salaries_above_avg
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
        CROSS JOIN
    cte c;



-- 5. There are few employees how where promoted by their title, which is recorded in titles table with from_date, to_date and title. 
-- And the salary details of that employee will be recorded in salaries table with from_date and to_date. write a query to obtain salary details along with title in that term of an employee.

SELECT
	s. emp_no, s.from_date, s.to_date, s.salary,
	s.salary - LAG(s.salary) OVER(PARTITION BY s.emp_no ORDER BY s.to_date) AS increment,
    t.title
FROM 
	salaries s
    JOIN titles t ON s.emp_no = t.emp_no AND (s.from_date > t.from_date AND s.to_date < t.to_date)
WHERE 
	s.emp_no = 10004;


-- 6. Create a Stored procedure for retrieving information of a particular employee based on emp_no

delimiter $$ 		   							-- change the delimiter to avoid confusion with semicolon
USE employees $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
SELECT 
    e.first_name, e.last_name, s.salary, s.from_date, s.to_date	
FROM
    employees e																
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
END $$
delimiter ;										-- restore the default delimeter


CALL emp_salary(110022);					                        -- call the stored procedure with emp_no as argument to retrive information of that employee

    
    
    
