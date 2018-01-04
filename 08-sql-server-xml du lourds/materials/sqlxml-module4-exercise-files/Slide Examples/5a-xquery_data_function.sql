
/*
Using the data() function in XQuery 

If you want the atomic value of an 
attribute, rather than the attribute node itself, data() is your friend. 
data() makes an atomic value from any XQuery item, but with attribute 
nodes it's particularly useful. SQL Server's XQuery functions don't 
allow returning bare attributes at the root level (bare text nodes are allowed), 
and the value function is always looking for a singleton atomic value. 
The data() function helps in these situations; here's an example:
*/

declare @x xml
set @x = '<foo bar="baz"/>'
-- returns error: "Attribute may not appear outside of an element"
select @x.query('/foo/@bar')


declare @x xml
set @x = '<foo bar="baz"/>'
-- returns baz
select @x.query('data(/foo/@bar)')

/*
Using the data() function is different from using the string() function. 
data() takes a sequence of items (nodes or atomic values) and 
atomizes them, ie. returns a sequence of atomic values. 
string() returns the string value of a single item.  

Here's an example comparing data() to string():
*/

declare @x xml 
-- XML fragment
set @x = '<x>hello<y>world</y></x><x>again</x>'
select @x.query('data(/*)')

--returns a sequence of two string values:
--helloworld again


declare @x xml 
-- XML fragment
set @x = '<x>hello<y>world</y></x><x>again</x>'
select @x.query('string(/*)')

/*
returns a static typing error, because string() requires a singleton 
or empty sequence as input
*/

declare @x xml 
-- XML fragment
set @x = '<x>hello<y>world</y></x><x>again</x>'
select @x.query('string(/*[1])')

--returns a single string value:
--helloworld

/* used with the document node (/), returns a concatenation of all text nodes */
declare @x xml 
-- XML fragment
set @x = '<x>hello<y>world</y></x><x>again</x>'
select @x.query('string(/)')

--returns a single string value:
--helloworldagain