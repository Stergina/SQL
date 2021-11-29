-- Question 1

-- Question 1.1

-- Creates CAMPDW database
create database CAMPDW

-- Creates campdata table
create table campdata (
custID int,
fname varchar(30),
lname varchar(30),
cID int,
country varchar(30),
bookID int,
bookDate date,
campCode char(3),
campName varchar(50),
empno int,
catCode char(1),
category varchar(20),
unitCost numeric(4,2),
startDate date,
overnights int,
persons int
);

-- Loads CAMPDATA.TXT data into campdata table
bulk insert campdata
from 'C:\data\CAMPDATA.TXT'
with (firstrow = 2,fieldterminator = '|',rowterminator = '\n');


-- Question 1.2

-- Creates the star schema for the data warehouse

-- Customers table
create table customers
(custID int primary key,
fname varchar(30),
lname varchar(30),
);

-- Countries table
create table countries
(cID int primary key,
country varchar(30),
);

-- Categories table
create table categories
(catCode char(1) primary key,
category varchar(20),
unitCost numeric(4,2),
);

-- Camps table
create table camps
(campCode char(3) primary key,
campName varchar(50),
);

-- Bookings table
create table bookings
(bookID int,
custID int,
cID int,
catCode char(1),
campCode char(3),
empno int,
startDate date,
bookDate date,
overnights int,
persons int,

primary key(bookID,empno,startDate,custID,cID,catCode,campCode),
foreign key (custID) references customers(custID),
foreign key (cID) references countries(cID),
foreign key (catCode) references categories(catCode),
foreign key (campCode) references camps(campCode),
);


-- Question 1.3

-- Loads data from table campdata to customers table
insert into customers
select distinct custID,fname,lname
from campdata;

-- Loads data from table campdata to countries table
insert into countries
select distinct cID,country
from campdata;

-- Loads data from table campdata to categories table
insert into categories
select distinct catCode,category,unitCost
from campdata;

-- Loads data from table campdata to camps table
insert into camps
select distinct campCode,campName
from campdata;

-- Loads data from table campdata to bookings table
insert into bookings
select distinct bookID,custID,cID,catCode,campCode,empno,startDate,bookDate,overnights,persons
from campdata;


-- Question 2

-- Question 2.1

-- Displays the top 100 customers in descending order
select top 100 fname,lname,country,sum(unitCost*overnights*persons) as total_value
from customers,countries,bookings,categories
where customers.custID=bookings.custID and countries.cID=bookings.cID and categories.catCode=bookings.catCode
group by fname,lname,country
order by total_value desc;


-- Question 2.2

-- Displays the total booking value by camp and emplacement category for year 2000
select campName,category,sum(unitCost*overnights*persons) as total_value
from categories,camps,bookings
where categories.catCode=bookings.catCode and camps.campCode=bookings.campCode and datepart(year,bookings.startDate)='2000'
group by campName,category;


-- Question 2.3

-- Displays the total monthly booking value by camp for year 2018
select campName,sum(unitCost*overnights*persons) as total_value,datepart(month,bookings.startDate) as month
from categories,camps,bookings
where categories.catCode=bookings.catCode and camps.campCode=bookings.campCode and datepart(year,bookings.startDate)='2018'
group by campName,datepart(month,bookings.startDate);


-- Question 2.4

-- Displays the total number of tenants by year, camp and category
select campName,category,sum(persons) as total_tenants, datepart(year,bookings.startDate) as year
from categories,camps,bookings
where categories.catCode=bookings.catCode and camps.campCode=bookings.campCode
group by rollup (datepart(year,bookings.startDate),campName,category);


-- Question 2.5

-- Displays camps that had more tenants in year 2018 than in year 2017
go
create view v1 as
select campName,sum(persons) as total_tenants, datepart(year,bookings.startDate) as year
from categories,camps,bookings
where categories.catCode=bookings.catCode and camps.campCode=bookings.campCode and datepart(year,bookings.startDate)>='2017' and datepart(year,bookings.startDate)<='2018'
group by campName,datepart(year,bookings.startDate);
go

select campName
from (
select row_number()
over(partition by campName
order by total_tenants desc) as rank, *
from v1) n
where rank = 1 and year = '2018';


-- Question 3

-- Creates a cube that analyzes booking value by year, camp and category
select datepart(year,bookings.startDate) as year,campName,category,sum(unitCost*overnights*persons) as total_value
from bookings, categories, camps
where categories.catCode=bookings.catCode and
camps.campCode=bookings.campCode
group by cube (datepart(year,bookings.startDate),campName,category);