--1. List the following details of each employee: employee number, last name, first name, gender, and salary.

SELECT 
e.emp_no,
e.last_name,
e.first_name,
e.gender,
s.salary
FROM employees e
JOIN salaries s on s.emp_no = e.emp_no; 

--2. List employees who were hired in 1986.
SELECT 
	emp_no,
	last_name,
	first_name,
	hire_date
FROM employees 
WHERE  date_part('year', hire_date) = 1986;

--3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, 
--last name, first name, and start and end employment dates.

SELECT 
	dm.dept_no as "Department_No",
	d.dept_name as "Department_Name",
	dm.emp_no as “Employee_No”,
	e.last_name as “Last_Name”,
	e.first_name as “First_Name”,
	dm.from_date as “Emp_Start_Date”,
	CASE WHEN dm.to_date = '01/01/9999' THEN NULL
		ELSE dm.to_date 
		END AS “Emp_End_Date” --handle default null value, still employed
FROM dept_manager dm
JOIN departments d ON d.dept_no = dm.dept_no
JOIN employees e ON e.emp_no = dm.emp_no;


--4. List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

SELECT 
	e.emp_no as "Employee_no",
	e.last_name as "Last_Name",
	e.first_name as "First_Name",
	d.dept_name as "Department_Name"	
FROM employees e
--get current/latest department
JOIN (SELECT  emp_no, 
		max(from_date) as "from_date", 
		max(to_date) as "to_date", 
		max(ID) as "MaxID"
	FROM dept_emp
	GROUP BY emp_no) mde ON mde.emp_no = e.emp_no
JOIN dept_emp de ON de.emp_no = e.emp_no
	and de.ID = mde."MaxID"
JOIN departments d ON d.dept_no = de.dept_no;


--5. List all employees whose first name is "Hercules" and last names begin with "B."

SELECT *
FROM employees 
WHERE first_name = 'Hercules'
and substring(last_name, 1, 1) = 'B';

--6. List all employees in the Sales department, 
--including their employee number, last name, first name, and department name.

SELECT 
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM employees e
--get current/latest department
JOIN (SELECT  emp_no, 
		max(from_date) as "from_date", 
		max(to_date) as "to_date", 
		max(ID) as "MaxID"
	FROM dept_emp
	GROUP BY emp_no) mde ON mde.emp_no = e.emp_no
JOIN dept_emp de ON de.emp_no = e.emp_no
	and de.ID = mde."MaxID"
JOIN departments d on d.dept_no = de.dept_no
	and d.dept_name = 'Sales'
WHERE de.to_date >= NOW() --get employees currently in sales
;

--7. List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.

SELECT 
	e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM employees e
--get current/latest department
JOIN (SELECT  emp_no, 
		max(from_date) as "from_date", 
		max(to_date) as "to_date", 
		max(ID) as "MaxID"
	FROM dept_emp
	GROUP BY emp_no) mde ON mde.emp_no = e.emp_no
JOIN dept_emp de ON de.emp_no = e.emp_no
	and de.ID = mde."MaxID"
JOIN departments d on d.dept_no = de.dept_no
	and d.dept_name in ('Sales', 'Development')
WHERE de.to_date >= NOW() --get employees currently in sales
;

--8. In descending order, list the frequency count of employee last names,
--i.e., how many employees share each last name.

SELECT 
	last_name, 
	count(emp_no) as "share_Last_name_count"
FROM employees
GROUP BY last_name
ORDER BY 2 desc;


