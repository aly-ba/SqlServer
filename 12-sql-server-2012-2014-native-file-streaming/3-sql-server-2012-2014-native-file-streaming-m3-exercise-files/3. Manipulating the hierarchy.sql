USE SampleDB
GO

-- GetReparentedValue... Wanda now reports to Jill and no longer to Amy
DECLARE @EmployeeNodeId  hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 389) -- Move Wanda
DECLARE @OldParentNodeId hierarchyid = @EmployeeNodeId.GetAncestor(1)                       --  from Amy
DECLARE @NewParentNodeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 119) --  to Jill

UPDATE Employee
 SET   NodeId = NodeId.GetReparentedValue(@OldParentNodeId, @NewParentNodeId)
 WHERE NodeId = @EmployeeNodeId

SELECT *, NodeId.ToString() AS NodeIdPath, dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM Employee
 ORDER BY NodeIdDisplayPath

GO

-- Move the entire subtree beneath Amy to a new location beneath Kevin
DECLARE @OldParentNodeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId =  46) -- Move Amy tree
DECLARE @NewParentNodeId hierarchyid = (SELECT NodeId FROM Employee WHERE EmployeeId = 291) --  beneath Kevin

UPDATE Employee
 SET   NodeId = NodeId.GetReparentedValue(@OldParentNodeId, @NewParentNodeId)
 WHERE NodeId.IsDescendantOf(@OldParentNodeId) = 1 AND NodeId <> @OldParentNodeId -- Excludes Amy herself

SELECT *, NodeId.ToString() AS NodeIdPath, dbo.fnGetFullDisplayPath(NodeId) AS NodeIdDisplayPath
 FROM Employee
 ORDER BY NodeIdDisplayPath

GO
