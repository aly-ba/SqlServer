use master;
go

alter database veronicas
set enable_broker;
go

use veronicas;
go

--Create the message types
CREATE MESSAGE TYPE
       [//VVDB/MSGGrp/RequestMessage]
       VALIDATION = WELL_FORMED_XML;
CREATE MESSAGE TYPE
       [//VVDB/MSGGrp/ReplyMessage]
       VALIDATION = WELL_FORMED_XML;
GO


--Create the contract
CREATE CONTRACT [//VVDB/MSGGrp/SampleContract]
      ([//VVDB/MSGGrp/RequestMessage]
       SENT BY INITIATOR,
       [//VVDB/MSGGrp/ReplyMessage]
       SENT BY TARGET
      );
GO


--Create the target queue and service 
CREATE QUEUE TargetQueue1DB;

CREATE SERVICE
       [//VVDB/MSGGrp/TargetService]
       ON QUEUE TargetQueue1DB
       ([//VVDB/MSGGrp/SampleContract]);
GO


--Create the initiator queue and service 
CREATE QUEUE InitiatorQueue1DB;

CREATE SERVICE
       [//VVDB/MSGGrp/InitiatorService]
       ON QUEUE InitiatorQueue1DB;
GO