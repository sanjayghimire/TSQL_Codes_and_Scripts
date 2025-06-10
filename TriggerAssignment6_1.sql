Use Ldp_practice;
/******************Trigger Assignments**************/
--Account(Account_number,Name,Balance)
--transaction_table----(Tran_ID,Account_number,Tran_Amount,Tran_Date,Tran_Type)

--Update Trigger -> --When account table is updated, 500 -> 700 =200 -> 'Deposit'
				  --When account table is updated, 500 -> 300 =200 -> 'Withdraw'

create table Account 
(Account_number int identity(1,1) primary key,
Name varchar(10),
Balance int);

create table transaction_table
(Tran_ID int identity(1,1) ,
Account_number int foreign key references Account(Account_number),
Tran_Amount int,
Tran_Date datetime,
Tran_Type varchar(10)); 



INSERT INTO Account (Name, Balance) VALUES ('Ram', 1000);
INSERT INTO Account (Name, Balance) VALUES ('Shyam', 1500);
INSERT INTO Account (Name, Balance) VALUES ('Hari', 2000);
INSERT INTO Account (Name, Balance) VALUES ('Gita', 1800);

INSERT INTO transaction_table (Account_number, Tran_Amount, Tran_Date, Tran_Type)
VALUES 
(1, 200, GETDATE(), 'Deposit'),
(2, 300, GETDATE(), 'Withdraw'),
(3, 150, GETDATE(), 'Deposit'),
(4, 100, GETDATE(), 'Withdraw');


select * from Account;
 
select * from transaction_table;


--Update Trigger -> --When account table is updated, 500 -> 700 =200 -> 'Deposit'
				  --When account table is updated, 500 -> 300 =200 -> 'Withdraw'

USE Ldp_practice;
GO

Create Trigger UpdateTransaction On dbo.Account
After Insert, Update, Delete
As
Begin
    Insert Into transaction_table (Account_number, Tran_Amount, Tran_Date, Tran_Type)
    Select 
        i.Account_number,
        i.balance - d.balance As tranAmount,
        GetDate() As tranDate,		
        Case 
            When i.balance > d.balance Then 'Deposit'
            When i.balance < d.balance Then 'Withdraw'
            Else ''
        End As tranType
    From inserted i
    Inner Join deleted d On i.Account_number = d.Account_number
    Where i.balance != d.balance;
End;
Go

GO




-- DML operations are allowed only btween 8am-5pm
Create Trigger DmlOperationSchedule On dbo.Account
After Insert, Update, Delete
As
Begin
    IF DATEPART(HOUR, GETDATE()) NOT BETWEEN 9 AND 17
    Begin
        Print 'DML operations are only allowed between 8 AM and 5 PM.';
		Rollback;
    End
End;
Go





-------------------------------------

-- Allow transactions to be inserted in the transaction table only if the txn amount > 25
-- table txn ( txnid, txnamount, txndate)
CREATE TABLE txn (
    txnid INT IDENTITY(1,1) PRIMARY KEY,
    txnamount INT,
    txndate DATETIME
);
Go

Create Trigger insertTranAbove25 On dbo.txn
Instead Of Insert, Update, Delete
As
Begin
    Insert Into txn (txnamount, txndate)
    Select txnamount, txndate
    From inserted
    Where txnamount > 25;
End;
Go

GO

-------------------------------------

-- Update students totalmarks as soon as test scores are added to the test table
-- Test (TID, Module, Score,sid)
-- Student (SID, SName, totalMarks)

CREATE TABLE Student (
    SID INT PRIMARY KEY,
    SName VARCHAR(50),
    totalMarks INT DEFAULT 0
);

CREATE TABLE Test (
    TID INT IDENTITY(1,1) PRIMARY KEY,
    Module VARCHAR(50),
    Score INT,
    SID INT FOREIGN KEY REFERENCES Student(SID)
);

GO
Create Trigger updateTotalMarks On dbo.Test
After Insert, Update, Delete
As
Begin
    Update Student
    Set totalMarks = totalMarks + i.Score
    From Student s
    Inner Join inserted i On s.SID = i.SID;
End;
Go



-------------------------------------

**CREATE TABLE Sales (
     SalesID INT, PID INT, Qty INT, Name VARCHAR(50))
     
**CREATE TABLE Stock (
     PID INT, PName VARCHAR(50), Qty INT)

 /* Create a single Instead Of Trigger on Stock table for Insert, Update and Delete and notify DBA
    which DML statement has caused the trigger to get fired
    for e.g,
      INSERT INTO Stock VALUES (....)
       -your output should be:-
       Trigger got fired in INSERT Statement */


Go
Create Trigger FiredTrigger On dbo.stock
Instead Of Insert, Update, Delete
As
Begin
    Declare @insertedCount INT = (Select Count(*) From inserted);
    Declare @deletedCount INT = (Select Count(*) From deleted);

    If @insertedCount > 0 And @deletedCount = 0
        Print 'Trigger got fired in INSERT statement';
    Else If @insertedCount = 0 And @deletedCount > 0
        Print 'Trigger got fired in DELETE statement';
    Else If @insertedCount > 0 And @deletedCount > 0
        Print 'Trigger got fired in UPDATE statement';
End;
Go



-------------------------------------------

/* Create a trigger that will populate an Archive table
   which would hold all the historical records\data
   from the base table.
     --Base Table Structure:-
         BTable(ID, FName, LName, Salary)
     --Archive Table
         ATable(ID, FName, LName, Salary, Flag, TTime, user)
   Dataset in the Flag column of ATable should be
   as follows:-
       I       for Insert
       D       for Delete
       U_Old   for record which got replaced with UPDATE  
       U_New   for record which was updated with UPDATE */

Create Table BTable (
   ID INT, FName VARCHAR(50), LName VARCHAR(50), 
   Salary MONEY);
   
Create Table ATable (
   ID INT, FName VARCHAR(50), LName VARCHAR(50),
   Flag VARCHAR(10), TTime DATETIME, UserNm VARCHAR(MAX));

Select * from BTable
Select * from ATable
GO

Create Trigger trg_bTableArchive ON dbo.bTable
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    Declare @inserted INT = 0, @deleted INT = 0;

    Select @inserted = COUNT(*) FROM inserted;
    Select @deleted = COUNT(*) FROM deleted;

    IF(@inserted = 0 AND @deleted != 0)
    BEGIN
        Insert Into aTable
        Select id, fName, lName, salary, 'D', GETDATE(), SYSTEM_USER From deleted;
    END

    ELSE IF(@inserted != 0 AND @deleted = 0)
    BEGIN
        Insert INTO aTable
        Select id, fName, lName, salary, 'I', GETDATE(), SYSTEM_USER FROM inserted;
    END

    ELSE
    BEGIN
        Insert Into aTable
        Select id, fName, lName, salary, 'U_Old', GETDATE(), SYSTEM_USER From deleted;

        Insert Into aTable
        Select id, fName, lName, salary, 'U_New', GETDATE(), SYSTEM_USER From inserted;
    END
END
GO
