

#Create the Customers table
CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
-- Create the Branches table
CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);
-- Create the Accounts table
CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
-- Create the Transactions table
CREATE TABLE Transactionss (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- --insert data
INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');
--------------------
INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');
--------------------
INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);

INSERT INTO Transactionss (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);

--------------------


#select * from  customers
#select * from accounts
#select * from branches
#select * from transactions

# What are the names of all the customers who live in New York?

select concat( FirstName, ' ', LastName) as customer, City from customers where City = "New York";

# What is the total number of accounts in the Accounts table?

select count( Accountid) as no_of_account from accounts;

# What is the total balance of all checking accounts?

select sum(Balance) as total_balace , AccountType from accounts where AccountType = "Checking";

# What is the total balance of all accounts associated with customers who live in Los Angeles?

select a.CustomerID, sum(a.Balance) from accounts as a where a.CustomerID in (
 select c.CustomerID  from customers as c inner join accounts as a on a.CustomerID = c.CustomerID where  c.City = "Los Angeles") group by a.CustomerID;
 
 
 # Which branch has the highest average account balance?

with avg_balance as
( select BranchID, avg(Balance) as avg_bal from accounts group by BranchID)
 select b.*, a.avg_bal from avg_balance as a left join branches as b on a.BranchID = b.BranchID where a.avg_bal = ( select max(avg_bal)
 from avg_balance);
 
# Which customer has the highest current balance in their accounts?

 select c.CustomerID, c.FirstName, a.Balance from customers as c
join accounts as a on c.CustomerID = a.CustomerID 
order by a.Balance desc
limit 1 ; 

#Which customer has made the most transactions in the Transactions table?

 with no_transaction as ( select AccountID, count(transactionDate) as cnt from transactions as t group by AccountID)
 select distinct concat(c.FirstName, ' ',  c.LastName) as customername, c.CustomerID from no_transaction as z left join accounts as a on a.AccountID = z.AccountID
 left join customers as c on c.CustomerID = a.CustomerID where cnt = ( select max(cnt) from no_transaction);

#Which branch has the highest total balance across all of its accounts?

with total_balance as ( select Branchid, sum(Balance) as summ from accounts group by BranchID)
select b.*, t.summ from total_balance as t left join branches as b on t.BranchID = b.BranchID where t.summ = (
select max(summ) from total_balance);

#Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
with total_balance as ( select CustomerID, sum(Balance) as summ from accounts group by CustomerID)
select c.*, a.summ from total_balance as a  join customers as c on a.CustomerID = c.CustomeriD where summ =( select max(summ) from total_balance);

#Which branch has the highest number of transactions in the Transactions table?

with transaction_no as (select AccountID, count(TransactionDate) as cnt from transactions group by AccountID)
 select distinct a.BranchID, b.Branchname from transaction_no as c  left join accounts as a on a.AccountID = c.AccountID
left join branches as b on b.BranchID = a.BranchID where cnt = (select max(cnt) from transaction_no) ;	
 
 



