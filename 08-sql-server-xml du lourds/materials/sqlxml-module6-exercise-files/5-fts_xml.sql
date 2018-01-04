
CREATE DATABASE FTSDemo
GO

USE FTSDemo
GO

CREATE TABLE ftsxml (
   fileId int identity primary key,
   xdoc XML NULL
      constraint UQ_iFTSDemo_fileId UNIQUE (fileId)
)
GO

INSERT FTSXML VALUES('
<book>
  <title>Sample Book Title</title>
  <author>John Smith</author>
  <chapter ID="1">
     <title>Chapter 1</title>
     <content>
"The quick brown fox jumps over the lazy dog" is an English-language pangram (a phrase that contains all of the letters of the alphabet). It has been used to test typewriters and computer keyboards, and in other applications involving all of the letters in the English alphabet. Owing to its shortness and coherence, it has become widely known and is often used in visual arts.
	</content>
  </chapter>	
  <chapter ID="2">
     <title>Chapter 2</title>
     <content>
Close variations are often created when the phrase is used in the arts. In the card game Magic: The Gathering, a "joke card" from the Unhinged series was created with a game-related variation of the phrase, "The quick onyx goblin jumps over the lazy dwarf." In the Peanuts comic strip for May 27, 1974, Snoopy, having been entrusted by Lucy to ghostwrite her a biography of Ludwig van Beethoven, only writes on his typewriter "The quick brown fox jumps over the unfortunate dog" because that phrase was all he ever learned to type
	</content>
  </chapter>	 
</book>'
)   


INSERT FTSXML VALUES('
<book>
  <title>Another Sample Book</title>
  <author>Jane Doe</author>
  <chapter ID="1">
     <title>Chapter 1</title>
	<content>
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
	</content>
  </chapter>	
  <chapter ID="2">
     <title>Chapter 2</title>
     <content>
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.
	</content>
  </chapter>	 
</book>'
)  

INSERT FTSXML VALUES('
<book>
  <title>Final Sample Book</title>
  <author>Jim Jones</author>
  <chapter ID="1">
     <title>Chapter 1</title>
	<content>
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
	</content>
  </chapter>	
  <chapter ID="2">
     <title>Chapter 2</title>
     <content>
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.
	</content>
  </chapter>	 
</book>'
)  
GO

create fulltext catalog FTCatalog 
GO

CREATE FULLTEXT INDEX ON ftsxml( [xdoc] )
KEY INDEX [UQ_iFTSDemo_fileId]ON ([FTCatalog], FILEGROUP [PRIMARY])
GO


-- select values from XML
SELECT T.xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM
  -- after using FTS to select rows	
  (SELECT * FROM ftsxml 
     WHERE CONTAINS(xdoc, ' "Quick Brown Fox "')) 
   AS T
GO

-- FTS' XML IFilter only indexes text, not tags
SELECT T.xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM
  -- after using FTS to select rows	
  (SELECT * FROM ftsxml 
     WHERE CONTAINS(xdoc, ' "Author"')) 
   AS T
GO

-- can look for forms of the phrase
SELECT T.xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM
  -- after using FTS to select rows	
  (SELECT * FROM ftsxml 
     WHERE CONTAINS(xdoc, ' FORMSOF (INFLECTIONAL, "quick brown foxes jumped") ')) 
   AS T
GO

SELECT T.xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM
  -- after using FTS to select rows	
  (SELECT * FROM ftsxml 
     WHERE CONTAINS(xdoc, ' quick NEAR fox ')) 
   AS T
GO

-- XQuery contains is case-sensitive string compare, requires exact match
SELECT xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM ftsxml
WHERE xdoc.exist('/book/chapter/content[contains(., "Quick Brown Fox")]')=1

-- this works
SELECT xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM ftsxml
WHERE xdoc.exist('/book/chapter/content[contains(., "quick brown fox")]')=1

-- compare to FTS version
SELECT T.xdoc.value('(/book/title)[1]', 'varchar(100)') as title
  FROM
  -- after using FTS to select rows	
  (SELECT * FROM ftsxml 
     WHERE CONTAINS(xdoc, ' "Quick Brown Fox "')) 
   AS T
GO

-- cleanup
drop database ftsdemo

