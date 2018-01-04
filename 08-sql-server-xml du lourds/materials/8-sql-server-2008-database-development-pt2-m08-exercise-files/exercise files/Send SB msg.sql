use veronicas;
go

DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
DECLARE @RequestMsg NVARCHAR(100);

BEGIN TRANSACTION;

BEGIN DIALOG @InitDlgHandle
     FROM SERVICE
      [//VVDB/MSGGrp/InitiatorService]
     TO SERVICE
      N'//VVDB/MSGGrp/TargetService'
     ON CONTRACT
      [//VVDB/MSGGrp/SampleContract]
     WITH
         ENCRYPTION = OFF;

SELECT @RequestMsg =
       N'<RequestMsg>Message for Target service.</RequestMsg>';

SEND ON CONVERSATION @InitDlgHandle
     MESSAGE TYPE 
     [//VVDB/MSGGrp/RequestMessage]
     (@RequestMsg);

SELECT @RequestMsg AS SentRequestMsg;

COMMIT TRANSACTION;
GO


DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
DECLARE @RecvReqMsg NVARCHAR(100);
DECLARE @RecvReqMsgName sysname;

BEGIN TRANSACTION;

WAITFOR
( RECEIVE TOP(1)
    @RecvReqDlgHandle = conversation_handle,
    @RecvReqMsg = message_body,
    @RecvReqMsgName = message_type_name
  FROM TargetQueue1DB
), TIMEOUT 1000;

SELECT @RecvReqMsg AS ReceivedRequestMsg;

IF @RecvReqMsgName =
   N'//VVDB/MSGGrp/RequestMessage'
BEGIN
     DECLARE @ReplyMsg NVARCHAR(100);
     SELECT @ReplyMsg =
     N'<ReplyMsg>Message for Initiator service.</ReplyMsg>';
 
     SEND ON CONVERSATION @RecvReqDlgHandle
          MESSAGE TYPE 
          [//VVDB/MSGGrp/ReplyMessage]
          (@ReplyMsg);

     END CONVERSATION @RecvReqDlgHandle;
END

SELECT @ReplyMsg AS SentReplyMsg;

COMMIT TRANSACTION;
GO

DECLARE @RecvReplyMsg NVARCHAR(100);
DECLARE @RecvReplyDlgHandle UNIQUEIDENTIFIER;

BEGIN TRANSACTION;

WAITFOR
( RECEIVE TOP(1)
    @RecvReplyDlgHandle = conversation_handle,
    @RecvReplyMsg = message_body
  FROM InitiatorQueue1DB
), TIMEOUT 1000;

END CONVERSATION @RecvReplyDlgHandle;

SELECT @RecvReplyMsg AS ReceivedReplyMsg;

COMMIT TRANSACTION;
GO