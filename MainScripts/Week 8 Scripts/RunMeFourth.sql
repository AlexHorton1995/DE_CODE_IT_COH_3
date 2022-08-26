/* 
	Run Me Fourth - This will create a new schema in which you will insert customer rows in the next step.
*/

USE [pubs]
GO

/****** Object:  Table [dbo].[titles]    Script Date: 8/25/2022 9:21:16 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[customers]') AND type in (N'U'))
DROP TABLE [dbo].[customers]
GO

/****** Object:  Table [dbo].[customers]    Script Date: 8/25/2022 9:21:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[customers](
	[cust_id] [int] IDENTITY(1,1) NOT NULL,
	[ord_num] [varchar](20) NOT NULL,
	[stor_id] [char](4)	NOT NULL,
	[ord_date] [datetime] NOT NULL,
	[title_id] [varchar](6) NOT NULL,
	[cust_fname] [varchar](30) NOT NULL,
	[cust_lname] [varchar](30) NOT NULL,
	[cust_add1]	[varchar](50) NOT NULL,
	[cust_add2]	[varchar](50) NULL,
	[cust_city] [varchar](23) NOT NULL,
	[cust_state] [char](2) NOT NULL,
	[cust_zip] [char](5) NOT NULL,
	[cust_phone] [varchar](12) NULL,
	[cust_email] [varchar](50) NULL
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED 
(
	[cust_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[customers]  WITH CHECK ADD FOREIGN KEY([title_id])
	REFERENCES [dbo].[titles] ([title_id])
GO

ALTER TABLE [dbo].[customers]  WITH CHECK ADD FOREIGN KEY([stor_id],[ord_num],[title_id])
	REFERENCES [dbo].[sales] ([stor_id],[ord_num],[title_id])
GO



