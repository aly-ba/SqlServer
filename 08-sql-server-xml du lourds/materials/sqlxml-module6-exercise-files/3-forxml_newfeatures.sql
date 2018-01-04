USE pubs
GO

SELECT  authors.au_id, authors.au_lname, authors.au_fname, ta.royaltyper, titles.title_id, title
  FROM authors
  FULL OUTER JOIN titleauthor ta ON authors.au_id = ta.au_id
  FULL OUTER JOIN titles ON ta.title_id = titles.title_id

-- FOR XML RAW
-- FOR XML RAW, ELEMENTS
-- FOR XML RAW, ELEMENTS, ROOT('authors') 
-- FOR XML RAW('author') , ELEMENTS, ROOT('authors')
-- FOR XML RAW('author') , ELEMENTS XSINIL, ROOT('authors')
-- FOR XML RAW('author') , ELEMENTS XSINIL, ROOT('authors'), XMLSCHEMA('http://myauthors')

-- FOR XML AUTO
-- FOR XML AUTO, ELEMENTS
-- FOR XML AUTO, ELEMENTS, ROOT('authors') 
-- FOR XML AUTO, ELEMENTS, ROOT('authors')
-- FOR XML AUTO, ELEMENTS XSINIL, ROOT('authors')
FOR XML AUTO, ELEMENTS XSINIL, ROOT('authors'), XMLSCHEMA

WITH XMLNAMESPACES('urn:authors' AS au, 'urn:names' AS nm)
SELECT
  au_id as [@au:authorid],
  au_fname as [nm:name/firstname],
  au_lname as [nm:name/lastname]
-- FROM authors FOR XML PATH
-- FROM authors FOR XML PATH('author')
-- FROM authors FOR XML PATH('author'), ROOT('authors')
-- FROM authors FOR XML PATH('author'), ROOT('authors'), XMLSCHEMA -- NO
FROM authors FOR XML PATH('author'), ROOT('authors')


SELECT  authors.au_id, authors.au_lname, authors.au_fname, ta.royaltyper, titles.title_id, title
  FROM authors
  FULL OUTER JOIN titleauthor ta ON authors.au_id = ta.au_id
  FULL OUTER JOIN titles ON ta.title_id = titles.title_id
FOR XML RAW('author') , ELEMENTS, ROOT('authors'), TYPE

SELECT
(
SELECT  authors.au_id, authors.au_lname, authors.au_fname, ta.royaltyper, titles.title_id, title
  FROM authors
  FULL OUTER JOIN titleauthor ta ON authors.au_id = ta.au_id
  FULL OUTER JOIN titles ON ta.title_id = titles.title_id
FOR XML RAW('author') , ELEMENTS, ROOT('authors'), TYPE
).query('/authors/author[au_id > "5"]')

