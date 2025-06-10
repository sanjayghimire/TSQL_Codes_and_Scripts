--1-	Write a SQL statement to find salesman, customer and their cities for the salesmen and customer who belongs to the same city.
Select S.name, S.city, C.name, C.city
From Salesman S
Inner Join Customer C 
On S.salesman_id = C.salesman_id
Where S.city = C.city;


--2-	Write a SQL statement to find order no, purchase amount, customer and their cities for those orders which order amount between 200 and 1000.

Select O.order_no, O.purch_amt, C.cust_name, c.city
From Orders O
Inner Join Customer C 
On O.customer_id = C.customer_id
Where O.purch_amt Between 200 and 1000;

--3-	Write a SQL statement to know which salesman are working for which customer.
Select C.cust_name, S.name
From Customer C
Inner Join Salesman S
On C.salesman_id = S.salesman_id
Where C.salesman_id = S.salesman_id;

--4-	Write a SQL Query to find out the customers who appointed a salesman for jobs who gets a commission is less than 12% from the company.
Select C.cust_name, S.name, S.commission
From Customer C
Inner Join Salesman S
On C.salesman_id = S.salesman_id
WHere S.commission < 0.12;

--5-	Write a SQL Query to find out the customers who appointed a salesman for their jobs who does not live in the same city where their customer lives, and gets a commission is above 11%

Select C.cust_name, C.city, S.name, S.commission, S.city
From Customer C
Inner Join Salesman S
On C.salesman_id = S.salesman_id
WHere S.commission > 0.11 and C.city <> S.city;


--6-Find the details of an order i.e. order number, order date, amount of order, which customer gives the order and which salesman works for that customer and how much commission he gets for an order.

Select C.cust_name, S.name, O.ord_no, O.ord_date, O.purch_amt, S.commission
From orders O
Inner Join customer C
On O.customer_id = C.customer_id
Inner Join salesman S
On C.salesman_id = S.salesman_id;

--7-	SQL Query to join the tables salesman, customer and orders in such a way that the same column of each table will appear once and only the relational rows will come.

Select Distinct*
From orders O
Inner Join customer C
On O.customer_id = C.customer_id
Inner Join salesman S
On C.salesman_id = S.salesman_id;

--8-	Write a SQL Query for the customer in the ascending order who works either through a salesman or by own.

Select C.cust_name, S.name, 
From Customer C
Left Join Salesman S
On C.salesman_id = S.salesman_id
Order by C.cust_name asc;


--9-**	Write a SQL Query for to find out customer, city, order no. order date, purchase amount for only those customers who must have a grade and placed one or more orders or which order(s) have been placed by the customer who is neither in the list not have a grade.

Select C.cust_name, c.city, O.order_no, O.ord_date, O.purch_amt,
From Orders O
Inner Join Customer C 
On O.customer_id = C.customer_id
Where (C.grade Is Not Null and O.ord_no is Not Null) or C.grade is Null;


--10** – Write a SQL query to find the cartesian product of salesman and customer i.e. each salesman will appear for all customer and vice versa for that customer who belongs to a city.

Select C.cust_name, S.name, 
From Customer C
Cross Join Salesman S
On C.salesman_id = S.salesman_id;

--11-	Write a query in SQL to display those employees who contain a letter z to their first name and also display their last name, department, city, and state province.

Select E.first_name, E.last_name, D.department_name, L.city, L.state_province
From employees E
Inner Join departments D
On E.department_id = D.department_id
Inner Join locations L
on D.location_id = L.location_id
Where E.first_name like '%z%';

--12-	Write a query in SQL to display the first and last name and salary for those employees who earn less than the employee earn whose number is 100.

Select first_name, last_name, salary
from employees 
where salary < (Select salary 
from employees 
where employee_id = 100);

--13**-	Write a query in SQL to display the first name of all employees including the first name of their manager.

Select E.first_name, M.first_name
From employees E
Inner Join employees M
On E.manager_id = M.employee_id



--14**-	Write a query in SQL to display the first name of all employees and the first name of their manager including those who does not working under any manager.

Select E.first_name, M.first_name
From employees E
Left Join employees M
On E.manager_id = M.employee_id;


--15-	Write a query in SQL to display the first name, last name, and department number for those employees who work in the same department as the employee who hold the last name as Austin.

Select first_name, last_name, department_id 
From employees
Where department_id = (Select department_id from employees where last_name = 'Austin')


--16-	Write a query in SQL to display job title, full name (first and last name ) of employee, and the difference between maximum salary for the job and salary of the employee.

Select Concat(E.firstname, ' ', E.lastname) as FullName, J.job_title, (J.max_salary - e.salary) as Diff_In_Salary
From employees E
Inner Join jobs J
On E.job_id = J.job_id;



--17-	Write a query in SQL to display the full name (first and last name ) of employees, job title and the salary differences to their own job for those employees who is working in the department ID 60.

Select Concat(E.firstname, ' ', E.lastname) as FullName, J.job_title, (J.max_salary - e.salary) as Diff_In_Salary
From employees E
Inner Join jobs J
On E.job_id = J.job_id
Where j.department_id = 60;


--18-	Write a query in SQL to display the name of the country, city, and the departments which are running there.

Select C.country_name, L.city, D.department_name
From countries C
Inner Join location L
on C.country_id = L.country_id
Inner Join departments D
On L.location_id = D.location_id



--19-	Write a query in SQL to display department name and the full name (first and last name) of the manager.

Select Concat(E.FirstName, ' ', E.LastName), D.department_name
From employees E
Inner Join departments D
on E.department_id = D.department_id
Where E.manager_id = D.manager_id;


--20-	Write a query in SQL to display the details of jobs which was done by any of the employees who is presently earning a salary on and above 12000.


Select *
From job_history JH
Inner join employees E
On JH.employee_id = E.employee_id
Where employee_id in (Select employee_id from employees where salary >= 12000);


--21**-	Write a query in SQL to display the employee ID, job name, number of days worked in for all those jobs in department 90.

Select JH.employee_id, J.job_title, (JH.end_date - JH.start_date) as numofdaysworked
From jobs J
Inner Join job_history JH
on J.job_id = JH.job_id
Where JH.Department_id = 90


--22**-	Write a query in SQL to find the name of all reviewers who have rated their ratings with a NULL value.


Select RV.rev_name
From reviewer RV
Inner Join rating RT
on RV.rev_id = RT_rev_id
Where RT.revstars is null;


--23-	Write a query in SQL to list all the movies with year and genres.


Select M.mov_title, G.gen_title, M.mov_year
From movie_genres MG
Inner join movie M
on MG.mov_id = M.mov_id
Inner join genres G
On MG.gen_id = G.gen_id


--24-	Write a query in SQL to return the reviewer name, movie title, and stars in an order that reviewer name will come first, then by movie title, and lastly by number of stars