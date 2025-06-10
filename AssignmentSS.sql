
   --Customer (Cid, Cname, City, grade, salesman)
   Create Table Customer(
   CID INT PRIMARY KEY,
   CName VARCHAR(50),
   City VARCHAR(25),
   Grade INT,
   Salesman VARCHAR(50)
   );

   Select * From Customer;
   Insert Into Customer Values 
      (1,'Ram', 'Dallas', 8, 'Hari'),
   (2,'Shiva', 'Forth Worth', 10, 'Krishna'),
	(3,'John', 'PKR', 7, 'Undertaker'),
	(4,'Messi', 'KTM', 10, 'Ronaldo'),
	 (5,'Virat', 'Delhi', 9, 'Dhoni'),
	(6,'VTEN', 'Chitwan', 10, 'Laure')
	(7,'Cat', 'Chitwan', 5, 'Dog');

	


   Create Table OrderQuantity(
   OrderNo INT PRIMARY KEY,
   Purch_amt DECIMAL,
   Ord_Date Date,
   Customer_Id INT,
   Salesman_Id INT,
   FOREIGN KEY (Customer_Id) REFERENCES Customer(CID)
   );

   Select getdate() - 5;
   Insert Into OrderQuantity Values 
       (1,'3000', getdate(), 1, 101),
   (2,'5000', getdate()-5, 2, 102),
   (3,'10000', getdate()-9, 3, 108),
   (4,'6000', getdate()-3, 4, 109),
   (5,'2000', getdate()-7, 5, 106),
   (6,'7000', getdate()-8, 6, 107);
     (7,'3000', getdate()-8, 7, 103);
	  (8,'10000', getdate()-8, 7, 103);



   Select * From OrderQuantity;

--Order (ord_no, purch_amt,ord_date,customer_id,salesman_id)

--1.	Write a SQL statement which selects the highest grade for each of the cities of the customers.
     
	 Select City, Max(Grade) AS 'Highest Grade'
	 From Customer
	 Group By City;


--1.	Write a SQL statement to find the highest purchase amount ordered by each customer on a particular date with their ID, order date and highest purchase amount.
		Select Customer_Id, Ord_Date, Max(Purch_amt) AS Highest_Purchase_Amount
		From OrderQuantity
		Group By Customer_Id, Ord_Date;


--2.	Write a SQL statement to find the highest purchase amount on a date '2012-08-17' for each salesman with their ID.
  Select Salesman_Id, Max(Purch_amt) AS Highest_Purchase_Amount
  From OrderQuantity
  Where Ord_Date = '2025-05-06'
  Group By Salesman_Id;
  

--3.	Write a SQL statement to find the highest purchase amount with their ID and order date, for only those customers who have highest purchase amount in a day is more than 2000.
 Select Customer_Id, Ord_Date, Max(Purch_amt) As Highest_Purchase_Amount
  From OrderQuantity
  Where Purch_amt > 2000
  Group By Customer_Id, Ord_Date;


--4.	Write a SQL statement to find the highest purchase amount with their ID and order date, for those customers who have a higher purchase amount in a day is within the range 2000 and 6000.

 Select Customer_Id, Ord_Date, Max(Purch_amt) AS Highest_Purchase_Amount
  From OrderQuantity
  Group By Customer_Id, Ord_Date
  Having Max(Purch_amt) >= 2000 AND Max(Purch_amt) <= 6000;



--5.	Write a SQL statement to find the highest purchase amount with their ID and order date, for only those customers who have a higher purchase amount in a day is within the list 2000, 3000, 5760 and 6000. 

Select Customer_Id, Ord_Date, Max(Purch_amt) AS Highest_Purchase_Amount
  From OrderQuantity
  Group By Customer_Id, Ord_Date
  Having Max(Purch_amt) in (2000, 3000, 5760, 6000);

--6.	Write a query that counts the number of salesmen with their order date and ID registering orders for each day.?

SELECT Count(OrderNo) AS NumberOfSalesman, Ord_Date, Salesman_Id
FROM OrderQuantity
Group By Ord_Date, Salesman_Id;


--7.	Write a SQL query to calculate the average purchase amount of each customer.

SELECT Customer_Id, Avg(Purch_amt) AS Average_Purchase_Amount
FROM OrderQuantity
Group By Customer_Id;