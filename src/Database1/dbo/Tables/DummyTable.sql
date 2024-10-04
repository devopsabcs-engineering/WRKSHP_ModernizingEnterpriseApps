CREATE TABLE [dbo].[DummyTable] (
    [id]   INT           IDENTITY (1, 1) NOT NULL,
    [name] NVARCHAR (50) NULL,
    CONSTRAINT [PK_DummyTable] PRIMARY KEY CLUSTERED ([id] ASC)
);

