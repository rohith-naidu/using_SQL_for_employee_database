## Employee DataBase
This project demonstrates the use of Mysql to perform various data analysis tasks on an employee database. 
The database consists of four tables: employees, departments, salaries and titles. 
These tables are related by primary and foreign keys, and contain information such as employee ID, first name, last name, gender, hire date, departmentID, salary, title. 

The project aims to solve the following problems: 
1. what is the present employee count??
2. Extract latest salaries and department of employees
3. Assign employee number 110022 as a manager to all employees from 10001 to 10020 and employee number 110039 as a manager to all employees from 10021 to 10040
4. write a query to retrieve Number of female employees are drawing more than average salary of total employees
5. There are few employees how where promoted by their title, which is recorded in titles table with from_date, to_date and title. 
  And the salary details of that employee will be recorded in salaries table with from_date and to_date. write a query to obtain salary details along with title in that term of an employee.
6. Create a Stored Procedure for retrieving information about a particular employee based on emp_no

To answer these questions, the project uses Mysql commands such as SELECT, JOIN, GROUP BY, ORDER BY, and WHERE. The project also uses aggregate functions such as COUNT, AVG, MAX along with 
window functions like ROW_NUMBER(). At some situations, subquery, self joins and Common Table Expressions(CTE) were used.
The project shows the results of each query in a tabular format, and provides explanations and insights based on the data.
