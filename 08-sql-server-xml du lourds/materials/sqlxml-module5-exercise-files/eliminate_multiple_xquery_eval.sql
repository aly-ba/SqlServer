-- I have seen a few scenarios in which a value is extracted from an XML data type instance in SQL Server 2005. The query performs some checks on the value such as its type (e.g. whether it is numeric) or compares it with a constant, and returns a value based on this check. The value extraction is done using the value() method of XML data type, and the method is re-evaluated in the SELECT list. I want to share a simple tip for better performance. Consider the example 

DECLARE @x XML
SET   @x = '<book ISBN="0-7356-1588-2">
                  <title>Writing Secure Code</title>
                  <subject/>
                  <price>39.99</price>
            </book>'

-- The price of the book can be retrieved using the following query as nvarchar(32) if it is not known for sure that it is actually a numeric value in all <book> instances:

SELECT @x.value ('(/book/price)[1]', 'nvarchar(32)')  

-- Suppose the query then wants to convert it to a decimal value if it is numeric and return 0 if it is not. The full query then becomes:

SELECT case isnumeric(@x.value ('(/book/price)[1]', 'nvarchar(32)'))
       when 1 then @x.value ('(/book/price)[1]', 'decimal(5,2)')
              else 0
       end

-- This query computes the value() method twice. A simple trick avoids the recomputation by assigning the result of @x.value ('/book/price', 'nvarchar(32)') to a SQL variable of type nvarchar(32) and converting the variable to decimal:

DECLARE @v nvarchar(32)
SET   @v = (SELECT @x.value ('(/book/price)[1]', 'nvarchar(32)'))
SELECT case isnumeric(@v)
       when 1 then CAST (@v AS decimal(5,2))
              else 0
       end

-- The rewrite performs significantly faster than the earlier query since it manually optimizes the query to reuse computed values. It also simplifies the query plan quite a bit. There is an underlying assumption on its benefit– the majority of the <price> values are numeric, otherwise the workload does not perform much faster.

-- Often, there are many more values you want to extract for the XML instance, and breaking up the query into a separate one for each variable assignment is inconvenient. The query may also involve the nodes() method, so that breaking up the query increases the number of nodes() method invocations and requires table-valued variables - the benefits are then lost. A subquery comes to our rescue! Look at the following rewrite in which the value() method is computed in a subquery and aliased as T(Price) and reused in the outer SELECT:

SELECT case isnumeric(Price)
       when 1 then CAST (Price AS decimal(5,2))
              else 0
       end  
FROM  (SELECT @x.value ('(/book/price)[1]', 'nvarchar(32)') Price) T

-- You get the same benefits as before, ignoring the difference between the variable assignment and the subquery costs, which are much smaller than the cost of the value() method computation. The same optimization can be used in other places as well:

SELECT NULLIF (Subj, '')
FROM  (SELECT @x.value ('(/book/subject)[1]', 'nvarchar(64)') Subj) T
 
-- The value() method returns the empty string '' for subject, the NULLIF compares the returned value with its second argument '' and returns NULL since these two values are equal. Replacing Subj with the value() method in NULLIF (Subj, ''), as shown below, computes the value() method twice when the return value is other than the empty string. This double computation is much slower:

SELECT NULLIF (@x.value ('(/book/subject)[1]', 'nvarchar(64)'), '')

-- You get the idea. We can put the two queries together as follows:

SELECT case isnumeric(Price)
            when 1 then CAST (Price AS decimal(5,2))
              else 0
            end,
       NULLIF (Subj, '')
FROM  (SELECT @x.value ('(/book/price)[1]', 'nvarchar(32)') Price,
              @x.value ('(/book/subject)[1]', 'nvarchar(64)') Subj 
       ) T

-- You might wonder – why doesn’t the query optimizer do this trick? It certainly is an option and hey – if we did it all in one release, what would we do in the future? ;-)
