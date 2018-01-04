<Query Kind="Expression">
  <Connection>
    <ID>bb9a7cc9-acf3-4ef3-ada3-99149101aeaf</ID>
    <Persist>true</Persist>
    <Server>.</Server>
    <Database>AdventureWorks</Database>
  </Connection>
</Query>

from emp in Employees
from per in Contacts
where emp.ContactID==per.ContactID
orderby per.LastName, per.FirstName
select new {emp.EmployeeID, per.FirstName, per.LastName}
