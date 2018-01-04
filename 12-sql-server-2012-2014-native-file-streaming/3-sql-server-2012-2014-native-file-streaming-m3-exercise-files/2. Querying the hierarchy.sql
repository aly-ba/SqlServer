USE SampleDB
GO

-- IsDescendantOfMethod... retrieve a subtree beginning with Amy
DECLARE @AmyNodeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 46)

SELECT *, NodeId.ToString() AS NodeIdPath, dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM Employee
 WHERE NodeId.IsDescendantOf(@AmyNodeId) = 1
 ORDER BY NodeIdDisplayPath

GO

-- GetAncestorMethod... retrieve Amy's direct children (1 level down)
DECLARE @AmyNodeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 46)

SELECT *, NodeId.ToString() AS NodeIdPath, dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM Employee
 WHERE NodeId.GetAncestor(1) = @AmyNodeId
 ORDER BY NodeIdDisplayPath

GO

-- GetAncestorMethod... retrieve Dave's grandchildren (2 levels down)
DECLARE @DaveNodeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 6)

SELECT *, NodeId.ToString() AS NodeIdPath, dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM  Employee
 WHERE NodeId.GetAncestor(2) = @DaveNodeId
 ORDER BY NodeIdDisplayPath

GO

-- GetRoot... retrieve the root node (Dave)
SELECT *, NodeId.ToString() AS NodeIdPath, dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM  Employee
 WHERE NodeId = hierarchyid::GetRoot()

GO
