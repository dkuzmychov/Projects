USE master 
IF DB_ID('LSP_dk') IS NOT NULL  
BEGIN  
 ALTER DATABASE LSP_dk SET OFFLINE WITH ROLLBACK IMMEDIATE;  
 ALTER DATABASE LSP_dk SET ONLINE;  
 DROP DATABASE LSP_dk;  
END 
CREATE DATABASE LSP_dk 
GO
USE LSP_dk

/*************************************************************************************************** 
Create Tables for Database.
***************************************************************************************************/
Go 
Create table Rooms 
(
	RoomID int NOT NULL Identity (1,1),
	RoomName varchar(10) NULL,
	Capacity varchar(50) NULL,
	Constraint PK_Room PRIMARY KEY (RoomID)
)
Go 
Create table Term
(
	TermID int not null identity (1,1),
	TermCode char(4) null,
	TermName varchar (11) null,
	CalendarYear int null,
	AcademicYear int null,
	CONSTRAINT PK_Term PRIMARY KEY (TermID)
)
Go 
Create table Person
(
	PersonID int not null identity (1,1),
	LastName varchar(50) Null,
	FirstName varchar(50) Null,
	MiddleName varchar(50) Null,
	Gender char(1) Null, 
	Phone varchar(50) Null,
	Email varchar(50) Null,
	CONSTRAINT PK_Person PRIMARY KEY (PersonID)
)
Go
Create table Section 
(
	SectionID int Not Null identity (10000,1),
	CourseID int not null,
	TermID int not null,
	StartDate date null,
	EndDate date null, 
	[Days] varchar(50) null,
	SectionStatus varchar(50) null,
	RoomID int null,
	Constraint PK_Section PRIMARY KEY (SectionID),
	--CONSTRAINT FK_Section_Rooms FOREIGN KEY (RoomID) REFERENCES Rooms (RoomID),
	--CONSTRAINT FK_Section_Term FOREIGN KEY (TermID) REFERENCES Term (TermID),
	--CONSTRAINT FK_Section_Course FOREIGN KEY (CourseID) REFERENCES Course (CourseID)
)
Go
Create table Course 
(
	CourseID int not null Identity (1,1),
	CourseCode varchar(7) Null,
	CourseTitle varchar(70) null, 
	TotalWeeks int null,
	TotalHours numeric(9,2) null,
	FullCourseFee numeric(9,2) null,
	CourseDescription varchar(500) null,
	Constraint PK_Course PRIMARY KEY (CourseID)
)
Go
Create table ClassList
(
	ClassListID int not null identity (1,1),
	SectionID int not null,
	PersonID int not null,
	Grade varchar(2) null, 
	EnrollmentStatus char(2) null,
	TuitionAmount money null,
	CONSTRAINT PK_ClassList PRIMARY KEY (ClassListID),
	--CONSTRAINT FK_ClassList_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID),
	--CONSTRAINT FK_ClassList_Section FOREIGN KEY (SectionID) REFERENCES Section (SectionID)
)
Go
Create Table Address
(
	AddressID int not null identity (1,1),
	AddressType varchar(10) null,
	AddressLine varchar(50) not null,
	City varchar(50) null,
	State varchar(50) null,
	PostalCode varchar(50) null,
	Country varchar(50) null, 
	PersonID int null, 
	CONSTRAINT PK_Address PRIMARY KEY (AddressID),
	--CONSTRAINT FK_Address_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID) 
)
Go
Create Table Faculty
(
	FacultyID int not null identity (1,1),
	FacultyFirstName varchar(50) null,
	FacultyLastName varchar(50) null,
	FacultyEmail varchar(100) null,
	PrimaryPhone varchar(50) null,
	AlternatePhone varchar(50) null,
	FacultyAddressLine varchar(50) null,
	FacultyCity varchar(50) null,
	FacultyState char(2) null,
	FacultyPostalCode varchar(50) null,
	FacultyCountry varchar(50) null,
	CONSTRAINT PK_Faculty PRIMARY KEY (FacultyID)
)
Go
Create Table FacultyPayment
(
	FacultyPaymentID int not null identity (1,1),
	FacultyID int null,
	SectionID int null,
	PrimaryInstructor char(1) not null,
	PaymentAmount numeric(9,2) Null,
	CONSTRAINT PK_FacultyPayment PRIMARY KEY (FacultyPaymentID),
	--CONSTRAINT FK_FacultyPayment_Faculty FOREIGN KEY (FacultyID) REFERENCES Faculty (FacultyID),
	--CONSTRAINT FK_FacultyPayment_Section FOREIGN KEY (SectionID) REFERENCES Section (SectionID)

)
Go
Alter table Section ADD Constraint FK_Section_Course FOREIGN KEY (CourseID) REFERENCES Course (CourseID)
Go
Alter Table Section ADD Constraint FK_Section_Rooms FOREIGN KEY (RoomID) REFERENCES Rooms (RoomID)
Go
Alter Table Section ADD Constraint FK_Section_Term FOREIGN KEY (TermID) REFERENCES Term (TermID)
Go 
Alter Table ClassList ADD CONSTRAINT FK_ClassList_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID)
Go
Alter Table ClassList ADD CONSTRAINT FK_ClassList_Section FOREIGN KEY (SectionID) REFERENCES Section (SectionID)
Go
Alter Table Address ADD CONSTRAINT FK_Address_Person FOREIGN KEY (PersonID) REFERENCES Person (PersonID)
Go
Alter Table FacultyPayment ADD CONSTRAINT FK_FacultyPayment_Faculty FOREIGN KEY (FacultyID) REFERENCES Faculty (FacultyID)
Go
Alter Table FacultyPayment ADD CONSTRAINT FK_FacultyPayment_Section FOREIGN KEY (SectionID) REFERENCES Section (SectionID)
Go

/*************************************************************************************************** 
Normalize and Move data to dabase tables.
***************************************************************************************************/ 

Insert into Rooms
(
RoomName, Capacity
)
select 
	RoomName, 
	Capacity
From [LSP_data].dbo.[Rooms15]

--Select *
--FROM Rooms

------------------------------------------------------------------------------------------------------

Set identity_insert Term ON
insert into Term
(
TermID, TermCode, TermName, CalendarYear, AcademicYear
)
Select 
	TermID, 
	TermCode, 
	TermName, 
	CalendarYear, 
	AcademicYear
From LSP_data.dbo.Terms15
Union
Select
	TermID, 
	TermCode, 
	TermName, 
	CalendarYear, 
	AcademicYear
From LSP_data.dbo.Terms19
Set identity_insert Term OFF

--Select *
--FROM Term

---------------------------------------------------------------------------------------------------------

Set identity_insert Person ON
insert into Person
(
PersonID, LastName, FirstName, MiddleName, Gender, Phone, Email
)
Select 
	PersonID, 
	LastName, 
	FirstName, 
	MiddleName, 
	Gender, 
	Phone, 
	Email
From LSP_data.dbo.Persons15
Union
Select 
	PersonID, 
	LastName, 
	FirstName, 
	MiddleName, 
	Gender, 
	Phone, 
	Email
From LSP_data.dbo.Persons19
Set identity_insert Person OFF

--Select *
--FROM Person

---------------------------------------------------------------------------------------------------------

Insert into Course
(
CourseCode, CourseTitle, TotalWeeks, TotalHours, FullCourseFee, CourseDescription
)
Select 
	CourseCode, 
	CourseTitle, 
	TotalWeeks, 
	TotalHours, 
	FullCourseFee, 
	CourseDescription
From LSP_data.dbo.Courses15
Union
Select  
	CourseCode, 
	CourseTitle, 
	TotalWeeks, 
	TotalHours, 
	FullCourseFee, 
	CourseDescription
From LSP_data.dbo.Courses19

--Select *
--FROM Course

---------------------------------------------------------------------------------------------------------

insert into Faculty
(
FacultyFirstName, FacultyLastName, FacultyEmail, PrimaryPhone, AlternatePhone, FacultyAddressLine, FacultyCity, FacultyState, FacultyPostalCode
)
Select
	FacultyFirstName, 
	FacultyLastName, 
	FacultyEmail, 
	PrimaryPhone, 
	AlternatePhone, 
	FacultyAddressLine, 
	FacultyCity, 
	FacultyState, 
	FacultyPostalCode
From LSP_data.dbo.Faculty15
Union
Select
	FacultyFirstName, 
	FacultyLastName, 
	FacultyEmail, 
	PrimaryPhone, 
	AlternatePhone, 
	FacultyAddressLine, 
	FacultyCity, 
	FacultyState, 
	FacultyPostalCode
From LSP_data.dbo.Faculty19

--Select *
--FROM Faculty

-------------------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!---------------------------------------------

Set identity_insert Section ON
Insert into Section
(
SectionID, CourseID, TermID, StartDate, EndDate, [Days], SectionStatus, RoomID
)

SELECT z.SectionID, z.CourseID, z.TermID, z.StartDate, z.EndDate, z.[Days], z.SectionStatus, z.RoomID
FROM
(Select 
	SectionID,
	C.CourseID, 
	TermID, 
	StartDate, 
	EndDate, 
	[Days],
	SectionStatus, 
	R.RoomID
from LSP_data.dbo.[Sections SU11-SU15] S
Left Join Rooms R ON R.RoomName = S.RoomName
Left Join 
(select i.CourseID, i.CourseCode,
ROW_NUMBER() OVER(PARTITION BY CourseCode ORDER BY CourseID ) as row
from Course i
) C
ON C.CourseCode = S.CourseCode 
where c.row = 1) z

UNION 

SELECT x.SectionID, x.CourseID, x.TermID, x.StartDate, x.EndDate, x.[Days], x.SectionStatus, x.RoomID
FROM
(Select 
	F.SectionID,
	C.CourseID, 
	TermID, 
	StartDate, 
	EndDate, 
	[Days],
	SectionStatus, 
	R.RoomID
from LSP_data.dbo.[Sections FA15-SU19] f
Left Join Rooms R ON R.RoomName = F.RoomName
Left Join 
(select i.CourseID, i.CourseCode,
ROW_NUMBER() OVER(PARTITION BY CourseCode ORDER BY CourseID ) as row
from Course i
) C
ON C.CourseCode = f.CourseCode 
where c.row = 1) x
Set identity_insert Section OFF

--Select *
--FROM Section

---------------------------------------------------------------------------------------------------------

Insert into FacultyPayment
(
FacultyID, SectionID, PrimaryInstructor, PaymentAmount
)
Select 
	F.FacultyID,
	S.SectionID,
	'Y',
	S.PrimaryPayment
From LSP_data.dbo.[Sections SU11-SU15] S
Join Faculty F ON CONCAT(LEFT(FacultyFirstName,1),'. ', FacultyLastName) = S.PrimaryInstructor

Union

Select 
	F.FacultyID,
	S.SectionID,
	'Y',
	S.PrimaryPayment
From LSP_data.dbo.[Sections FA15-SU19] S
Join Faculty F ON CONCAT(LEFT(FacultyFirstName,1),'. ', FacultyLastName) = S.PrimaryInstructor

Union

Select 
	F.FacultyID,
	S.SectionID,
	'N',
	S.SecondaryPayment
From LSP_data.dbo.[Sections SU11-SU15] S
Join Faculty F ON CONCAT(LEFT(FacultyFirstName,1),'. ', FacultyLastName) = S.SecondaryInstructor

Union

Select 
	F.FacultyID,
	S.SectionID,
	'N',
	S.SecondaryPayment
From LSP_data.dbo.[Sections FA15-SU19] S
Join Faculty F ON CONCAT(LEFT(FacultyFirstName,1),'. ', FacultyLastName) = S.SecondaryInstructor

--Select *
--From FacultyPayment

---------------------------------------------------------------------------------------------------------

insert Into Address
(
AddressType, AddressLine, City, State, PostalCode, Country, PersonID
)
Select
	'Home',
	AddressLine,
	City, 
	State, 
	PostalCode, 
	Null, 
	PersonID
From LSP_data.dbo.Persons15
Union
Select
	'Home',
	AddressLine,
	City, 
	State, 
	PostalCode, 
	Null, 
	PersonID
From LSP_data.dbo.Persons19
Where AddressLine IS NOT NULL

Select *
From Address

---------------------------------------------------------------------------------------------------------

insert into ClassList
(
SectionID, PersonID, Grade, EnrollmentStatus, TuitionAmount
)
Select 
	SectionID, 
	PersonID, 
	Grade, 
	EnrollmentStatus, 
	TuitionAmount
From LSP_data.dbo.[Classlist SU11-SU15]
Union
Select 
	SectionID, 
	PersonID, 
	Grade, 
	EnrollmentStatus, 
	TuitionAmount
From LSP_data.dbo.[ClassList FA15-SU19]

--Select *
--FROM ClassList


/*************************************************************************************************** 
Answer Questions
***************************************************************************************************/ 

Go
Create View View_CourseRevenue 
AS
Select
	C.CourseCode,
	C.CourseTitle,
	Count(Distinct S.SectionID) As SectionCount,
	Sum(L.TuitionAmount) As TotalRevenue,
	CAST(Sum(L.TuitionAmount)/CAST(COUNT(S.SectionID) AS numeric) AS numeric(9,2)) AS AverageRevenue

From Course C
Left Join Section S
	On S.CourseID = C.CourseID AND S.SectionStatus != 'CN'
Left Join ClassList L 
	ON L.SectionID = S.SectionID
Group By C.CourseCode, c.CourseTitle

--Select * FROM View_CourseRevenue ORDER BY CourseCode

---------------------------------------------------------------------------------------------------------

Go
Create View View_AnnualRevenue
As
WITH CTE_AnnualRevenue AS
(
Select
	S.SectionID,
	Sum(L.TuitionAmount) AS TotalTuition
From Section S
Join ClassList L 
	On L.SectionID = S.SectionID
Group By S.SectionID
)
Select
	T.AcademicYear,
	Sum(CTE_AnnualRevenue.TotalTuition) AS TotalTuition,
	Sum(FP.PaymentAmount) As TotalFacultyPayment
From Course C
Join Section S 
	On S.CourseID = C.CourseID
Join Term T 
	On T.TermID = S.TermID
Left Join FacultyPayment FP 
	On FP.SectionID = S.SectionID
Left Join CTE_AnnualRevenue
	ON CTE_AnnualRevenue.SectionID = S.SectionID
Group By T.AcademicYear

--Select * FRom View_AnnualRevenue ORDER BY AcademicYear

---------------------------------------------------------------------------------------------------------

Go
Create PROC Proc_StudentHistory @PersonID int
As
Select
	CONCAT(P.FirstName,' ', P.LastName) AS StudentName,
	S.SectionID,
	C.CourseCode,
	C.CourseTitle,
	CONCAT(F.FacultyFirstName,' ', F.FacultyLastName) AS FacultyName,
	T.TermCode,
	S.StartDate,
	L.TuitionAmount,
	L.Grade
From Person P
Join ClassList L
	On L.PersonID = P.PersonID
Join Section S
	On S.SectionID = L.SectionID
Join Term T
	ON T.TermID = S.TermID
Join Course C
	ON C.CourseID = S.CourseID
Join FacultyPayment FP
	ON FP.SectionID = S.SectionID AND FP.PrimaryInstructor = 'Y'
Join Faculty F 
	ON F.FacultyID = FP.FacultyID
Where P.PersonID = @PersonID
Order By StartDate

--Exec Proc_StudentHistory 1400

---------------------------------------------------------------------------------------------------------

Go
Create Proc Proc_InsertPerson
	@FirstName varchar(35),
	@LastName varchar(50),
	@AddressType varchar(10),
	@AddressLine varchar(50),
	@City varchar(25)
AS
Create Table #Person(PersonID int)
Insert into Person (FirstName, LastName)
OutPut inserted.PersonID Into #Person
Values (@FirstName, @LastName)

Insert Into Address (AddressType, AddressLine, City, PersonID)
Select 
	@AddressType,
	@AddressLine,
	@City,
	#Person.PersonID
From #Person

--Exec Proc_InsertPerson 'Danyl', 'Kuzmychov', 'Home', '500 Elm St.', 'San Diego'

--Select Top 1 * From Person ORder By PersonID Desc
--Select Top 1 * From Address ORder By AddressID Desc

/*************************************************************************************************** 
Question Output
***************************************************************************************************/ 

Select * FROM View_CourseRevenue ORDER BY CourseCode

Select * FRom View_AnnualRevenue ORDER BY AcademicYear

Exec Proc_StudentHistory 1400

Exec Proc_InsertPerson 'Danyl', 'Kuzmychov', 'Home', '500 Elm St.', 'San Diego'

Select Top 1 * From Person ORder By PersonID Desc
Select Top 1 * From Address ORder By AddressID Desc