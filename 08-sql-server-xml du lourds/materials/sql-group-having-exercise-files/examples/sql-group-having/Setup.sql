

CREATE TABLE Franchisees
(
ID INT PRIMARY KEY,
Name NVARCHAR(40),
City NVARCHAR(40),
State VARCHAR(2)
);

CREATE TABLE Stores
(
ID INT PRIMARY KEY,
Franchisee INT,
Zipcode NVARCHAR(5),
[Years in Business] INT,
CONSTRAINT FranchiseeFK FOREIGN KEY (Franchisee) REFERENCES Franchisees(ID)
);

CREATE TABLE [Unified Receipts]
(
[Register ID] INT,
[Store ID] INT,
[Sequence] INT,
Amount MONEY,
Date DATE,
[Cashier ID] INT,
CONSTRAINT RegisterPK PRIMARY KEY ([Register ID],[Store ID],[Sequence]),
CONSTRAINT StoreFK FOREIGN KEY ([Store ID]) REFERENCES Stores(ID)
);



INSERT INTO Franchisees VALUES (301, 'Joe', 'Greenville', 'MD'),
(512, 'Jane', 'Orangetown', 'OH'),
(121, 'Jack', 'Burgerville', 'LA'),
(891, 'Jim', 'East Eden', 'CT'),
(2355, 'Tad', 'Blottingsworth', 'NM'),
(67, 'Tom', 'Upper Lower', 'MD');

-- now run the setupStores.sql and then the SetupRegisters.sql batch files
-- generators are in the GenerateRegisterReceipts C# project

