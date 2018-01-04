CREATE DATABASE SampleDB
GO

USE SampleDB
GO

/*
	Sample Hierarchy 
	================

                                 Dave-6
                                    |
                   +----------------+---------------+
                   |                |               |
                Amy-46          John-271        Jill-119
                   |                |               |
              +----+----+           |               |
              |         |           |               |
         Cheryl-269  Wanda-389  Mary-272        Kevin-291
              |
         +----+----+
         |         |
    Richard-87   Jeff-90
*/

-- Create hierarchical table with a depth-first index
CREATE TABLE Employee
(
   NodeId        hierarchyid PRIMARY KEY CLUSTERED,
   NodeLevel     AS NodeId.GetLevel(),
   EmployeeId    int UNIQUE NOT NULL,
   EmployeeName  varchar(20) NOT NULL,
   Title         varchar(20) NULL
)
GO

-- Insert root node
INSERT INTO Employee
  (NodeId, EmployeeId, EmployeeName, Title)
 VALUES
  (hierarchyid::GetRoot(), 6, 'Dave', 'CEO') ;

SELECT * FROM Employee
GO

-- Insert Amy as the first child beneath Dave
DECLARE @ParentEmployeeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 6)

INSERT INTO Employee(NodeId, EmployeeId, EmployeeName, Title)
 VALUES(@ParentEmployeeId.GetDescendant(NULL, NULL), 46, 'Amy', 'Marketing Specialist')

SELECT NodeId.ToString() AS NodeIdPath, * FROM Employee
GO

-- Create stored proc to simplify insertions
CREATE PROC uspAddEmployee(
	@ParentEmployeeId int,
	@EmployeeId int,
	@EmployeeName varchar(20),
	@Title varchar(20)) 
 AS 
BEGIN
	-- Get the hierarchyid of the parent employee
	DECLARE @ParentEmployeeNodeId hierarchyid =
	 (SELECT NodeId FROM Employee WHERE EmployeeId = @ParentEmployeeId)

	-- Get the hierarchyid of the last existing child beneath the parent
	DECLARE @LastChildNodeId hierarchyid =
	 (SELECT MAX(NodeId) FROM Employee WHERE NodeId.GetAncestor(1) = @ParentEmployeeNodeId)

	-- Construct a new hierarchyid positioned at the end of any existing children
	DECLARE @EmployeeNodeId hierarchyid = @ParentEmployeeNodeId.GetDescendant(@LastChildNodeId, NULL)

	-- Add the row
	INSERT INTO Employee(NodeId, EmployeeId, EmployeeName, Title)
	 VALUES(@EmployeeNodeId, @EmployeeId, @EmployeeName, @Title)
END

GO

-- Add the remaining employees
EXEC uspAddEmployee 6, 271, 'John', 'Marketing Specialist'
EXEC uspAddEmployee 6, 119, 'Jill', 'Marketing Specialist'
EXEC uspAddEmployee 46, 269, 'Cheryl', 'Marketing Assistant'
EXEC uspAddEmployee 46, 389, 'Wanda', 'Business Assistant'
EXEC uspAddEmployee 271, 272, 'Mary', 'Marketing Assistant'
EXEC uspAddEmployee 119, 291, 'Kevin', 'Marketing Intern'
EXEC uspAddEmployee 269, 87, 'Richard', 'Business Intern'
EXEC uspAddEmployee 269, 90, 'Jeff', 'Business Intern'

SELECT NodeId.ToString() AS NodeIdPath, * 
 FROM Employee
 ORDER BY NodeId.ToString()

GO

-- Create a UDF to return the full display path of a node
CREATE FUNCTION dbo.fnGetFullDisplayPath(@EmployeeNodeId hierarchyid) RETURNS varchar(max) 
 AS 
BEGIN
    -- Start with the specified node
	DECLARE @Depth smallint
	DECLARE @DisplayPath varchar(max)
	SELECT @Depth = NodeId.GetLevel(), @DisplayPath = EmployeeName
	 FROM Employee
	 WHERE NodeId = @EmployeeNodeId
 
    -- Loop through all its ancestors
	DECLARE @LevelCounter smallint = 0
	WHILE @LevelCounter < @Depth BEGIN
		SET @LevelCounter += 1

		-- Get parent node ID
		DECLARE @ParentEmployeeNodeId hierarchyid =
		 (SELECT NodeId.GetAncestor(@LevelCounter) FROM Employee WHERE NodeId = @EmployeeNodeId)

		-- Get parent name
		DECLARE @ParentEmployeeName varchar(max) =
		 (SELECT EmployeeName FROM Employee WHERE NodeId = @ParentEmployeeNodeId)

		-- Prepend to display path
		SET @DisplayPath = @ParentEmployeeName + ' > ' + @DisplayPath
	END
 
	RETURN(@DisplayPath)
END 
GO

SELECT
	*,
	NodeId.ToString() AS NodeIdPath,
	dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM
	Employee
 ORDER BY
	NodeIdDisplayPath
GO

-- Create a breadth-first index
CREATE UNIQUE INDEX IX_EmployeeBreadth
 ON Employee(NodeLevel, NodeId)

GO
