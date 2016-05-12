-- Use text editor to Find/Replace $DB_NAME !!!
-- Use text editor to Find/Replace $SCHEMA_NAME !!!

USE $DB_NAME

GO

CREATE SCHEMA $SCHEMA_NAME

CREATE TABLE [$SCHEMA_NAME].[Event] (
    [EventId]              BIGINT        IDENTITY (1, 1) NOT NULL,
    [EventData]            VARCHAR (MAX) NULL,
    [TopicData]            VARCHAR (MAX) NOT NULL,
    [TopicCount]           INT           NOT NULL,
    [CreatedByHostName]      VARCHAR (100) DEFAULT (host_name()) NULL,
    [CreateDate]           DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]        VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication] VARCHAR (100) DEFAULT ('System') NOT NULL,
    CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED ([EventId] ASC) 
);


GO
CREATE NONCLUSTERED INDEX [IX_Event_CreateDate]
    ON [$SCHEMA_NAME].[Event]([CreateDate] ASC) 

GO

CREATE TABLE [$SCHEMA_NAME].[EventMutex](
    [EventMutexId] [bigint] IDENTITY(1,1) NOT NULL,
    [Key] [varchar](100) NOT NULL,
    [Hash] VARBINARY(64) NOT NULL,
    [Expiration] DATETIME NOT NULL,
    [CreatedByHostName] [varchar](100) DEFAULT (host_name()) NULL,
    [CreateDate] [datetime] DEFAULT (getdate()) NOT NULL,
    [CreatedByUser] [varchar](100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication] [varchar](100) DEFAULT (APP_NAME()) NOT NULL,
    CONSTRAINT [PK_EventMutex] PRIMARY KEY CLUSTERED 
    (
        [EventMutexId] ASC
    ) 
)
GO
CREATE NONCLUSTERED INDEX [IX_EventMutex_Hash_Expiration] ON [$SCHEMA_NAME].[EventMutex]([Hash],[Expiration]) 
GO

CREATE TABLE [$SCHEMA_NAME].[EventMutexReleased](
    [EventMutexReleasedId] [bigint] IDENTITY(1,1) NOT NULL,
    [EventMutexId] [bigint] NOT NULL,
    [CreatedByHostName] [varchar](100) DEFAULT (host_name()) NULL,
    [CreateDate] [datetime] DEFAULT (getdate()) NOT NULL,
    [CreatedByUser] [varchar](100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication] [varchar](100) DEFAULT (APP_NAME()) NOT NULL,
    CONSTRAINT [PK_EventMutexReleased] PRIMARY KEY CLUSTERED 
    (
        [EventMutexReleasedId] ASC
    ) 
)
GO
ALTER TABLE [$SCHEMA_NAME].[EventMutexReleased] ADD CONSTRAINT [FK_EventMutexRelease_EventMutex] 
FOREIGN KEY ([EventMutexId])
REFERENCES [$SCHEMA_NAME].[EventMutex]([EventMutexId])
GO
CREATE NONCLUSTERED INDEX [IX_EventMutexReleased_EventMutexId] ON [$SCHEMA_NAME].[EventMutexReleased]([EventMutexId])
GO

GO



CREATE TABLE [$SCHEMA_NAME].[EventTopic] (
    [EventTopicId]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [EventId]              BIGINT        NOT NULL,
    [Key]                  VARCHAR (100) NOT NULL,
    [Value]                VARCHAR (150) NOT NULL,
    [CreatedByHostName]      VARCHAR (100) DEFAULT (host_name()) NULL,
    [CreateDate]           DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]        VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication] VARCHAR (100) DEFAULT ('System') NOT NULL,
    CONSTRAINT [PK_EventTopic] PRIMARY KEY CLUSTERED ([EventTopicId] ASC),
    CONSTRAINT [FK_EventTopic_Event] FOREIGN KEY ([EventId]) REFERENCES [$SCHEMA_NAME].[Event] ([EventId])
);


GO
CREATE NONCLUSTERED INDEX [IX_EventTopic_Value]
    ON [$SCHEMA_NAME].[EventTopic]([Value] ASC)


GO
CREATE NONCLUSTERED INDEX [IX_EventTopic_Key]
    ON [$SCHEMA_NAME].[EventTopic]([Key] ASC)


GO
CREATE NONCLUSTERED INDEX [IX_EventTopic_EventId]
    ON [$SCHEMA_NAME].[EventTopic]([EventId] ASC)

GO

CREATE TABLE [$SCHEMA_NAME].[Subscription] (
    [SubscriptionId]                INT           IDENTITY (1, 1) NOT NULL,
    [CurrentSubscriptionRevisionId] INT           NOT NULL,
    [CreatedByHostName]               VARCHAR (100) DEFAULT (host_name()) NULL,
    [CreateDate]                    DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]                 VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication]          VARCHAR (100) DEFAULT ('System') NOT NULL,
    CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED ([SubscriptionId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Subscription_CurrentSubscriptionRevisionId]
    ON [$SCHEMA_NAME].[Subscription]([CurrentSubscriptionRevisionId] ASC)

GO

CREATE TABLE [$SCHEMA_NAME].[SubscriptionRevision] (
    [SubscriptionRevisionId]  INT            IDENTITY (1, 1) NOT NULL,
    [SubscriptionId]          INT            NOT NULL,
    [SubscriptionName]		  VARCHAR(100)	 NOT NULL,
    [SubscriptionStatusCode]  VARCHAR (20)   NOT NULL,
    [ServiceEndpoint]         VARCHAR (1000) NOT NULL,
    [ServiceTypeCode]         VARCHAR (100)  NOT NULL,
    [HTTPMethod]              VARCHAR (10)   NOT NULL,
    [TransformFunction]       VARCHAR (MAX)  NULL,
    [AbortAfterMinutes]       INT            NOT NULL,
    [EscalationConfiguration] VARCHAR (MAX)  NULL,
    [CreatedByHostName]         VARCHAR (100)  DEFAULT (host_name()) NULL,
    [CreateDate]              DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]           VARCHAR (100)  DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication]    VARCHAR (100)  DEFAULT ('System') NOT NULL,
	[RequestType]             VARCHAR (15)   NULL,
    CONSTRAINT [PK_SubscriptionRevision] PRIMARY KEY CLUSTERED ([SubscriptionRevisionId] ASC) ,
    CONSTRAINT [FK_SubscriptionRevision_Subscription] FOREIGN KEY ([SubscriptionId]) REFERENCES [$SCHEMA_NAME].[Subscription] ([SubscriptionId])
);


GO
CREATE NONCLUSTERED INDEX [IX_SubscriptionRevision_SubscriptionId]
    ON [$SCHEMA_NAME].[SubscriptionRevision]([SubscriptionId] ASC) 

GO


CREATE TABLE [$SCHEMA_NAME].[SubscriptionTopic] (
    [SubscriptionTopicId]    INT           IDENTITY (1, 1) NOT NULL,
    [SubscriptionRevisionId] INT           NOT NULL,
    [Key]                    VARCHAR (100) NOT NULL,
    [Value]                  VARCHAR (100) NOT NULL,
    [OperatorTypeCode]       VARCHAR (100) NOT NULL,
    [CreatedByHostName]        VARCHAR (100) DEFAULT (host_name()) NOT NULL,
    [CreateDate]             DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]          VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication]   VARCHAR (100) DEFAULT ('System') NOT NULL,
    CONSTRAINT [PK_SubscriptionTopicId] PRIMARY KEY CLUSTERED ([SubscriptionTopicId] ASC),
    CONSTRAINT [FK_SubscriptionTopic_SubscriptionRevision] FOREIGN KEY ([SubscriptionRevisionId]) REFERENCES [$SCHEMA_NAME].[SubscriptionRevision] ([SubscriptionRevisionId])
);


GO
CREATE NONCLUSTERED INDEX [IX_SubscriptionTopic_Value]
    ON [$SCHEMA_NAME].[SubscriptionTopic]([Value] ASC)


GO
CREATE NONCLUSTERED INDEX [IX_SubscriptionTopic_SubscriptionRevisionId]
    ON [$SCHEMA_NAME].[SubscriptionTopic]([SubscriptionRevisionId] ASC)


GO
CREATE NONCLUSTERED INDEX [IX_SubscriptionTopic_Key]
    ON [$SCHEMA_NAME].[SubscriptionTopic]([Key] ASC)


GO

CREATE TABLE [$SCHEMA_NAME].[EventSubscription] (
    [EventSubscriptionId]  BIGINT        IDENTITY (1, 1) NOT NULL,
    [EventId]              BIGINT        NOT NULL,
    [SubscriptionId]       INT           NOT NULL,
    [CreatedByHostName]      VARCHAR (100) DEFAULT (host_name()) NULL,
    [CreateDate]           DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]        VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication] VARCHAR (100) DEFAULT ('System') NOT NULL,
    CONSTRAINT [PK_EventSubscription] PRIMARY KEY CLUSTERED ([EventSubscriptionId] ASC) ,
    CONSTRAINT [FK_EventSubscription_Event] FOREIGN KEY ([EventId]) REFERENCES [$SCHEMA_NAME].[Event] ([EventId]),
    CONSTRAINT [FK_EventSubscription_Subscription] FOREIGN KEY ([SubscriptionId]) REFERENCES [$SCHEMA_NAME].[Subscription] ([SubscriptionId])
);


GO
CREATE NONCLUSTERED INDEX [IX_EventSubscription_SubscriptionId]
    ON [$SCHEMA_NAME].[EventSubscription]([SubscriptionId] ASC) 


GO
CREATE NONCLUSTERED INDEX [IX_EventSubscription_EventId]
    ON [$SCHEMA_NAME].[EventSubscription]([EventId] ASC) 

GO

CREATE TABLE [$SCHEMA_NAME].[EventSubscriptionActivity] (
    [EventSubscriptionActivityId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [ActivityTypeCode]            VARCHAR (100) NOT NULL,
    [EventId]                     BIGINT        NOT NULL,
    [EventSubscriptionId]         BIGINT        NULL,
    [Data]                        VARCHAR (MAX) NULL,
    [CreatedByHostName]             VARCHAR (100) DEFAULT (host_name()) NULL,
    [CreateDate]                  DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedByUser]               VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [CreatedByApplication]        VARCHAR (100) DEFAULT ('System') NOT NULL,
    CONSTRAINT [PK_EventSubscriptionActivity] PRIMARY KEY CLUSTERED ([EventSubscriptionActivityId] ASC) ,
    CONSTRAINT [FK_EventSubscriptionActivity_Event] FOREIGN KEY ([EventId]) REFERENCES [$SCHEMA_NAME].[Event] ([EventId]),
    CONSTRAINT [FK_EventSubscriptionActivity_EventSubscription] FOREIGN KEY ([EventSubscriptionId]) REFERENCES [$SCHEMA_NAME].[EventSubscription] ([EventSubscriptionId])
);


GO
CREATE NONCLUSTERED INDEX [IX_EventSubscriptionActivity_EventSubscriptionId]
    ON [$SCHEMA_NAME].[EventSubscriptionActivity]([EventSubscriptionId] ASC) 


GO
CREATE NONCLUSTERED INDEX [IX_EventSubscriptionActivity_EventId]
    ON [$SCHEMA_NAME].[EventSubscriptionActivity]([EventId] ASC) 


GO
CREATE NONCLUSTERED INDEX [IX_EventSubscriptionActivity_CreateDate]
    ON [$SCHEMA_NAME].[EventSubscriptionActivity]([CreateDate] ASC) 


GO
CREATE NONCLUSTERED INDEX [IX_EventSubscriptionActivity_ActivityTypeCode]
    ON [$SCHEMA_NAME].[EventSubscriptionActivity]([ActivityTypeCode] ASC) 

GO
