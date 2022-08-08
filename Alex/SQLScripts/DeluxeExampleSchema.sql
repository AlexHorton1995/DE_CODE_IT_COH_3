USE [DeluxeExample]
GO

/* Tables */
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
	DROP TABLE [dbo].[Users]
GO

CREATE TABLE [dbo].[Users](
	[CompanyID] [int] NOT NULL,
	[BusinessDate] [date] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Salt] [varchar](10) NOT NULL,
	[PasswordEncrypted] [varbinary](MAX) NOT NULL,
	[AddedDate] [date] NULL,
	[AddedBy] [int] NULL,
	[ChangedDate] [date] NULL,
	[ChangedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC,
	[BusinessDate] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/******* Function Creates *******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GenerateSalt]'))
BEGIN
	DROP FUNCTION [dbo].[GenerateSalt]
END
GO

/****** Object:  UserDefinedFunction [dbo].[GenerateSalt]    Script Date: 8/5/2022 10:31:27 PM ******/
CREATE FUNCTION [dbo].[GenerateSalt](@NewID varchar(9))
RETURNS varchar(9)
AS
BEGIN
	RETURN ';' + SUBSTRING(CONVERT(VARCHAR(38),@NewID),0,9) 
END;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SaltPassword]'))
BEGIN
	DROP FUNCTION [dbo].[SaltPassword]
END
GO

/****** Object:  UserDefinedFunction [dbo].[SaltPassword]    Script Date: 8/5/2022 10:31:27 PM ******/
CREATE FUNCTION [dbo].[SaltPassword](@Password varchar(100), @Salt varchar(10))
RETURNS varbinary(max)
AS
BEGIN
	RETURN HASHBYTES('SHA2_512', CONCAT(@Password, @Salt))
END;
GO

/******* Stored Procedures *******/

/****** Object:  StoredProcedure [dbo].[sp_InsertNewUser]    Script Date: 8/5/2022 11:31:40 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_InsertNewUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
	DROP PROCEDURE [dbo].[sp_InsertNewUser]
END
GO

CREATE PROCEDURE [dbo].[sp_InsertNewUser]
	@UserName nvarchar(100), 
	@Password varchar(200),
	@BusinessDate char(8)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentUserCount int = 0;

	DECLARE @tempUsers TABLE
	(
		[CompanyID] [int] NOT NULL,
		[BusinessDate] [date] NOT NULL,
		[UserName] [nvarchar](100) NOT NULL,
		[Password] [varchar](200) NOT NULL,
		[AddedDate] [date] NULL,
		[AddedBy] [int] NULL,
		[ChangedDate] [date] NULL,
		[ChangedBy] [int] NULL
	)

		INSERT INTO @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy)
		VALUES(0, CONVERT(date, @BusinessDate, 101), @UserName, @Password, CONVERT(date, GETDATE(), 101), 1)

		INSERT INTO [dbo].[Users] (CompanyID, BusinessDate, UserName, Salt, PasswordEncrypted, AddedDate, AddedBy)
		SELECT T.CompanyID, CONVERT(DATE, T.BusinessDate, 101), T.UserName, LoadSalt, dbo.SaltPassword(t.Password, LoadSalt), t.AddedDate, t.AddedBy from @tempUsers T
		CROSS APPLY(
			select dbo.GenerateSalt(CONVERT(varchar(38), NEWID())) LoadSalt
		) Salty			
END
GO

/*
	******************** TEST DATA SECTION ******************** 
	In order, you want to do the following:
		1. Create the database, call it DeluxeExample
		2. Run this schema file
		3. Uncomment below to populate the table with data	
*/


/* put the -- at the beginning of the next line below to uncomment */
/*--

DECLARE @tempUsers TABLE(
	[CompanyID] [int] NOT NULL,
	[BusinessDate] [date] NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [varchar](200) NOT NULL,
	[AddedDate] [date] NULL,
	[AddedBy] [int] NULL,
	[ChangedDate] [date] NULL,
	[ChangedBy] [int] NULL
)

insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-29 08:41:09', 'ljoyes0@ftc.gov', 'wDPeTxAgU9Y', '5/28/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-22 12:31:13', 'rjoyce1@alibaba.com', 'ZsB7q2EnsuD', '11/22/2021', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-29 09:52:05', 'awestmerland2@wikipedia.org', 'HvsegaptwLZ', '7/16/2022', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-27 22:14:59', 'asherer3@imdb.com', '52Xte52GYr', '11/14/2021', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-18 19:32:56', 'oaries4@pagesperso-orange.fr', 'bxNJZlR5v9', '10/18/2021', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-29 23:46:02', 'grandell5@eventbrite.com', 'iyNAIgD', '10/7/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-07 19:14:41', 'miannazzi6@tamu.edu', 'nzYyRYt4', '5/30/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-03 00:09:56', 'tturbat7@ucoz.ru', 'n4a7yK7Vit', '1/23/2022', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-23 21:10:40', 'tridehalgh8@cdbaby.com', '8zP0BQkc4', '11/5/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-10 21:14:39', 'eslym9@diigo.com', 'vPZlhVJdG7GH', '2/16/2022', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-26 09:24:06', 'mgrestea@weibo.com', 'tW2VeJwB', '3/24/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-15 02:33:21', 'awoollacottb@wikispaces.com', 'aEpJ4nTPjEU', '3/4/2022', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-30 15:22:31', 'skippaxc@google.ca', 'xC5UrzhEw', '7/19/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-10 11:22:26', 'xfollacarod@mit.edu', 'Te8zcmW4Jl', '7/5/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-27 23:16:22', 'afeelye@epa.gov', 'gg6We19', '3/19/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-18 15:51:42', 'gjollissf@artisteer.com', 'LrBkZZfzpFIm', '2/27/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-14 03:20:42', 'bvandevliesg@ucoz.ru', 'iOLHzxheMAr2', '3/26/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-25 01:37:36', 'rviveashh@mashable.com', 'Z8EJQg', '3/1/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 01:59:17', 'msargei@go.com', 'TvEqEnoG', '9/29/2021', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-11 23:29:00', 'mbriandj@behance.net', 'DWIALaUwXd', '3/8/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-29 08:55:22', 'ohungerfordk@twitpic.com', '0lehVADP', '10/14/2021', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-25 01:53:04', 'ostegersl@mit.edu', 'CZCX71n6S2kH', '3/12/2022', 36);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-08 20:47:38', 'fpenimanm@google.ca', '6IBFCvT', '1/23/2022', 36);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-16 06:17:30', 'gbrackleyn@slideshare.net', 'A8HzX9S0URnP', '3/29/2022', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-18 22:23:58', 'brawkesbyo@disqus.com', 'ki1lT0I5eiuA', '4/21/2022', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-05 03:13:32', 'mhanselmannp@google.ru', 'DPJfO5u', '6/22/2022', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-12 11:59:20', 'cbarnesq@bravesites.com', '2kTivlkJ', '2/2/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-13 04:25:43', 'sduddler@icq.com', 'YL0yhq4Sxw', '4/18/2022', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-09 08:10:43', 'gkillichs@goodreads.com', 'm9DOd9', '1/21/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-23 09:59:36', 'jblumert@symantec.com', 'pBH6qDK6V', '12/20/2021', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-18 19:42:27', 'gbutlandu@rakuten.co.jp', 'yvSs0tUqnIgH', '3/11/2022', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-13 10:33:41', 'sschurigv@bing.com', '4lT6BlD', '1/20/2022', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 23:30:15', 'cgooddayw@hostgator.com', '9eGrvMwOygB', '1/6/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-16 12:36:27', 'pacottx@slashdot.org', 'GSmHJk', '7/5/2022', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-16 01:16:55', 'nabdeny@bravesites.com', 'ZsgPxHxFS', '6/3/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-25 14:58:03', 'vtytlerz@umich.edu', 'ixaOUYovn', '2/25/2022', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-19 08:07:03', 'oavison10@gravatar.com', 'q8ai08t', '9/3/2021', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-07 20:59:19', 'fantonomolii11@google.co.uk', 'uuyMA0PzqTX1', '10/24/2021', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-29 20:09:41', 'rbalbeck12@sphinn.com', 'WXPXYfx', '1/8/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-08 20:17:47', 'ibambrough13@npr.org', '6LB77E9NiUA', '2/2/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-12 08:51:44', 'ghubbert14@hubpages.com', 'zygQFn', '4/20/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-15 06:13:28', 'alundie15@mlb.com', 'mVJuIJChB', '5/20/2022', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-23 11:59:43', 'rlouder16@gmpg.org', 'kbErnLJnwbP', '11/17/2021', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-26 11:08:45', 'mtretter17@noaa.gov', '4XEWSAhF', '5/28/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-13 23:27:01', 'dbakeup18@ucla.edu', 'fguxutf5', '6/14/2022', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-07 22:56:31', 'bflieg19@arstechnica.com', 'CoMgnBZEMV', '12/31/2021', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-29 04:57:32', 'emcginny1a@hhs.gov', 'ItBEKUQwsD', '7/30/2022', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-30 13:30:08', 'tsnar1b@cmu.edu', 'qEQuqA7Ky', '8/24/2021', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-08 07:08:11', 'edensell1c@china.com.cn', 'nnQrBYWD', '3/30/2022', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-03 00:06:51', 'eportt1d@utexas.edu', 'jb4QSiVc', '10/5/2021', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-13 21:40:25', 'blavens1e@photobucket.com', 'sC1Dwjw', '1/8/2022', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-03 21:49:45', 'nbiaggi1f@foxnews.com', '5oOwVxFDlx', '3/27/2022', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-30 01:47:33', 'msharp1g@360.cn', 'jxPCW2dnDAm', '3/27/2022', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-13 19:24:00', 'ysherwyn1h@last.fm', '2iSZS2zUp', '5/23/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-04 21:53:45', 'zcrossby1i@sakura.ne.jp', 'Yw74azz', '10/22/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-11 12:48:16', 'ksonger1j@studiopress.com', '2KLwEeaziwu', '9/19/2021', 38);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-20 16:24:56', 'trizon1k@un.org', '1AuCaQhcN', '7/20/2022', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-03 08:05:34', 'mputland1l@51.la', 'YNJ9Qz0LWz3z', '10/28/2021', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-20 16:16:02', 'khryniewicz1m@china.com.cn', '8KUAQKusAOLg', '2/11/2022', 61);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-06 04:24:55', 'borred1n@amazon.co.uk', 'bp8tcSNJaJF', '11/27/2021', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-28 03:23:56', 'cboothby1o@scribd.com', 'Jg4jsCAuFyo', '11/5/2021', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-28 20:05:25', 'kburberye1p@pbs.org', 'FqYOd7QING4', '4/28/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-01 04:40:38', 'gstuckes1q@delicious.com', 'zVmt5z2keg', '3/31/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-23 14:47:37', 'gdudden1r@dyndns.org', 'iNT64dZBr', '8/31/2021', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-31 03:36:10', 'arimour1s@ezinearticles.com', '1BiXFu', '10/8/2021', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-19 07:13:33', 'jmarc1t@artisteer.com', 'L4zfwua', '5/27/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-12 16:48:02', 'ctwigger1u@columbia.edu', 'iYSqFKTp', '12/30/2021', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-20 11:32:53', 'eherculson1v@sourceforge.net', 'NLhJhg', '1/17/2022', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-05 12:41:01', 'bgeorger1w@un.org', 'OzeW2H9', '12/15/2021', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-11 22:27:35', 'sklimas1x@cisco.com', 'x8B629rtR', '7/24/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-12 08:40:08', 'bwhyberd1y@dion.ne.jp', 'U6GXh6vyL', '6/17/2022', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-17 20:35:58', 'jrustman1z@fastcompany.com', 'hnAaJFicZ', '2/16/2022', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 14:36:44', 'rpau20@booking.com', 'vwq9MaaCa', '12/2/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 09:00:28', 'rbegbie21@github.io', 'VvaKVW', '9/15/2021', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-26 07:14:59', 'jmcjerrow22@parallels.com', 'QJEnzUGpgp9', '6/27/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-19 21:17:25', 'aferreo23@flickr.com', 'RrfIjrSU', '10/30/2021', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-18 19:00:54', 'ddambrosio24@cmu.edu', 'EbcLaQH', '10/13/2021', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-17 00:16:56', 'dwarmington25@sourceforge.net', 'o0rrrROU4Xmy', '11/22/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-31 21:29:03', 'kingleton26@joomla.org', '1YOfCIu', '11/1/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 08:04:09', 'mmuckleston27@netscape.com', 'gNZMmbarD', '3/20/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-06 10:08:00', 'eelsay28@biglobe.ne.jp', 'QqpQaqx', '10/2/2021', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-26 14:58:59', 'dbardwell29@wsj.com', 'LCtSo6c', '9/29/2021', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-05 06:48:29', 'rnendick2a@naver.com', 'BXUNmdFRq', '10/11/2021', 33);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-16 19:29:20', 'alongfield2b@soundcloud.com', 'vKTT5JUhO0C', '3/28/2022', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-21 07:00:40', 'meaves2c@cisco.com', 'm0nsYri99gv', '6/14/2022', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 05:31:20', 'hjorez2d@yahoo.com', 'mv81wQUBL', '7/26/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-07 04:49:31', 'gkerwin2e@facebook.com', 'kC508d', '3/16/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-23 10:26:02', 'sborthwick2f@foxnews.com', 'npPhabjbCyiW', '9/18/2021', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-28 02:00:20', 'psmurfitt2g@ucsd.edu', 'OY5imWME', '11/22/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-21 20:13:22', 'gduncanson2h@ifeng.com', '7CdCrqpBg', '10/4/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-25 22:00:05', 'feddowes2i@aboutads.info', 'f3MyBznul', '1/20/2022', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-09 14:05:39', 'karnault2j@phpbb.com', 'w7y7AEj', '5/28/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-24 10:27:34', 'cdemalchar2k@ftc.gov', '5paskgU7Trc7', '11/8/2021', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-04 21:12:51', 'kstienham2l@ebay.com', '4v77Mk57y', '9/19/2021', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 21:12:02', 'craun2m@tripadvisor.com', '2PQJj1TIdni', '8/21/2021', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-02 17:13:21', 'cbeaver2n@meetup.com', 'fipSz8edb', '8/3/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-25 10:44:57', 'ywerndly2o@cam.ac.uk', 'l96gQs8rwr', '3/17/2022', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-19 15:52:39', 'cgatchel2p@forbes.com', 'lcWZXVT', '8/10/2021', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-26 02:55:35', 'eabramovici2q@imgur.com', 'Fj6u8d8P', '8/14/2021', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-10 14:13:13', 'pgunter2r@lycos.com', 'FhWJz1Gv9eG', '1/6/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-18 15:02:50', 'anatalie2s@marketwatch.com', 'w2Legl', '3/29/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-21 18:22:36', 'nwigelsworth2t@tmall.com', 'FfoJygke', '1/20/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-30 22:46:24', 'rgerred2u@nba.com', 'ZAVsWmorYXK', '6/18/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-10 05:34:22', 'kballantine2v@craigslist.org', 'V6E8oU', '9/11/2021', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-19 17:24:56', 'ebonnette2w@chronoengine.com', 'DbJsng1I', '8/27/2021', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-22 19:49:08', 'bbigrigg2x@sciencedirect.com', 'Lx97gCoaYn3', '8/5/2021', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-01 15:41:47', 'apynner2y@wufoo.com', 'FwCcs8bp', '11/21/2021', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-06 07:09:16', 'dparfrey2z@theglobeandmail.com', 'DvMSDz6o79w', '9/12/2021', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-29 14:19:48', 'tvarvara30@ocn.ne.jp', 'IcoWnBDz', '9/14/2021', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-17 17:06:34', 'lcraster31@cdbaby.com', 'rIl7YT', '10/25/2021', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-13 20:15:31', 'ccurthoys32@forbes.com', 'X7uF4fwb', '7/30/2022', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-07 12:51:41', 'gmilington33@unicef.org', 'jkqz7vIBb', '1/15/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-06 20:36:52', 'rsharer34@e-recht24.de', 'rPiF1lirFIWd', '5/22/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-21 00:11:17', 'aucchino35@epa.gov', 'VCNo78JA', '6/16/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-20 04:22:47', 'aearry36@ovh.net', 'R9kXUHGN6', '11/17/2021', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-25 07:03:49', 'ckenneway37@ucoz.ru', 'ohpXcTGO', '9/20/2021', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-18 10:54:09', 'jgregolotti38@livejournal.com', 'ywJsNT', '9/24/2021', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-26 14:54:03', 'rparrot39@sun.com', 'S8wodnZYn', '1/3/2022', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-28 11:12:11', 'ethompsett3a@unc.edu', 'iR91LCD6qa', '7/31/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-15 15:40:39', 'podoherty3b@ft.com', 'W8e6lTSogb', '11/6/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-12 09:34:34', 'hbarsam3c@jugem.jp', 'iEHXimB4', '8/14/2021', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-04 10:42:12', 'saxcell3d@thetimes.co.uk', 'f9l5Rfp4TI', '6/13/2022', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-01 01:58:51', 'rspence3e@devhub.com', 'KmQmFsqm', '10/12/2021', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-05 08:16:20', 'egoodin3f@slashdot.org', 'a7aRJ70kGfJ', '4/23/2022', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-30 22:21:06', 'jdobrovolski3g@bluehost.com', 'XZZcko', '5/9/2022', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-02 15:06:47', 'rbrydie3h@illinois.edu', 'TddFhbF0', '2/19/2022', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-30 07:52:15', 'zkowalik3i@paypal.com', 'oH5sm11jk', '6/17/2022', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-26 11:55:02', 'ceyree3j@slashdot.org', 'C0qHbf', '12/13/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-24 11:34:07', 'rstairs3k@nhs.uk', '7DmdRnz', '8/5/2021', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-18 15:13:00', 'wmasic3l@google.pl', '7ZZDat', '8/26/2021', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-03 10:17:34', 'fdaunter3m@blog.com', '23o3QrnGByBH', '5/28/2022', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-24 06:09:09', 'rfairfoot3n@apache.org', 'KY8kJaQ', '4/13/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-10 14:39:08', 'mmacvain3o@github.io', 'qAOQ49HjR', '5/2/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-02 16:40:47', 'hmcphail3p@squarespace.com', 'Rh5be8Lw', '3/13/2022', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-12 17:05:09', 'vbea3q@weather.com', '7aqX6V', '6/14/2022', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-15 08:17:34', 'dscamwell3r@chronoengine.com', 'J74nHWmHs', '6/5/2022', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-08 20:20:39', 'zphelan3s@people.com.cn', 'nDS9lNYZn', '12/2/2021', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-08 17:43:02', 'nlangston3t@unc.edu', '1XpbcOMG', '2/2/2022', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 00:40:13', 'pcolerick3u@merriam-webster.com', 'dLfC1Mlo043F', '6/24/2022', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-15 11:34:42', 'tjelphs3v@storify.com', 'n9ZY3IW', '8/13/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-04 10:07:57', 'ctippett3w@skype.com', 'GfBsAp', '3/22/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-26 07:21:03', 'cmcclifferty3x@foxnews.com', '99yXyWt5y', '5/16/2022', 36);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-22 09:31:08', 'lfranzonetti3y@pbs.org', 'z21kyweRXF', '11/25/2021', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-30 05:52:17', 'abrislen3z@infoseek.co.jp', 'as4mVb5Jn5Lb', '5/18/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-23 01:51:02', 'rbaldacchino40@ft.com', 'xLBvTpGgW', '5/2/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-22 20:02:38', 'cputland41@state.gov', 'rUuMTuj9tb', '11/7/2021', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-13 07:19:52', 'hvalenssmith42@trellian.com', 'GXq6hXjc2NFt', '7/18/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-11 19:31:23', 'tnordass43@dagondesign.com', 'ctsnOakyIm', '7/22/2022', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-16 08:21:01', 'arimbault44@phpbb.com', 's3fKXWRnr', '8/31/2021', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-24 04:54:42', 'ckhotler45@g.co', 'CbolAQscYv', '11/27/2021', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-20 18:20:29', 'clandy46@abc.net.au', 'i339TWO13DpP', '9/29/2021', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-26 19:38:47', 'ndenisovich47@theatlantic.com', 'nhlGcuH5U7y9', '8/22/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-27 23:41:20', 'cbanaszkiewicz48@hexun.com', 'nkI7oFsjy', '3/25/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-03 17:24:08', 'aropcke49@sun.com', '57DNAAnk', '2/1/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-02 17:52:32', 'fwilfinger4a@chron.com', 'lPVfefiGx4nd', '1/4/2022', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-19 00:16:26', 'ohalgarth4b@ocn.ne.jp', 'ir7Pry', '12/12/2021', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-04 12:13:13', 'jhabercham4c@blinklist.com', 'h5hJFNN3wyd', '5/16/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-01 10:15:32', 'thusk4d@kickstarter.com', 'r4AJzsP', '4/25/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-06 08:01:01', 'dsteers4e@msn.com', 'cWrfTCmA1', '5/18/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-29 09:44:23', 'gluter4f@goo.ne.jp', 'bUPgS3xvXj', '1/30/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-21 15:01:29', 'ghuyton4g@utexas.edu', 'ZmCckQ3bz', '5/14/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 04:57:01', 'omcturk4h@etsy.com', 'IL7Nhk2', '3/12/2022', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-07 12:42:18', 'rswafield4i@merriam-webster.com', '8EcpQdv', '11/17/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-09 11:41:28', 'njanusik4j@imageshack.us', 'VBzQYF', '1/15/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-05 01:15:11', 'dhupka4k@princeton.edu', 'HOxIlT30', '8/28/2021', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-13 13:27:29', 'cconkay4l@reference.com', 'iOTWH0', '9/12/2021', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-27 02:06:06', 'gtrewhitt4m@networkadvertising.org', 'xPk6vTRFY', '2/10/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-10 01:21:06', 'stuhy4n@amazon.co.uk', '7KvWprAeekvC', '2/9/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-23 02:11:55', 'jlarwood4o@about.me', 'O9q29Z', '9/19/2021', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 04:42:06', 'wbabbs4p@wordpress.com', 'vDv9jSL3Sx', '8/23/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-25 06:31:00', 'bbahike4q@instagram.com', 'O41t9JRRLwaR', '3/3/2022', 36);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 06:49:16', 'eangel4r@economist.com', 'tanoSC', '5/28/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-21 08:49:31', 'nshowell4s@homestead.com', 'xYtmDCtwk', '4/11/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-04 02:10:25', 'hmarchington4t@youtu.be', 'GvTFyhS57o1', '12/22/2021', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-26 01:55:31', 'tmeere4u@phpbb.com', 'er2OxYJERPD', '6/26/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-02 00:56:29', 'hfadian4v@shinystat.com', 'oWCEyeQnjylr', '1/19/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-26 06:55:21', 'bsnazle4w@blogspot.com', '0L912G85', '8/26/2021', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-16 05:30:28', 'ecollingworth4x@wix.com', '9w18rzj', '4/25/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-08 19:10:54', 'mmartin4y@ustream.tv', 'to3h7pd904Sx', '7/18/2022', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-09 02:59:32', 'plosebie4z@nature.com', 'mnw1WfZIHnd', '3/9/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-06 08:30:40', 'rcovey50@barnesandnoble.com', '7uIyLlj', '1/26/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-25 20:44:46', 'clukes51@economist.com', 'I3KvzVj', '11/27/2021', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-26 04:00:04', 'dcohalan52@goo.ne.jp', 'rONSoj', '1/11/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-08 04:59:49', 'rkoenraad53@wsj.com', 'vqBlhRCBK', '8/25/2021', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-17 21:21:14', 'afills54@indiatimes.com', 'toVPptN', '9/29/2021', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-19 01:51:13', 'alimming55@cbsnews.com', 'JftpbK6', '8/8/2021', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-03 04:20:58', 'imawtus56@deviantart.com', 'zS8CpM', '12/27/2021', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-11 12:20:16', 'lstirton57@tinypic.com', 'K4HwwaD', '12/20/2021', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-30 07:04:12', 'mkilcullen58@themeforest.net', 'i2VnxB', '5/30/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-18 20:58:24', 'cjaray59@wordpress.org', '4oBvYiOu4O', '11/21/2021', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-09 02:12:41', 'bsheards5a@desdev.cn', 'YNOxeK8lF', '3/24/2022', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-11 04:26:13', 'cfeltham5b@pbs.org', '5UKpzuCriKTC', '2/13/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 06:55:32', 'apieters5c@ycombinator.com', 'MDiJYE', '5/8/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-13 19:53:49', 'ggallimore5d@cnet.com', 'jlShPgxoKA', '5/6/2022', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-17 01:20:42', 'rbeddin5e@delicious.com', '6zQAeeJXoAY', '10/9/2021', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-21 12:27:22', 'pmantripp5f@newsvine.com', '1QJzI7', '3/3/2022', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-21 23:02:20', 'arapper5g@foxnews.com', '0RbE3KiZA', '5/27/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-29 15:40:27', 'cdanilenko5h@si.edu', 'KtvU0md50fW1', '4/14/2022', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-27 06:25:15', 'bferrieroi5i@mayoclinic.com', 'oW361oke', '12/1/2021', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-06 02:03:41', 'vcudiff5j@wikimedia.org', 'GDomW4z', '4/27/2022', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-11 14:09:51', 'paleevy5k@yelp.com', 'tXntfNmR', '11/7/2021', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-23 17:45:45', 'venric5l@t-online.de', 'NCkh8Zj8', '3/21/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-31 20:33:02', 'aguy5m@theglobeandmail.com', 'SVRnGtJFXXJ', '6/24/2022', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-23 21:31:01', 'vriglesford5n@over-blog.com', 'J3IoCL', '9/23/2021', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-17 13:22:43', 'kvignal5o@senate.gov', 'Z9OL41k6F49L', '7/9/2022', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-04 10:21:33', 'smacwhirter5p@house.gov', 'HZAjbImE', '11/16/2021', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-07 05:50:04', 'tkornilov5q@networkadvertising.org', '0lJWbxqw', '10/24/2021', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 12:56:43', 'lrushby5r@businessinsider.com', 'dpdP6SZru6a', '10/12/2021', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-04 02:31:08', 'fdescoffier5s@washingtonpost.com', 'M1jdXSYPsmA', '12/16/2021', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-04 17:23:00', 'ghames5t@wikia.com', 'HMq2bLTTTF', '2/4/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-07 02:45:39', 'cmenault5u@surveymonkey.com', 'BcfApbf', '12/11/2021', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-25 18:40:53', 'gchew5v@apache.org', 'R9V3ZZBJ2', '2/10/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-29 08:19:53', 'ybernli5w@omniture.com', 's64ZckGX1XR', '10/17/2021', 88);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-10 11:41:27', 'vgilliat5x@hc360.com', 'LPnMIHzQlY', '7/23/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 10:32:44', 'fsherme5y@newyorker.com', 'jPfHsFOen83K', '12/5/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-26 19:37:24', 'mlovstrom5z@oakley.com', 'hKvl3pDJ', '7/2/2022', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-07 12:51:01', 'thutable60@hao123.com', 'tryvweO16', '3/26/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-24 16:53:08', 'oagott61@businessweek.com', 'NEkbO8zFaU', '11/7/2021', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-01 19:29:19', 'cseldner62@csmonitor.com', 'Ucw6ysagYmld', '12/5/2021', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-18 01:10:23', 'mwaddoups63@ask.com', 'cZthAFKPh', '9/9/2021', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-26 23:34:06', 'shamlen64@sourceforge.net', 'Ekow5gPkX0a', '12/11/2021', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-08 08:52:17', 'nbingle65@hhs.gov', 'PLz9MIZHLyrR', '11/24/2021', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-31 03:22:15', 'btraill66@prlog.org', 'N3CYWnGmM', '6/29/2022', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-07 09:15:28', 'mgrundle67@360.cn', '1nXHN6', '11/8/2021', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-20 13:30:25', 'kdudding68@behance.net', '5crOxawu', '11/17/2021', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-17 17:41:50', 'amedgewick69@chicagotribune.com', 'i8d1QOoj', '1/11/2022', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 19:55:06', 'fpues6a@reddit.com', 'GNbuUER6', '3/11/2022', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-05 00:30:56', 'brenyard6b@disqus.com', 'KHQ8qKLAF', '3/2/2022', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 23:05:56', 'okidsley6c@aol.com', 'sJGXseQJXvZm', '9/3/2021', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-08 10:39:59', 'gmacgaffey6d@google.it', 'fnYB94F', '8/13/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-09 16:59:25', 'wbaldassi6e@sphinn.com', 'd7NuOsUktlnQ', '6/11/2022', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-26 23:45:07', 'rdown6f@seattletimes.com', 'WkjiR04M1', '8/7/2021', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-30 09:43:35', 'fforo6g@mozilla.com', 'CtNdQ8ecJ', '4/28/2022', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-28 04:10:59', 'ddowsey6h@twitpic.com', 'ghV0rCB', '8/2/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-26 06:09:10', 'aassante6i@liveinternet.ru', 'LaEZqI9CI1EC', '4/10/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-28 22:16:08', 'fgabbett6j@ameblo.jp', 'ppHP07wogk6', '8/3/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-14 08:18:46', 'mschult6k@dyndns.org', '6DIq8H', '4/2/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-14 04:37:00', 'kdigiorgio6l@ftc.gov', 'PIJjvc6UJp4F', '7/11/2022', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-09 16:28:15', 'dartz6m@themeforest.net', 'txtWDkQ2m3e', '2/19/2022', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-12 16:18:59', 'tordemann6n@yale.edu', '9uMSFb1XFkT', '6/24/2022', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-05 13:34:47', 'lbordman6o@theguardian.com', 'aEhcxrPM', '9/22/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-29 09:36:29', 'lwilbud6p@chron.com', 'scQGC7kdcG', '7/26/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-16 10:04:51', 'bstanggjertsen6q@rambler.ru', 'nthH8y0z', '7/12/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-15 22:27:46', 'icronchey6r@slate.com', 'WSkLxin61', '3/28/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-01 07:07:11', 'amcmonnies6s@kickstarter.com', 'uwXgW4', '2/21/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-12 00:19:36', 'ffreeborn6t@discuz.net', 'lrTbhXd2X', '3/19/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-21 14:57:22', 'cregardsoe6u@nytimes.com', 'yro3TK', '6/20/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-01 22:27:30', 'agraber6v@pcworld.com', 'WmQ9pjREz', '4/25/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-13 18:53:29', 'rwhite6w@comsenz.com', 'msUwLEFhGy', '5/30/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-04 12:38:27', 'dchamberlaine6x@nationalgeographic.com', 'xFV7Q8D1XI', '8/21/2021', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-12 15:28:17', 'gsleep6y@nifty.com', 'NMU9SJgkq', '4/2/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-09 11:11:38', 'gmaccrann6z@wix.com', 'VhtkRszzZ', '6/22/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-29 22:00:53', 'flayborn70@craigslist.org', 'wKtHMGn', '9/6/2021', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 07:01:38', 'lcolliver71@booking.com', 'ErBVwmeBZAh', '12/13/2021', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-17 04:07:43', 'pbaal72@blinklist.com', 'zKP2OMirpoTx', '12/28/2021', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-20 21:07:37', 'rstaggs73@icq.com', 'YXoFefVvi1gE', '2/21/2022', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 00:00:52', 'droseaman74@latimes.com', '449VyHqmD', '10/16/2021', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-11 08:26:03', 'thoffner75@yahoo.co.jp', 'oMEgGP2EZe3', '11/16/2021', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 09:13:56', 'gbolens76@about.me', '7HekHAGwP', '12/21/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-30 16:23:20', 'jglader77@businesswire.com', 'MJ5TLGAhX', '8/1/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-14 06:30:28', 'sfairbourn78@google.fr', 'EZVzJRAId2Ru', '6/12/2022', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-21 13:47:00', 'tlewson79@yahoo.com', 'RNmcPidSqZ', '10/21/2021', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-09 05:03:19', 'sgodly7a@diigo.com', 'cp7JZ9ACwT', '4/26/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-24 19:28:53', 'sjeannot7b@epa.gov', 'DtqQTi', '6/10/2022', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-13 02:47:13', 'oewan7c@purevolume.com', 'RAZob68', '5/4/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-11 16:22:05', 'kfante7d@e-recht24.de', 'ojefT2redwaT', '1/31/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-08 11:03:50', 'mmelladew7e@is.gd', '6JPjiZA', '8/19/2021', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-20 01:06:00', 'mgillon7f@51.la', 'MXW7jOrv7oqi', '12/4/2021', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-03 01:22:42', 'tcharnley7g@posterous.com', 'P54I632', '10/25/2021', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-21 20:33:52', 'geldered7h@elpais.com', 'SbvLkH', '12/15/2021', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-23 09:45:22', 'rmunson7i@1688.com', 'gDQnHG', '10/4/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-03 01:08:14', 'psagg7j@seattletimes.com', 'UJzyPU8d', '5/14/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-13 11:22:01', 'lmagrane7k@ameblo.jp', 'pZCZ5vwxTj', '5/27/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-16 20:01:52', 'mcatmull7l@si.edu', 'eqDQZMhNcDT', '8/13/2021', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-30 07:13:18', 'rcoggings7m@soundcloud.com', 'eY9h4atFaGmF', '6/25/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-30 22:23:18', 'thedney7n@miitbeian.gov.cn', 'ozS0fZBJ', '5/2/2022', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 18:04:44', 'bgwin7o@smugmug.com', '5esqkiNe', '6/5/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-09 12:37:24', 'gmustard7p@samsung.com', '4yCmIQzO3', '6/20/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-16 05:46:14', 'rtenant7q@house.gov', 'Rlgqb5vhWV', '7/16/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-15 08:50:19', 'bwapple7r@sciencedaily.com', 'GhvHCHF0', '2/25/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-11 13:57:28', 'bsolway7s@nih.gov', 'PlUqgyOeA', '6/10/2022', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-07 22:12:23', 'dgilbride7t@dagondesign.com', '0TX9XDlC', '4/8/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-15 13:40:57', 'jfoggo7u@delicious.com', 'q5nSDJG', '1/23/2022', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-27 01:44:40', 'msuttell7v@ftc.gov', 'PL2vVYb', '11/20/2021', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 12:33:47', 'dlivingstone7w@statcounter.com', '1otQ86J1G', '4/30/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-24 00:34:17', 'kbowdidge7x@trellian.com', 'QlHg9id', '3/28/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-25 03:16:31', 'stabord7y@ycombinator.com', '0OAnXszqOeC', '10/7/2021', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-01 08:14:52', 'kconnal7z@tmall.com', 'GSBJk59SG', '6/30/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-16 01:02:59', 'rhendricks80@princeton.edu', 'wYjtNRkQI', '11/18/2021', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-03 15:34:57', 'ccoaster81@amazon.co.uk', 'PuRU7WR', '11/26/2021', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 18:41:26', 'gtemlett82@ted.com', 'b6fHJg6lFlC', '2/9/2022', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-18 06:24:26', 'bwaterfield83@webs.com', 'rLCPDhnMAyV1', '10/9/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-25 23:44:20', 'eblaymires84@ning.com', 'HLwRVz3J', '4/23/2022', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-25 06:05:55', 'llagneaux85@google.ca', '6BEcARQ9ot', '12/23/2021', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-05 20:51:14', 'stoun86@mashable.com', 'j3Qt4BWIs', '8/8/2021', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-13 22:56:04', 'mlawleff87@foxnews.com', 'vctGU7WBELa6', '8/30/2021', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-24 22:07:06', 'mboyland88@github.com', 'OW14AM', '1/24/2022', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-21 02:45:32', 'asainter89@tuttocitta.it', '2q6Aqgkd', '12/1/2021', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-29 14:26:09', 'hmosedall8a@ameblo.jp', 'E9ruI9', '10/25/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-29 07:40:23', 'rliddicoat8b@home.pl', 'rH7thIsXMzV', '10/9/2021', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-05 16:02:12', 'acrutchfield8c@histats.com', 'MI0TWi', '10/16/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-30 01:07:28', 'bdomaschke8d@about.me', 'c2BYK8A0nvt8', '1/16/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 19:19:12', 'gmcavin8e@deliciousdays.com', 'LR1WaB2uWU9D', '1/8/2022', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-29 23:27:44', 'dzupa8f@chicagotribune.com', 'kW0sD9zG', '7/20/2022', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-29 05:32:57', 'msimcox8g@amazon.com', 'j6wShuq', '10/2/2021', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-12 07:35:24', 'fnevison8h@bloomberg.com', 'mUqiXk', '5/23/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-31 01:14:06', 'ahoundson8i@nationalgeographic.com', 'LXLSSOEPntyW', '12/18/2021', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-31 14:58:45', 'rserjeantson8j@pagesperso-orange.fr', 'n5jp3qOGWkuT', '1/30/2022', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-26 11:25:59', 'agabitis8k@slashdot.org', 'oIiE1KwVLK', '10/5/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-03 02:25:06', 'kjanuszkiewicz8l@163.com', 'lg2EIsP', '2/9/2022', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-26 15:53:51', 'cscholey8m@purevolume.com', 'VDOER7547ca', '3/18/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-31 07:33:23', 'rhenzley8n@yolasite.com', 'PDGBJ3VCZH', '12/10/2021', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 00:58:00', 'rceci8o@squidoo.com', 'KNzd6Uyboyb', '7/28/2022', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-07 10:59:59', 'avonderdell8p@biglobe.ne.jp', 'eNAC3XT', '5/15/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-26 18:18:31', 'ecarlens8q@themeforest.net', '45rBOalnXO', '3/6/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-16 22:30:49', 'fpinkett8r@google.ca', 'Z3kAKXaoC', '7/15/2022', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-04 08:21:54', 'kmora8s@mediafire.com', 'cugNUrORSf', '2/14/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-17 02:28:59', 'rsylvaine8t@ask.com', 'xuNnNx95q12t', '9/17/2021', 61);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-16 10:55:18', 'ncutchie8u@weebly.com', 'DrdtK73vu', '11/7/2021', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-15 16:06:22', 'sdanforth8v@ted.com', 'MPgCnUXmrM', '7/3/2022', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-18 17:14:57', 'wgatiss8w@godaddy.com', 'q9tADIfTt', '1/21/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-10 10:03:01', 'lbentall8x@opera.com', 'DYWrdxAcuHfz', '11/14/2021', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-15 21:43:46', 'pemmitt8y@flickr.com', '6TQ0REKkT5nZ', '2/17/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-14 03:39:30', 'kheeks8z@elegantthemes.com', 'e7lO2TO', '7/13/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-06 02:43:47', 'aduchateau90@businessweek.com', '4YfnGgByi1yS', '8/15/2021', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-20 03:06:18', 'fcatanheira91@google.fr', 'l7k3w2AeX5j8', '12/18/2021', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-18 11:45:51', 'meminson92@miibeian.gov.cn', 'j4RbjW9U', '9/22/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-16 19:15:11', 'zgellan93@reuters.com', '7bjvomz5o', '11/3/2021', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-05 13:56:36', 'omaseres94@g.co', 'JwbYEogVx', '10/2/2021', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-15 10:33:28', 'cstratz95@ibm.com', '8uSIGIEx4BL', '12/22/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-11 16:33:27', 'leveral96@japanpost.jp', '33Pw15g7', '8/31/2021', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-09 11:30:29', 'jconti97@typepad.com', 'LJlur6yJ6u2', '9/21/2021', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-27 06:47:56', 'scrudginton98@oaic.gov.au', 'hK97rV', '12/27/2021', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-17 15:48:25', 'alaven99@nhs.uk', 'X4DwnR4', '10/5/2021', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-19 23:22:41', 'ggandy9a@kickstarter.com', 'AxLrrNNQVah', '6/23/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-24 10:04:23', 'ttrowel9b@unc.edu', '4a4xf6W', '9/1/2021', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-29 06:08:57', 'wtuny9c@smugmug.com', 'uPLlDVTxXiGr', '8/11/2021', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-15 11:25:17', 'efrensche9d@miibeian.gov.cn', 'PDAdmmcncuT', '9/15/2021', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-20 21:25:41', 'rhilary9e@posterous.com', 'AbwsS6C', '8/1/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-05 14:16:28', 'kokerin9f@kickstarter.com', 'I42tHKk8Tn', '3/26/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-06 02:45:37', 'jbinyon9g@deviantart.com', 'pofD7e8gLZ81', '10/10/2021', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-04 09:42:21', 'bromanski9h@gov.uk', 'DTShPGNi', '9/21/2021', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-04 13:04:47', 'huttridge9i@japanpost.jp', 'iqJispo4q1', '3/22/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-04 22:18:29', 'lofallowne9j@free.fr', 'RgAv3bbmqJzS', '11/11/2021', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-20 23:46:17', 'wcartmale9k@nhs.uk', 'YNbjiUuCb', '8/1/2022', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-14 04:27:14', 'etaplow9l@reddit.com', '3p2MmB', '12/14/2021', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-22 00:25:41', 'tscoggin9m@g.co', 'WmwjLsAG', '8/5/2021', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-23 15:04:23', 'lskuse9n@gizmodo.com', 'ORrSHJzXf5nU', '8/21/2021', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-03 04:27:35', 'ioreilly9o@army.mil', 'cIqSB8p0', '8/17/2021', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-02 21:32:45', 'hnoods9p@godaddy.com', 'h04cc1qp7kk', '3/1/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-28 12:31:48', 'omonnoyer9q@flickr.com', 'quupOd', '9/21/2021', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-03 00:09:23', 'hballoch9r@noaa.gov', 'Fdx05K', '5/31/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-31 00:15:18', 'dsolloway9s@fema.gov', 'pONuH4gdvx', '1/22/2022', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-13 01:22:10', 'tgerardi9t@oaic.gov.au', 'iCClTsmp3TAU', '7/11/2022', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-24 09:35:13', 'tspilsted9u@mozilla.com', 'FkBQr4h4LD9', '5/15/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 00:18:31', 'tbrenard9v@sfgate.com', 'OwpG3UZki', '5/7/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-07 01:16:24', 'cbossel9w@stanford.edu', 'wChvbVqSf6', '8/16/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 00:14:02', 'rcasaccio9x@ucla.edu', 'B4UXsO', '5/13/2022', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-22 03:48:30', 'gfanning9y@naver.com', 'kC2jsGDS53fD', '11/25/2021', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-16 04:34:43', 'nlafayette9z@elpais.com', 'NpWvoO6u', '2/11/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-02 01:35:58', 'mventrisa0@wix.com', 'O3nYWlBRBC0i', '10/26/2021', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-21 05:32:47', 'mknottea1@google.pl', 'n5oKv8AAzU', '4/7/2022', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-29 20:20:11', 'aferrinoa2@oakley.com', 'lcqzpHqx5ijU', '6/16/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-07 06:31:43', 'aockendena3@answers.com', 'RyAGCex58lwO', '4/19/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-29 07:48:18', 'aphebeea4@altervista.org', 'CKbPNtNEi', '2/5/2022', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-06 16:35:53', 'tludmanna5@reverbnation.com', '56K5WPJ', '12/12/2021', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-22 18:12:20', 'swoodgera6@telegraph.co.uk', 'r8Af0kqqu', '11/18/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-31 19:59:21', 'shartella7@infoseek.co.jp', 'xzDVh0', '12/31/2021', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 20:49:12', 'cvarfolomeeva8@360.cn', 'ixXZTW99aE', '5/28/2022', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-30 14:55:10', 'ldomelowa9@wordpress.com', 'TenmvqKz', '7/9/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-17 19:23:07', 'esutlieffaa@privacy.gov.au', 'ym3wYDui', '9/23/2021', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-15 10:01:16', 'efitchettab@icq.com', 'Ze9bISm0OJng', '12/8/2021', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-27 15:55:39', 'clapennaac@lulu.com', 'MLbHO8Slu', '11/1/2021', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-21 09:19:47', 'ngingelad@dmoz.org', 'pQut0Axc6K', '9/27/2021', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-24 12:49:32', 'yjohanssonae@yelp.com', 'Rn5ooVYd', '3/10/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-23 21:49:49', 'ameriottaf@utexas.edu', '3ryPpz4bn', '5/22/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-17 05:25:17', 'bcruftag@stumbleupon.com', 'ip6XsDq44MM', '4/6/2022', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-26 01:55:21', 'adelazenneah@ocn.ne.jp', 'U4lPVT', '7/1/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-26 08:39:05', 'hstrikeai@statcounter.com', '8KzsgT', '5/22/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-17 21:40:12', 'lgregoraciaj@merriam-webster.com', 'xLujKZo3gJN', '11/1/2021', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-26 16:52:19', 'nlaverenzak@sciencedirect.com', 'FJmgkf4a', '3/25/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-07 22:23:20', 'mmansbridgeal@i2i.jp', 'J3yK1se', '2/3/2022', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 09:45:20', 'ldarrelam@purevolume.com', '3uGqBhc', '1/29/2022', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-09 03:22:21', 'clondesboroughan@freewebs.com', 'l4BS8fi7B', '9/16/2021', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-19 00:17:36', 'lduigenanao@prnewswire.com', 'KQh9jm9pryL', '5/9/2022', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-23 06:22:58', 'acastleap@alexa.com', 'YYKiJByub', '7/13/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-27 11:54:01', 'mwrettumaq@barnesandnoble.com', 'ctgp61N', '11/23/2021', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-03 04:38:14', 'bknightar@adobe.com', '0dvnVCR98ndY', '8/1/2022', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-29 12:02:07', 'wsmileyas@hc360.com', 'ImvIOSUc', '5/3/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-01 07:53:34', 'mvidoat@paypal.com', 'ktV7K4kF', '6/22/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-07 11:15:13', 'gkuhnkeau@timesonline.co.uk', 'erkM3Mi', '11/24/2021', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-27 15:50:49', 'dbrownhillav@ezinearticles.com', '7CoLfaa', '10/1/2021', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-14 03:42:26', 'esollasaw@unblog.fr', 'D7mxCpA', '9/26/2021', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-20 08:14:25', 'rlavenax@mit.edu', 'amuvA1', '7/5/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-01 13:51:41', 'bparksay@netscape.com', 'e8hgcex5gxK', '8/14/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-20 06:32:33', 'kwyrillaz@1688.com', '6XRyBadcOgk', '12/23/2021', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-25 00:17:46', 'gskeffingtonb0@ft.com', 'A4opPWRuj', '4/20/2022', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-05 02:56:27', 'lniccollsb1@hubpages.com', 'XBCpmuEAIs', '8/29/2021', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-28 13:44:38', 'imantleb2@yandex.ru', 'ev8K15k6', '12/31/2021', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-14 09:36:25', 'lrikardb3@themeforest.net', 'zgK57jMf8V3', '2/22/2022', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-10 11:29:49', 'sdenholmb4@aol.com', '9aQCmHEFrOCa', '11/24/2021', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-09 21:33:26', 'grichardeaub5@forbes.com', 'xLkzHWCTE2U', '1/18/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-07 16:17:02', 'rgwilymb6@phoca.cz', 'uBGiERjPg', '3/16/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-09 00:29:08', 'rbruffellb7@indiegogo.com', '4HkKbA', '2/3/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-27 17:51:33', 'kkoptab8@apple.com', 'ph63fc1L', '6/22/2022', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-27 14:33:59', 'rcornehlb9@mlb.com', 'e7uCx7BaE', '12/21/2021', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-20 11:27:31', 'ketherseyba@godaddy.com', 'fdi0JvxW', '6/11/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-25 23:24:12', 'acoppinsbb@economist.com', 'GdCp2S', '2/4/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-25 18:19:37', 'rhutfieldbc@canalblog.com', '99JyaV2qvvM', '2/2/2022', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-09 08:32:13', 'dwhitefordbd@mtv.com', 'Hoa2at', '10/2/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-08 05:34:39', 'btayntonbe@ezinearticles.com', 'nuAWysH', '7/29/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-02 10:26:14', 'gtalloebf@hubpages.com', 'UHhgTA2USw2', '5/8/2022', 46);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-08 14:08:32', 'tfackneybg@creativecommons.org', 'fJoc2gq', '7/11/2022', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-18 18:34:12', 'hitzkovitchbh@last.fm', 'wEYlTwcuZVDF', '5/26/2022', 33);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-08 23:44:44', 'syaneevbi@instagram.com', '1yTO7o2tt', '12/15/2021', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-22 17:36:53', 'nsterleybj@reference.com', 'Ilo3ce', '7/21/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-29 14:12:19', 'cmckertonbk@elegantthemes.com', 'xGW4Q30S', '11/14/2021', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-29 08:50:56', 'rjammesbl@irs.gov', 'B9CzfOqpE1', '12/26/2021', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-17 06:47:21', 'ajoostbm@istockphoto.com', 'BOOHBAkTnJ', '2/27/2022', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-11 09:10:24', 'rmattsbn@icio.us', 'GkpRX6lT', '10/2/2021', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-25 11:42:14', 'dkilgallenbo@exblog.jp', 'N832TK1h', '2/9/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-12 07:23:32', 'asandonbp@wp.com', 'z9B7uJb', '11/12/2021', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-05 16:09:15', 'rdumbltonbq@youtu.be', '2vohtf', '7/19/2022', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 04:05:04', 'vfrancebr@businessinsider.com', '5579oTP7i', '1/13/2022', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-10 00:45:49', 'pfaraganbs@pen.io', 'VeGTL9Nu', '11/30/2021', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-19 05:47:59', 'jspracklingbt@engadget.com', 'QQFmV323iCWy', '8/7/2021', 38);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-30 21:18:20', 'krouthornbu@nba.com', 'bgnWU4YT', '11/7/2021', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-16 19:14:16', 'adoylendbv@constantcontact.com', 'P3fZGf', '3/29/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-24 15:26:07', 'nnortheybw@amazonaws.com', 'FTEs1gGM', '4/28/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-25 19:17:29', 'mcarrettbx@networksolutions.com', 'YWugc4PO', '11/2/2021', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-11 16:32:05', 'ashambrookeby@nba.com', 'xn5kFsCbuCK3', '1/10/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-29 11:12:29', 'mkilbeybz@free.fr', 'QYTOg7jh', '7/26/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-15 00:52:37', 'pfloydc0@uiuc.edu', 'AX2dIM', '3/7/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-29 19:02:11', 'abarchrameevc1@histats.com', '09bif5', '11/15/2021', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-11 13:58:10', 'azannettic2@europa.eu', 'AO9iUoGJSYjh', '3/16/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-27 00:58:52', 'bwarriorc3@geocities.jp', 'RB1C4DVXe7HT', '12/29/2021', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-24 18:03:09', 'bdequinceyc4@wordpress.org', 'Sfr9LwqDE', '4/10/2022', 38);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-08 15:11:37', 'hwhebellc5@salon.com', 'GFhS3erS', '7/30/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-15 00:51:54', 'weadesc6@netvibes.com', 'n9lectBd', '2/12/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-01 08:41:29', 'gdunkc7@vinaora.com', 'csyw7tsyT2Dd', '12/26/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-17 23:19:48', 'bjellimanc8@friendfeed.com', 'luZhDeNe', '3/7/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-02 00:42:12', 'wbrichamc9@123-reg.co.uk', 'sPxvNV4Q', '9/14/2021', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-06 19:50:00', 'dmaassca@webeden.co.uk', 'crEcsaJ4YzeP', '10/30/2021', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-31 11:06:30', 'amellsopcb@dagondesign.com', 'EcJeWWN0', '1/9/2022', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-23 18:54:48', 'hrameaucc@people.com.cn', 'Pkp0BL4Pu', '6/18/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-13 16:07:23', 'btamsettcd@arizona.edu', 'WmcCR9QxCf6', '11/6/2021', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-25 16:22:30', 'talbisserce@msn.com', 'ELa5PI', '6/28/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-02 12:33:12', 'aburgwyncf@about.me', 'iKKRKMBu6C', '7/13/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-20 23:58:29', 'bpicotcg@nymag.com', 'c5ohfh8zP5j', '5/29/2022', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-15 10:28:47', 'bfarlambech@army.mil', 'ZdvfZXxV', '11/11/2021', 33);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-18 15:52:52', 'akelkci@sohu.com', 'id5k0kCxj2G7', '5/19/2022', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-03 18:01:24', 'eferrierescj@utexas.edu', 'zsTFI89lP', '9/13/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-18 03:00:10', 'gtutchellck@nymag.com', 'uW18RzTAZf35', '5/27/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-26 09:46:01', 'ageanycl@lycos.com', 'bB9SjzO8Z', '4/16/2022', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-29 22:00:34', 'nfindercm@sun.com', 'Q3OgL4WfD4', '4/29/2022', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-22 21:17:37', 'ejaumecn@4shared.com', 'JjatKFZgDiw', '3/19/2022', 76);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-05 23:16:50', 'aharcourtco@hugedomains.com', 'eEJlczLL9SD', '8/3/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-19 01:35:39', 'fbockingscp@is.gd', '5R3pz76wXkG', '8/22/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-02 09:40:31', 'scarduscq@imdb.com', 'XRrAAwv0Y', '7/17/2022', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-15 01:45:36', 'ewippercr@google.com.br', 'GlvDzGyDmoo2', '7/12/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-22 20:19:03', 'jthomasoncs@weather.com', 'MORupfOtrWh4', '3/7/2022', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-14 10:59:35', 'tticklect@1und1.de', 'AoLCBodtM', '2/2/2022', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-03 10:43:48', 'uakramcu@alexa.com', '1q0xe6Zf00Do', '7/18/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-05 21:35:32', 'lneweycv@sourceforge.net', 'JZIk9rdrC', '6/8/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-01 04:18:03', 'vnassaucw@weebly.com', '3JpJ5UkOR', '6/6/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-19 08:21:20', 'fstolbergercx@squarespace.com', 'd7REWS', '3/25/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-15 04:10:04', 'oliveleycy@fc2.com', 'I1K3WTy9', '5/28/2022', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-01 20:55:20', 'tbenniscz@hp.com', 'P4sbWd', '1/18/2022', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-23 04:15:06', 'lbugged0@loc.gov', 'uPz1HV', '3/21/2022', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-05 15:54:13', 'smakeswelld1@si.edu', 'uZjSdSMhRBG', '1/4/2022', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-07 08:23:17', 'kporteousd2@netvibes.com', 'LVqJMG', '8/28/2021', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-07 18:29:31', 'sstrothersd3@msu.edu', 'LqLCtw5v8wtE', '8/22/2021', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-11 18:17:16', 'dwoodwindd4@usnews.com', 'WD9aCOyT', '10/8/2021', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-04 19:49:34', 'bstiggerd5@usnews.com', 'gnIK7KV7L', '8/7/2021', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-08 18:58:11', 'bparletd6@nifty.com', 'SPet8OJk', '8/1/2022', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-31 08:05:07', 'awyettd7@java.com', 'RKIw4SiTjsOn', '3/15/2022', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-21 20:08:56', 'rbraunrothd8@statcounter.com', 'QKjXf8CegCQu', '1/14/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-02 06:13:42', 'kcuncarrd9@soundcloud.com', 'CrvdUniUkk', '10/19/2021', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-25 05:10:55', 'rrobertssonda@alibaba.com', 'JONRpW5', '5/28/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-30 23:07:29', 'brimmerdb@google.com.br', '4XnzIoh', '10/23/2021', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-02 23:05:14', 'skainzdc@hao123.com', 'G4GKjKCZ', '10/11/2021', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-25 23:31:54', 'kgerglerdd@harvard.edu', 'huGGqv49Wwr', '7/5/2022', 88);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-24 19:45:21', 'csantonde@infoseek.co.jp', '5FozdYuGyi', '11/29/2021', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-08 13:25:25', 'irosettidf@xinhuanet.com', 'ktwxlV', '4/18/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-23 07:51:45', 'bharbackdg@simplemachines.org', 'GfDE5c', '9/28/2021', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-15 22:13:36', 'oredfernedh@mac.com', 'jSSF4N', '8/5/2021', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-16 07:53:36', 'lguerridi@comcast.net', 'dVCeUMjPG', '6/28/2022', 46);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-28 00:16:13', 'mgiddendj@stumbleupon.com', 'yU9zBhHvlBCZ', '12/27/2021', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-29 17:41:46', 'dseagerdk@buzzfeed.com', '1dYdpEoT', '1/11/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-13 11:28:16', 'mmckaguedl@answers.com', 'IN3EH2cy', '4/1/2022', 36);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-21 03:53:54', 'mdooguedm@tamu.edu', 'bV2yc52u8u', '11/1/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-23 11:36:15', 'amercikdn@yahoo.com', '0Bwd9XgpD4F', '3/4/2022', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-17 22:29:40', 'mbarwisdo@hud.gov', 'k0ujZB8ZW1', '2/14/2022', 46);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-12 01:40:54', 'sdorgondp@gov.uk', '7wRtgXD', '1/31/2022', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-25 23:54:29', 'dsimunekdq@google.co.uk', 'HGL7IJC', '3/23/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 07:49:12', 'vschreursdr@aol.com', 'AE9cDRz1sKN', '2/22/2022', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-21 11:33:06', 'jsonnenscheinds@over-blog.com', '9WvHaGIFBY', '6/17/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-07 03:12:39', 'sharkinsdt@wsj.com', 'AYxv9TJllb', '10/10/2021', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 22:19:48', 'asymcoxdu@reuters.com', 'WBY8LDbrv', '3/2/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-18 17:12:09', 'asmythindv@desdev.cn', 'HE98B76MlWR', '4/16/2022', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-18 16:26:59', 'sdowersdw@foxnews.com', 'x0vrcyhF', '9/13/2021', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-17 21:17:17', 'dcallowdx@nydailynews.com', 'QV8d6JURbTHs', '2/11/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-26 06:52:19', 'zcooksondy@youtube.com', '9rwDYre', '8/11/2021', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-17 16:23:29', 'thazelbydz@dagondesign.com', 'NDrRSXeD', '3/18/2022', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-22 12:07:14', 'ccridgee0@theglobeandmail.com', 'utKK47dTj', '3/25/2022', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-11 09:09:13', 'bdowalle1@unesco.org', '9gT5XKotUvSC', '9/2/2021', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-21 11:39:17', 'ltomblingse2@amazon.com', 'UO4nvXIZ', '2/25/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-30 17:48:13', 'kgilardonee3@ocn.ne.jp', '80lGjEkXt2d', '7/14/2022', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-21 01:13:44', 'cladymane4@buzzfeed.com', 'd7osX6s', '11/28/2021', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-15 19:58:08', 'ofehnerse5@purevolume.com', 'o1T0gY4tzF', '6/29/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-30 17:07:38', 'ssailee6@google.cn', 'UH7tKixowdk', '3/29/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-08 23:56:23', 'kmaclicee7@un.org', '0dNy5iII2a', '9/2/2021', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-30 21:13:23', 'mstentone8@github.io', 'D6g2G0cW', '3/17/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 18:24:51', 'fasberye9@youtu.be', 'AdtggVuFaS', '10/9/2021', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-22 13:24:44', 'sobradaneea@desdev.cn', 'kqfmpn', '12/12/2021', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-16 06:07:25', 'acoxwelleb@xinhuanet.com', 'l02pLyOexZn', '1/21/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-20 22:53:14', 'vfargherec@chicagotribune.com', 'Kn02xk7Rx', '2/10/2022', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-14 13:37:03', 'nhuntressed@merriam-webster.com', 'YsbHmxHQ1h', '3/8/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-15 15:27:16', 'lobispoee@who.int', '1lE2NP1x', '2/11/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-30 13:54:52', 'kquintonef@senate.gov', 'e4rRzZ9auMZ', '8/16/2021', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-19 01:20:18', 'lcockrelleg@edublogs.org', 'Rp7pNlBGlA', '3/6/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-05 06:26:59', 'kgironeeh@bbb.org', 'ZPzHV6Ik', '12/4/2021', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-01 04:16:50', 'hgabbetisei@mapquest.com', 'L7UETZx0GuD', '10/10/2021', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-13 06:01:50', 'cemonsej@youtube.com', 'Bn1Gwwxf', '8/4/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-21 03:43:58', 'mramsbothamek@clickbank.net', 'b5uyXVS6', '9/17/2021', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-09 02:33:55', 'dnewcomel@discuz.net', 'pDYwLYVW8s', '1/19/2022', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-28 16:20:25', 'guzzellem@mtv.com', 'Kt6nQwKeBWf', '6/9/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-29 16:23:12', 'kpriteren@dmoz.org', 'DY3vlZlR5Gb0', '12/19/2021', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-15 06:58:55', 'blowthereo@house.gov', 'TwPUQBU', '7/11/2022', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-20 23:26:47', 'kbagnellep@ebay.com', 'UMvFWeGAgO', '5/5/2022', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-11 04:22:07', 'vstrathdeeeq@lycos.com', 'xMl5suDcaN51', '1/28/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-26 13:23:50', 'anoviker@unicef.org', '908yDfMpkU8', '6/14/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-08 23:27:27', 'hpaddisones@ameblo.jp', 'bTVgwvHpwy5R', '9/3/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-20 00:39:49', 'aeusdenet@ifeng.com', 'CHtscDIz2', '2/14/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-20 03:59:33', 'glittleeu@webeden.co.uk', 'Dz80a0', '6/15/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-04 01:58:38', 'agergelyev@bravesites.com', 'O18bATfV', '7/28/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-07 13:53:18', 'gpetrakew@ucoz.ru', 'fWizkii', '11/17/2021', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-15 13:56:50', 'lchurmsex@harvard.edu', 'HWY6jgaAVWJ6', '12/21/2021', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 14:34:40', 'ydyettey@apple.com', 'wkc6Em1', '4/2/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-17 01:25:36', 'aphythianez@house.gov', 'ynru1JpUxt', '2/3/2022', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-19 06:16:27', 'cmcveaghf0@friendfeed.com', '4KGIod4Ciu4K', '12/22/2021', 36);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-10 12:43:16', 'ccostanf1@hud.gov', 'Fl5XfJTo53m1', '6/5/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-17 09:29:57', 'lsleepf2@dropbox.com', 'wCs3kp9N', '9/17/2021', 34);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-19 08:06:24', 'bimmsf3@cbc.ca', 'owLgAgaEa', '8/21/2021', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-04 18:46:11', 'bkeslakef4@pagesperso-orange.fr', 'JyDSKUugJ', '11/22/2021', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-07 19:25:06', 'lmacfaellf5@slate.com', 'nSpovtXNqY5d', '11/18/2021', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-29 03:34:05', 'jelecumf6@technorati.com', 'FfWzdjywl', '2/6/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-16 04:23:12', 'gkingslyf7@w3.org', 'RUsz7WSX1UX', '3/19/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-18 11:22:25', 'dembraf8@fc2.com', 'J7n6ttrk1zsQ', '9/7/2021', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-22 12:30:56', 'agouthf9@plala.or.jp', 'M99hn0', '10/4/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-14 07:27:39', 'ejamesfa@eepurl.com', 'wosSVgf16U', '10/5/2021', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-07 13:05:41', 'ncorserfb@admin.ch', '3P5cdK', '9/11/2021', 88);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-12 03:40:25', 'glaphamfc@europa.eu', 'ozCcV7Yko21', '1/29/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-24 16:29:24', 'eberreyfd@sakura.ne.jp', 'uBz8ohYj0e', '2/7/2022', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-20 08:08:40', 'ehowchinfe@amazonaws.com', 'BiHnVFoJ', '10/19/2021', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-12 10:18:08', 'mgonzalvoff@latimes.com', 'rKJGRQ', '3/16/2022', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 03:09:06', 'mshinnfg@archive.org', 'iMWG1M', '3/11/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-08 19:21:37', 'fyewdallfh@utexas.edu', '0bnsdPJHihq', '8/24/2021', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-14 05:46:57', 'bmellorfi@mlb.com', 'jn38Xwgox', '12/12/2021', 8);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-13 11:49:50', 'btersayfj@mac.com', 'SWeOjUPt', '1/18/2022', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-08 05:57:48', 'ranneyfk@ning.com', 'G0xLS93snG', '6/6/2022', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-15 09:57:35', 'srenodenfl@addthis.com', 'XHrevd', '5/18/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-24 21:41:07', 'cvolantfm@mail.ru', 'gwHadu0', '11/8/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-31 15:48:48', 'mdurrancefn@networkadvertising.org', 'c9a4EYIZ', '1/12/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-20 11:58:33', 'hlynnittfo@latimes.com', 'zvmqSe', '11/9/2021', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-02 10:50:10', 'aboikfp@auda.org.au', 'h7QUtRHKo', '10/12/2021', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-08 10:36:36', 'ltuberfieldfq@deviantart.com', 'fXwvku60X', '3/10/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-22 19:51:46', 'syoudefr@clickbank.net', 'Zax05fvOwRm2', '7/7/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-25 15:47:59', 'bduffittfs@usgs.gov', 'fvDdf7eumoMn', '2/26/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-17 17:04:44', 'hclemittft@sakura.ne.jp', 'piduGuNEEIgE', '11/9/2021', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-26 05:33:51', 'tropkinsfu@independent.co.uk', 'gJjXgS', '6/29/2022', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-04 12:18:28', 'bsyplusfv@networkadvertising.org', 'p6GHumn61', '10/25/2021', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-24 07:32:33', 'sharstonfw@columbia.edu', 'IMsrnY2BSn', '3/28/2022', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-03 00:12:30', 'sbackshawfx@about.com', 'c55JrC', '12/21/2021', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-23 10:23:33', 'fvarleyfy@a8.net', 'pXFW6pW', '3/20/2022', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-31 15:44:28', 'jnaylorfz@theglobeandmail.com', 'nwy58cmMNIJ', '2/8/2022', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-13 22:52:22', 'sklagemang0@ox.ac.uk', 'h6lHWb', '7/29/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-12 06:52:15', 'kgailorg1@mlb.com', 'jhNPQZZJM2', '2/6/2022', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-03 06:39:27', 'oweblandg2@goodreads.com', '5ipFm0PN', '12/12/2021', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-04 13:00:40', 'olemarchantg3@yellowbook.com', 'm7hoAkeG5', '9/28/2021', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 15:27:33', 'ecurleyg4@state.gov', 'HCxlOGsYPX', '8/7/2021', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 10:48:10', 'jbecomg5@examiner.com', 'q01gLFYB', '4/23/2022', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-10 21:20:35', 'cbenkog6@blogs.com', 'vC0W0lSGYK', '2/14/2022', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-14 13:32:25', 'ascallong7@creativecommons.org', 'w1SJC9qf', '12/21/2021', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-12 01:32:56', 'mconreg8@google.pl', 'uZxxUquL8l', '3/27/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-02 18:06:19', 'mbuckthoughtg9@squidoo.com', 'wnSOa7k4', '8/20/2021', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-06 13:18:37', 'khickga@cnet.com', '8s2gKJ8IOMr', '4/28/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-16 19:28:47', 'zgoodrickegb@dyndns.org', 'mKlggDhRN', '11/18/2021', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-22 21:14:00', 'csussamsgc@sogou.com', 'Tipjo1Ug', '3/29/2022', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-14 16:16:34', 'rbarochgd@opensource.org', 'y8nYXD', '4/24/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-27 22:46:39', 'gaxelbeege@yale.edu', '6weyurBArm', '7/6/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-15 06:19:42', 'phoylegf@wordpress.com', 'KVQJfFu', '8/16/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-07 18:34:40', 'abamfieldgg@people.com.cn', 'PpkIYfVg6Etw', '6/29/2022', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-27 19:53:06', 'ninmettgh@zdnet.com', 'nQKY9b1kGsVV', '4/21/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-26 15:34:52', 'ldurtnalgi@theatlantic.com', 'U5Ied4uAbrz', '11/30/2021', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-16 22:05:30', 'cpaysgj@blogspot.com', 'T3INlz', '10/26/2021', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-08 08:31:35', 'gledgistergk@last.fm', '5JQgUAkM', '1/25/2022', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-28 04:03:27', 'bwelburngl@skyrock.com', 'iFEgcBUKyK', '10/20/2021', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-21 02:14:17', 'scorwingm@google.de', 'NZWJAsvZTYZ4', '10/16/2021', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-31 03:48:59', 'bparsonsgn@4shared.com', '145O2Jz', '11/2/2021', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-22 23:54:55', 'rlinggoodgo@diigo.com', 'sUKjch6sNy', '4/2/2022', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-05 03:49:21', 'fameygp@bluehost.com', '9t3BGUcc', '4/26/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-14 04:20:56', 'bkhristoforovgq@weebly.com', 'CDI5hhk90', '4/26/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-11 20:47:39', 'mfilipputtigr@example.com', 'OIZZSuyTq9', '11/18/2021', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-25 14:07:11', 'fholberrygs@geocities.com', 'kUZmW9JFi', '3/30/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-06 17:33:26', 'sedgintongt@fc2.com', 'pvEn2WObwSIi', '6/23/2022', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-20 11:47:53', 'rblaineygu@upenn.edu', 'QoEoUr7awg', '9/8/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-08 11:11:06', 'jbatallegv@google.pl', 'x6YVr0', '1/10/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-19 16:58:21', 'hboheagw@a8.net', 'CVaVYk', '11/27/2021', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-26 15:41:08', 'mliebgx@accuweather.com', 'gtadAP3WkYbx', '10/18/2021', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 17:35:19', 'pelsburygy@paginegialle.it', 'sfFHpQE', '3/23/2022', 76);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-06 03:14:16', 'aandertongz@ucoz.ru', 'fIiGIYHMcl0U', '4/30/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-14 00:01:45', 'hhowsamh0@chicagotribune.com', 'u0IOhTrAPlff', '9/29/2021', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-27 21:14:39', 'dgianneschih1@whitehouse.gov', 'mCiPwyvkAdft', '8/27/2021', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-17 17:22:08', 'mtayth2@salon.com', 'sKXca1', '7/5/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-19 23:10:58', 'mtupph3@livejournal.com', 'FFjJFTEaG', '3/15/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-11 23:19:35', 'ktremmelh4@google.es', 'TzfJAvU', '8/1/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-09 08:15:38', 'lparkmanh5@mac.com', 'FuHH0Jm2xqg', '5/5/2022', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 08:29:40', 'anendh6@dailymail.co.uk', 'KwJftB4wV1ZN', '8/4/2022', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-18 22:17:21', 'jtumpaneh7@nps.gov', 'MhW2n1yytL', '9/17/2021', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-14 19:22:11', 'jduleyh8@latimes.com', 'ROJhLuqcpV', '3/6/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 00:20:23', 'awillowsh9@princeton.edu', 'Wzx8S3A0HXGF', '5/19/2022', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-09 10:16:26', 'rtinkerha@unc.edu', 'u8eYuSbH', '10/13/2021', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-27 20:46:58', 'pwicketthb@usgs.gov', 'jG4HDU8gLYTC', '1/21/2022', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-10 07:11:09', 'spulsfordhc@pcworld.com', 'fgc1NFCD', '10/1/2021', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-12 14:30:40', 'clambrookhd@wordpress.org', 'Tc1ugaCmoV', '7/4/2022', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 06:21:16', 'dronaghanhe@yellowpages.com', 'Rk8GcjeeNnrR', '7/11/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-10 12:57:34', 'egarnarhf@mayoclinic.com', 'J8P5HOwqlM', '10/28/2021', 35);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-09 04:02:24', 'plitherlandhg@livejournal.com', '7Mh8qkB4tTBh', '7/10/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-24 12:52:28', 'eblackborohh@npr.org', 'zG7V1VaR', '11/22/2021', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-23 10:57:05', 'wbethamhi@howstuffworks.com', 'jF6w9tabIin', '11/8/2021', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-23 04:59:01', 'bcowndleyhj@github.io', 'UQHf07', '4/21/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-09 03:22:46', 'agethenhk@addthis.com', '3Rw4rH', '3/4/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-20 04:39:35', 'bcrockfordhl@ebay.com', 'ARwwVVlZ', '9/20/2021', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-22 02:39:37', 'bfaustianhm@histats.com', 'wfavMkFIl', '1/26/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-03 22:04:47', 'cpietrzykhn@marriott.com', 'WwL4qPz', '3/12/2022', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-13 07:26:56', 'bdenajeraho@clickbank.net', 'BQpZUHfoc', '5/1/2022', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-23 18:24:44', 'temblinghp@dailymail.co.uk', 'JmlwpsWVs6nJ', '3/31/2022', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-05 07:47:49', 'hcaghanhq@scientificamerican.com', 'IHiiDI', '8/28/2021', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-08 20:28:45', 'lcowplandhr@w3.org', 'QLQN2mrZ', '8/12/2021', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-17 20:53:53', 'jfortiehs@flickr.com', 'JFtR0lZ', '2/8/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-12 04:18:38', 'lhabardht@ox.ac.uk', 'HohM1a', '12/4/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-05 04:55:33', 'jelsonhu@delicious.com', 'birOhb', '1/16/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-07 03:49:35', 'hnutbeamhv@shutterfly.com', '4gYrkW', '3/14/2022', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 17:19:44', 'efoldeshw@facebook.com', 'CRiwZzu', '1/16/2022', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-23 22:45:42', 'ksatyfordhx@google.ru', 'lMgktKg', '12/3/2021', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-22 16:26:11', 'kgailhy@wikispaces.com', 'bgL2RsBbXom5', '9/3/2021', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-10 11:29:28', 'mflahyhz@chron.com', '6upXrQAjZa', '7/17/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-14 02:24:44', 'useabridgei0@sphinn.com', 'epMPnhEqOuQY', '6/3/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-27 20:07:51', 'sspadai1@gizmodo.com', 'IytoAS', '3/5/2022', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-01 16:57:36', 'pbagehoti2@surveymonkey.com', 'dVvvolIeRU4', '10/17/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-16 08:51:39', 'eduberyi3@behance.net', '2KANo3Sgq', '10/12/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-21 16:57:52', 'tlivicki4@e-recht24.de', 'o18gigFAE', '12/6/2021', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-13 23:51:12', 'vbambi5@dell.com', '9LEQ5F', '6/5/2022', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-25 03:53:37', 'tlatani6@de.vu', 'uuVxg6Vbioa', '2/22/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-17 07:54:54', 'kbulfordi7@spotify.com', 'UWsOSY', '7/8/2022', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-02 03:22:59', 'bkiddelli8@posterous.com', 'sIguXJ5rA', '6/18/2022', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-30 14:26:27', 'tdeweyi9@bravesites.com', 'EJpPzOH2bHO', '1/15/2022', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-12 15:14:01', 'rspatigia@illinois.edu', 'GhFlRXR', '8/13/2021', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 18:03:11', 'cligertonib@google.com.hk', 'zrkQuQA2Vo', '9/15/2021', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-26 08:05:26', 'geulic@upenn.edu', '8GT1etEH1mTd', '1/15/2022', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-29 22:09:29', 'bamthorid@squarespace.com', 'YAGyD7r', '7/1/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-19 19:59:47', 'rpinningtonie@amazon.co.uk', '2iznFwe4RDp', '1/7/2022', 95);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-22 09:31:26', 'flouwif@ning.com', 'niasvnEaJrsg', '7/6/2022', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-03 09:26:53', 'wkunatig@deliciousdays.com', '0Zy86A', '6/5/2022', 33);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-14 10:03:19', 'dschoroderih@ibm.com', 'mtF3wW4mG', '3/22/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-23 09:42:47', 'troubottomii@storify.com', 'RKbD9i0kDv', '12/29/2021', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-01 03:14:53', 'amaffeyij@tripod.com', '4ce6qkp', '2/13/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 08:55:42', 'nbacksik@amazon.de', 'P7bquciND', '8/13/2021', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 17:20:59', 'dolennaneil@irs.gov', 'CTG5SgnejjJ', '7/23/2022', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 09:53:06', 'jmahyim@reverbnation.com', 'bAKZ81WN', '7/28/2022', 4);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-20 08:43:55', 'rrijkeseisin@amazon.de', '2U5byrzDUjT', '2/17/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-10 22:13:34', 'wnortunenio@icq.com', '8e0lGB', '3/24/2022', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-22 00:40:37', 'ncraftip@blinklist.com', 'rfpoiX75hO6z', '4/20/2022', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-07 03:58:28', 'kcharretteiq@msu.edu', '8b6lkJDmN', '10/23/2021', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-26 04:31:32', 'lhamlettir@umich.edu', '2xDbPIW6Be', '2/8/2022', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-05 03:10:25', 'kklempsis@columbia.edu', 'E0gpujMqVtG', '10/4/2021', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 11:51:16', 'barmorit@ameblo.jp', 'FvGp3Zq8qk', '11/19/2021', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-16 10:54:32', 'sparradyeiu@rakuten.co.jp', 'sOsRNH289ZA2', '10/3/2021', 38);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-31 04:08:35', 'abockmaniv@wisc.edu', 'vAz1OssQ', '1/30/2022', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-14 21:38:03', 'msplevinsiw@yellowpages.com', 'ntAIwRf8gl', '7/4/2022', 14);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-02 12:57:35', 'hruzekix@homestead.com', 'SIJKwwL', '1/20/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-02 00:35:59', 'kbussensiy@weebly.com', 'Sogex3eLPsJy', '11/11/2021', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-09 21:52:15', 'ceyamiz@narod.ru', 'knAEmlYd', '7/25/2022', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-04 11:58:44', 'adinneenj0@issuu.com', 'zhdn3oaqJ', '5/24/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-31 17:02:51', 'mglasscooj1@icio.us', '13PYGELr', '8/19/2021', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-10 00:59:46', 'ckingtonj2@walmart.com', 'h8zUzXOvwE', '6/14/2022', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-05 19:06:25', 'brosenblattj3@jigsy.com', 'hHUiUjZ', '11/24/2021', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-07 20:31:43', 'vpitonej4@google.it', 'Xptc9e2XCP18', '2/17/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-04 12:36:10', 'ftarbattj5@reference.com', 'GExDNi', '2/17/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-07 21:17:07', 'sschechterj6@boston.com', 'C45cvXks', '4/22/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-14 03:16:27', 'ebotterellj7@feedburner.com', '9e31jQ4', '11/14/2021', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-23 15:22:55', 'ehearfieldj8@51.la', 'cy9TQIoG', '4/1/2022', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-13 22:34:36', 'adarkoj9@geocities.com', 'aRXWvA6', '11/21/2021', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-30 18:53:23', 'hpetzoldja@purevolume.com', 'TKH0JIm67', '5/14/2022', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-07 17:45:06', 'dandrellijb@boston.com', 'TS2HwlbVztIY', '11/4/2021', 38);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-05 02:53:15', 'btomovicjc@drupal.org', 'lkQhdalGgz', '12/10/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-14 01:25:44', 'kkunklerjd@nyu.edu', 'aL54bA', '3/18/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-20 00:51:07', 'otrenchardje@cloudflare.com', 'g2xBu77vP0', '8/14/2021', 88);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-25 13:39:22', 'rknattjf@uiuc.edu', 'nGO039', '1/29/2022', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-02 12:30:29', 'ssvanettijg@yahoo.com', '1kYni1yfo2B', '3/15/2022', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-04 15:57:40', 'acalvenjh@intel.com', 'F9MjLvRTzdV', '5/6/2022', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-22 21:39:04', 'kdebernardiji@bluehost.com', 'SHaSn79q', '7/20/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-19 09:29:37', 'mtidbaldjj@yolasite.com', 'urvDeuQuk4e', '7/17/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-25 20:49:49', 'cfirmagerjk@amazon.de', 'YbQtxu', '2/8/2022', 33);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-08 08:32:31', 'elockettjl@php.net', 'jPVeZu', '4/21/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 02:29:15', 'mkunatjm@wikipedia.org', 'JuH3uxeJw3NS', '10/19/2021', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-07 03:06:28', 'mshiresjn@squidoo.com', '0822jD341', '1/18/2022', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-10 20:22:34', 'csnapejo@unblog.fr', '1k1PpZ8', '1/28/2022', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-05 16:50:38', 'dlefeaverjp@themeforest.net', 'odXuDm', '12/16/2021', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-15 19:07:48', 'ajaynejq@dell.com', '5vyiIhW', '3/10/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-27 06:31:22', 'nchidlerjr@cam.ac.uk', 'GXCc8hktls', '4/19/2022', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-16 04:27:18', 'rportrissjs@simplemachines.org', '3KjyJFZsL0LO', '12/12/2021', 33);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-30 02:16:55', 'ochaytorjt@vistaprint.com', 'Rxdh0ZpMKKQ', '8/6/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-02 16:40:56', 'rackeroydju@cargocollective.com', 'KTJaz2b', '12/1/2021', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-01 18:09:43', 'ttwiggerjv@wsj.com', 'UONrgwE', '3/29/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-20 23:47:30', 'kspencookjw@vimeo.com', 'Yr2MBlAV5z', '7/22/2022', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-03 08:30:56', 'fmccrohonjx@e-recht24.de', 'namW916Q2wN', '7/24/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-13 14:57:41', 'cwaterlandjy@biglobe.ne.jp', 'dwAuadm', '1/9/2022', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-10 03:38:45', 'jpietersjz@biglobe.ne.jp', 'hPWxts2EB', '8/12/2021', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-18 17:31:45', 'btortisk0@sun.com', 'WLp1ox41FrZ', '5/7/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 01:24:24', 'gcleminsonk1@nba.com', 'VUj4Yb', '8/3/2022', 76);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-16 07:19:38', 'msimonouk2@dropbox.com', '3yzHRZuMDtk', '3/8/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-08 20:04:15', 'rgledstanek3@google.com.au', '4P0VFv', '4/7/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-02 12:18:12', 'dmcnallyk4@illinois.edu', 'iK67p1BH', '6/30/2022', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-23 22:12:48', 'bbillettk5@seesaa.net', 'hpJi89M', '12/27/2021', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 04:47:02', 'mpetegrewk6@tinyurl.com', 'ZxoNL3HtzYUG', '6/3/2022', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-17 16:49:22', 'cguillotonk7@japanpost.jp', 'MTWIW05G6LZ', '2/19/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-26 08:42:47', 'ncannerk8@wikipedia.org', '2xSixe13', '1/9/2022', 46);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-30 09:55:42', 'ppoppingk9@123-reg.co.uk', 'Ad5j7FXUp', '7/12/2022', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-13 22:39:49', 'aparamoreka@jiathis.com', 'Yq4eYmcC', '2/17/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-11 02:19:07', 'vhailkb@senate.gov', 'bgtfQZV', '11/15/2021', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-29 05:44:26', 'bahernkc@sourceforge.net', 't8H4YTZN0t', '6/16/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-07 04:13:52', 'sabrianikd@g.co', 'HobM3JLX4elm', '12/6/2021', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-26 09:38:04', 'asillyke@blinklist.com', 'BmvmIzb3fq', '8/12/2021', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-04 01:48:13', 'vgimberkf@msn.com', '6ybWepySn', '12/20/2021', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-20 17:26:52', 'mmethringhamkg@ucoz.ru', '5YqWxtCpSn', '12/12/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-01 01:09:31', 'pkennhamkh@berkeley.edu', '7zJwazwD', '5/15/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-12 01:01:11', 'gcoltonki@bluehost.com', 'OhLzJT0I0', '3/7/2022', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-12 10:07:07', 'scristofvaokj@hatena.ne.jp', 'F4JaFZDZ', '10/25/2021', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-01 02:19:56', 'cmurtaghkk@cargocollective.com', 'QJetr2Ozdgq5', '5/22/2022', 59);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-07 19:53:19', 'ablinmankl@unc.edu', 'XzBOzvW', '3/10/2022', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-26 10:37:16', 'hflintkm@gov.uk', 'YWz192', '8/3/2022', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 09:05:37', 'efosskn@telegraph.co.uk', 'Ctq2WQ', '1/12/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-03 08:02:59', 'sferriesko@comsenz.com', 'yUmGxi', '8/12/2021', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-30 01:59:23', 'mmccambroiskp@indiegogo.com', 'hvY4G7kkT', '10/3/2021', 61);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-02 07:53:22', 'rmapeskq@technorati.com', 'Ac0JBY80AdI', '2/17/2022', 46);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-29 07:04:04', 'blortzingkr@t-online.de', 'rpxS5pg3g', '10/14/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-04 12:27:43', 'jdehmelks@mysql.com', 'twvQyJ', '12/5/2021', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-27 20:06:15', 'jcomberkt@amazon.de', 'oUfPM2l', '7/11/2022', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-06 01:20:53', 'akuhnertku@telegraph.co.uk', 'tWxGRi2YTe', '3/2/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-05 09:30:58', 'ecampkinkv@lycos.com', 'bordceuLEDw', '5/11/2022', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 10:03:03', 'mpanyerkw@wisc.edu', 'lKEcuiwmvfLF', '12/5/2021', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-16 22:26:00', 'cseelbachkx@ox.ac.uk', 'zqf3Rk39iPC', '1/8/2022', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-08 08:56:26', 'mchipchaseky@nps.gov', 'NJ2fPyJ6Wvx', '10/5/2021', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-23 07:29:12', 'agrigorescukz@artisteer.com', 'GdZPLsh', '7/6/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-13 05:01:35', 'cchappelll0@spiegel.de', 'zU1bIEHORSl2', '7/22/2022', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-06 06:41:09', 'lgowanlockl1@zdnet.com', 'KfeyGb', '11/26/2021', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-28 07:55:50', 'eraschl2@cdc.gov', 'G9YloIc', '4/29/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 17:25:16', 'sjosel3@dyndns.org', '2oS5KtUWDSIe', '3/30/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-09 11:38:18', 'rbowickl4@plala.or.jp', 'YhUptVclw3', '7/26/2022', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-10 03:06:59', 'rrhucroftl5@baidu.com', 'vyCXtH12dq', '3/10/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-10 07:44:32', 'ppaolettil6@opera.com', 'hNn20Hzrd', '8/7/2021', 16);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-12 00:19:30', 'nproswelll7@pbs.org', 'jqdPUyKSd', '10/26/2021', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 14:09:59', 'dgourlayl8@jimdo.com', 'ew41Wgit', '10/17/2021', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-21 21:30:50', 'hfantl9@forbes.com', 'SAmOpfwP', '11/5/2021', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-13 10:57:21', 'bbernardeaula@fema.gov', '6GjEtHjZofLO', '5/26/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-02 08:55:30', 'slembckelb@chicagotribune.com', 'zVDrSZScXEkW', '10/27/2021', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-24 02:30:00', 'ubahialc@wisc.edu', 'Tb4wXyUBgbj', '4/16/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-18 03:02:47', 'tstringerld@accuweather.com', 'fm5N6g2pZ2', '4/6/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-15 07:30:18', 'aeagellle@usatoday.com', 'LzvO3xeEuHT', '11/1/2021', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-08 02:04:06', 'aadenotlf@devhub.com', 'IuH0AoJT', '9/16/2021', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 03:28:35', 'urepplg@ycombinator.com', '5xsqQBRM85', '5/12/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-13 08:31:52', 'kgennerlh@meetup.com', 'RnVGdFkBC8', '7/3/2022', 61);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-29 10:58:50', 'mdietmarli@hao123.com', 'Kbaj6xRZ', '7/29/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-22 06:57:42', 'ibruntjelj@stanford.edu', 'jwkw32a6Muiw', '10/13/2021', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-09 23:58:50', 'lstobielk@miibeian.gov.cn', 'x5xgwvkwkgl', '9/13/2021', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-23 18:31:09', 'isturleyll@wikimedia.org', 'JF0ycsLwEF0', '4/5/2022', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-05 09:43:15', 'aaldamlm@cbsnews.com', 'r4akdkmyujp', '2/19/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-02 11:14:02', 'bswetmanln@ihg.com', 'cD3K7cQ', '2/12/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-23 06:48:44', 'hodunniomlo@umn.edu', 'XfLN79Xb', '9/10/2021', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-06 18:24:41', 'clipscombelp@mapquest.com', 'zyIpDm7q', '10/28/2021', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-12 15:22:48', 'iwaislq@live.com', 'UHZeVV', '3/15/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 22:43:50', 'amounfieldlr@rakuten.co.jp', 'u2AAHYiW', '6/27/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-22 10:31:37', 'whabardls@163.com', 'sGZg4khCN', '11/28/2021', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-02 09:10:19', 'bkinradelt@mayoclinic.com', 'aubXTP4QpB4', '7/23/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 15:08:03', 'rgreenhaughlu@de.vu', 'eXftBDQQV1G', '6/19/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 02:21:20', 'kstuchburylv@ucoz.com', 'Rz1GWrY', '7/31/2022', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-18 23:21:34', 'nfardenlw@scribd.com', 'oQ2Ul5S', '3/20/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-10 01:58:15', 'eboicelx@samsung.com', 'XeamfAwKVhvM', '5/19/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-28 04:39:24', 'rskeelly@webmd.com', 'ks7dKd0QDBDp', '9/16/2021', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-24 03:17:39', 'fshadboltlz@dyndns.org', '7CJhXR32', '2/14/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-06 22:07:06', 'ekeiltym0@mail.ru', 'J5fNrmRVZ', '6/5/2022', 21);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-08 14:42:32', 'dwillersonm1@cbsnews.com', 'JRd7DzMTdJ1', '3/26/2022', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-30 14:59:06', 'siliffem2@w3.org', 'id7LwSUSLIt', '9/17/2021', 61);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-24 15:54:24', 'slenniem3@bbc.co.uk', 'I8ElNt9C6', '3/13/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-20 11:59:52', 'arowthornm4@bizjournals.com', 'GfqABI3z', '10/17/2021', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-20 22:54:38', 'ajennom5@google.cn', 'udDtbDW3', '5/13/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-16 05:39:55', 'phumbeem6@clickbank.net', 'rF4uOXrxTkXz', '8/11/2021', 61);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-06 05:34:09', 'lpossam7@noaa.gov', 'wSZaTA9TUA', '7/4/2022', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-20 20:47:38', 'sfancuttm8@behance.net', 'gqssd6qfO', '7/28/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-08 17:36:10', 'wfidgem9@smugmug.com', 'O0VKaZNFPfN', '8/16/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-31 14:40:34', 'kkesonma@alexa.com', 'dmOl11OCj75', '9/17/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-18 19:12:09', 'dpucknellmb@dell.com', 'fS19Zyi', '8/22/2021', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 00:53:06', 'cleopoldmc@yellowbook.com', 'ysT0UpdPV', '9/20/2021', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-11 16:47:29', 'sgrenshielsmd@mayoclinic.com', 'r5ANMeGa7Ee', '7/10/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-30 16:46:05', 'hjankinme@umn.edu', 'dKFqz3IZ', '7/22/2022', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-09 11:13:07', 'ymelrossmf@vinaora.com', 'MDWGBg', '9/21/2021', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-21 04:51:25', 'nseamonsmg@xinhuanet.com', 'ky8CqEjw0pE', '1/11/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-24 02:40:39', 'gbriteemh@forbes.com', 'qh4hADtzNURT', '7/24/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-31 08:03:03', 'ckillingbeckmi@list-manage.com', 'JI5N6k', '3/12/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-21 11:11:41', 'ipenningmj@admin.ch', '0KWWQPE', '5/31/2022', 76);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-28 16:17:26', 'targentemk@youtube.com', 'VyryAySG', '4/13/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 16:42:32', 'foddml@barnesandnoble.com', 'bgFw0BBx', '11/19/2021', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-09 15:46:39', 'schawkleymm@squarespace.com', 'fboD376DR', '6/29/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-15 22:35:15', 'lmacnairmn@dropbox.com', 'S6CWP4', '8/10/2021', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-18 08:17:10', 'mgaffneymo@uiuc.edu', 'XM0ESBRMnZ3', '4/18/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-17 10:13:20', 'lduttonmp@google.fr', 'Ayxhnlg1TLn', '9/5/2021', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-15 22:34:59', 'ntownsendmq@globo.com', 'cg4qbPjCWO', '7/7/2022', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-18 08:54:17', 'lagermr@dion.ne.jp', 'OKvhNT2', '5/1/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-09 15:42:46', 'boubridgems@about.me', 'gan6p7pCsm5', '10/14/2021', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-30 10:38:50', 'jcompfortmt@geocities.com', 'N46EZt', '2/10/2022', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-26 05:23:56', 'gkeningleymu@businesswire.com', 'CAbsQwuhJzA', '5/22/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-29 00:33:09', 'trowcliffemv@latimes.com', '4PryqfVhMK', '12/3/2021', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-28 03:15:16', 'handrzejowskimw@altervista.org', 'y3kUuGXwZhsL', '3/23/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-05 00:57:54', 'nstuckesmx@macromedia.com', 'wJ2iKkE6', '11/19/2021', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-21 15:18:58', 'amcallanmy@uiuc.edu', 'ojCGl63', '5/8/2022', 30);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-28 23:34:21', 'gcozzimz@cocolog-nifty.com', 'VYtXcj', '4/5/2022', 56);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-27 21:09:54', 'jbricknern0@ifeng.com', 'HbqBAWnE', '1/21/2022', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-25 20:28:05', 'easplingn1@sogou.com', 'SeXlDdDB3', '2/12/2022', 63);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-01 11:38:04', 'sdurdlen2@cbsnews.com', 'Ae8Ih4qLPK4', '1/24/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-05 03:40:33', 'amatusn3@trellian.com', 'UFr5CYIbTaU', '3/31/2022', 99);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-20 17:27:05', 'gbastardn4@hostgator.com', 'Q9Quv9', '6/7/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-01 03:34:09', 'llinneyn5@biblegateway.com', 'gD1Bvsuc', '11/28/2021', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-21 15:18:39', 'gmckeurtann6@go.com', 'SzJrrXogAkj', '4/22/2022', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-27 15:16:58', 'nbampkinn7@paypal.com', 'ggfBQuZUv', '9/26/2021', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-19 22:03:05', 'rmaylinn8@foxnews.com', '2420jQOe6CVm', '11/6/2021', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-02 10:20:33', 'pmattheeuwn9@businessinsider.com', '6T71QCX3', '3/9/2022', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-14 10:34:56', 'ekinnardna@wufoo.com', 'BzkgoYkdfil', '12/28/2021', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-25 22:50:15', 'efolbignb@dot.gov', 'BmZkGLaGL', '9/17/2021', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-11 01:43:22', 'ageorgenc@typepad.com', 'i4XZTRh', '7/17/2022', 27);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-15 05:45:46', 'rdaringtonnd@hc360.com', 'ISiV9oTE8', '7/14/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-05 02:49:08', 'epowersne@irs.gov', 'csEooshU', '12/21/2021', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-07 00:53:26', 'bletteresenf@howstuffworks.com', 'mfruo4y7L', '4/1/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-17 08:45:42', 'oarnoppng@wix.com', 'kaXpFHsxg', '5/12/2022', 29);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-10 21:44:36', 'llantuffenh@macromedia.com', '1W2PnF6Si3q', '4/28/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-10 09:14:57', 'rpeskettni@webs.com', 'bsB018O', '1/25/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-04 11:20:06', 'kcellanj@purevolume.com', 'p4qrIgFNC', '2/26/2022', 1);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-24 19:12:24', 'tsieghardnk@arizona.edu', 'N8WIZA4wZ6Fk', '7/5/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-01 19:13:37', 'wsidwicknl@dot.gov', 'nFc1hqd', '5/15/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-26 00:33:02', 'scolbynm@patch.com', 'kMfw9DCwx', '5/24/2022', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-01 17:34:56', 'pwillshawnn@umn.edu', 'KUn6Es3pt5db', '10/2/2021', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-16 13:08:00', 'sshepleyno@un.org', 'KtHdfaP', '12/7/2021', 70);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-19 06:10:40', 'bbehnenp@engadget.com', 'Bmwz9OE9RUZ', '7/20/2022', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-07 08:45:22', 'atustinnq@tamu.edu', 'YixmNmS1b63k', '1/14/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-31 19:53:18', 'tspellardnr@answers.com', 'BjFCtzOn9', '3/27/2022', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-08 05:52:11', 'tmcmorranns@newyorker.com', 'MJTOnpw', '5/19/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-17 08:53:57', 'fkenernt@google.it', 'sU8BIZMB282', '6/12/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-07 17:51:06', 'methertonnu@kickstarter.com', 'DljdsEdvu', '6/7/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-03 16:12:18', 'crosenvassernv@digg.com', 'f60ciM', '4/19/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-29 11:53:11', 'fchamberlinnw@ihg.com', 'brgosClSCMug', '7/8/2022', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-19 02:54:44', 'rdandynx@ehow.com', 'xfkDZLlaNT', '5/13/2022', 49);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-27 20:16:49', 'rremerny@jigsy.com', '38lSRPP57', '7/1/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-12 20:12:44', 'ndilaweynz@nytimes.com', '2AKqPIzQ81g', '4/30/2022', 80);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-22 19:52:58', 'framalheteo0@dedecms.com', 'BDERGiBnT45', '3/14/2022', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-26 13:43:02', 'mshoreo1@craigslist.org', 'b8aQwOBEWnI2', '6/27/2022', 48);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-15 07:58:49', 'speplayo2@comcast.net', 'ZlkBeXBuj', '5/30/2022', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-31 04:28:56', 'mdanbyeo3@goo.gl', 'vC7Mpni1yZ', '10/15/2021', 46);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-19 09:22:01', 'bmclleeseo4@army.mil', 'psqxIZDV', '11/5/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-15 23:14:19', 'mmyricko5@marketwatch.com', 'VVPIJoUP4', '5/19/2022', 51);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-22 02:41:10', 'rashfordo6@myspace.com', 'YKp7t1ALm6u1', '4/17/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-19 19:10:24', 'hsheacho7@uiuc.edu', 'Ng50VFm4a3c', '9/20/2021', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-11 04:10:57', 'rdeavilleo8@goodreads.com', 'JgWF8t', '10/19/2021', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-20 21:36:36', 'wtimbyo9@toplist.cz', '9yJ6Z71u', '1/12/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-25 22:57:26', 'vflanaghanoa@ucsd.edu', '4dy4OoawKm1', '4/5/2022', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 18:54:09', 'hstolzob@discuz.net', 'kh8g0ULsct2W', '4/26/2022', 25);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-27 09:38:12', 'gharvattoc@marketwatch.com', 'ue9jKFB5', '7/2/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-12 01:40:30', 'cgrelakod@icq.com', '6CDVWL', '12/20/2021', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-03 13:40:13', 'mearleoe@youku.com', '1TaqQu', '6/25/2022', 73);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-17 14:00:00', 'claurensonof@google.com.br', 'WKAiWOQOu', '5/25/2022', 23);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-17 23:13:22', 'tsomervilleog@hao123.com', 'eGKECcjSDzfI', '5/1/2022', 39);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-06 02:42:00', 'smccluskeyoh@qq.com', '1Yz6VSV', '2/1/2022', 97);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-08 12:52:01', 'jkratesoi@vkontakte.ru', 'Uv0WQpMHXn1', '2/24/2022', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-22 19:13:04', 'scarlettioj@t.co', 'ttPTqj4lgG', '7/8/2022', 69);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 06:27:00', 'acatmullok@fda.gov', 'cexi0U', '5/13/2022', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-02 16:01:24', 'radolfol@newyorker.com', 'ScRwJGxEx', '4/13/2022', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-11 08:56:28', 'eportwaineom@walmart.com', 'fq9CEC1Oo', '5/3/2022', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-06 21:42:45', 'opughsleyon@seattletimes.com', 'ZsD4HRJY3L', '11/18/2021', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-20 15:10:31', 'aweildoo@craigslist.org', 'yh4BWp8HPO1i', '7/17/2022', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-25 05:48:16', 'mmalatalantop@yahoo.co.jp', '8BYiY4dl8bq', '7/27/2022', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-23 00:46:47', 'abarrandoq@vk.com', 'onb4DuA', '9/13/2021', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-11 19:08:23', 'rdevonaldor@biblegateway.com', 'Ua07FElxF', '4/12/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-24 14:40:33', 'jfanninos@statcounter.com', '3qfiyfmZVS', '10/23/2021', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-05 13:15:31', 'jbrealeyot@home.pl', 'eLzK9D4I6S', '7/12/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-02 12:42:07', 'bjouandetou@arstechnica.com', 'RpOu2a6XMi2a', '9/17/2021', 58);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-12 09:53:32', 'keykelboschov@tinypic.com', 'rPSuRwUjp', '2/21/2022', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-21 05:07:34', 'odorrow@privacy.gov.au', 'KFfcNU', '1/5/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-31 08:35:30', 'kfawcknerox@geocities.com', 'rYQBVppG', '2/18/2022', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-21 11:47:41', 'pcoursoy@surveymonkey.com', 'dZMTObwrpgV', '12/8/2021', 17);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-19 02:52:15', 'kduckersoz@vinaora.com', 'HLMXtBO6VBB', '6/12/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-22 10:22:41', 'cbeechenop0@jiathis.com', 'EAe5CQZeJS', '1/6/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-11 00:20:25', 'tdabnotp1@behance.net', 'uda40Y', '11/28/2021', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-28 18:12:31', 'breitenbachp2@shop-pro.jp', 'Km5XU0tEGtql', '9/8/2021', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-11 11:38:03', 'afayerbrotherp3@unesco.org', 'ffeUuiI44pB3', '10/6/2021', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-19 07:02:34', 'mblyp4@home.pl', 'o0PKseIxav', '1/25/2022', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-20 19:37:21', 'jcoyshp5@loc.gov', 'mH6s1WB', '4/8/2022', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-25 04:07:45', 'mcasewellp6@kickstarter.com', '1DRahBGCnl', '11/13/2021', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-19 22:16:44', 'mdorkinp7@ovh.net', '1pFl2o', '1/18/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 22:26:41', 'dsplainp8@census.gov', 'jJmIcaa', '9/7/2021', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-14 13:43:02', 'gcroisierp9@gmpg.org', 'IWTvo2rp', '12/3/2021', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-30 08:15:06', 'bdefrainepa@slashdot.org', 'PlyAfTZU', '7/26/2022', 13);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-26 11:44:51', 'lgoncalopb@gnu.org', '5NLVsaIwuC', '8/5/2021', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-31 01:29:38', 'ahenzleypc@time.com', 'K4eilPZPh4To', '8/1/2022', 45);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-29 09:42:17', 'wbirminghampd@seattletimes.com', 'Kzeu1Zj7HLy', '4/3/2022', 96);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-12 16:35:06', 'dwhybornepe@google.co.jp', 'nvqLUcNMtN', '5/23/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-30 21:25:54', 'cweatheypf@army.mil', 'uf7wMpdRQz1K', '1/26/2022', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-23 20:58:42', 'jbischoffpg@parallels.com', 'qD6OVWnet8X', '6/16/2022', 85);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-25 11:16:51', 'csimonassiph@sbwire.com', 'ArLM0B', '3/9/2022', 84);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-14 07:56:45', 'kklimeckipi@guardian.co.uk', 'fOIfQqDfY', '12/10/2021', 50);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-05 13:56:27', 'hmcowispj@newyorker.com', 'qlLaKoGv7so', '1/14/2022', 66);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-05 22:10:31', 'lsellnerpk@stumbleupon.com', 'BBvW6DPb', '2/16/2022', 76);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-08 20:30:18', 'mgierckepl@wp.com', 'pqvpBLtvRt', '3/19/2022', 55);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-04 08:29:08', 'npassopm@buzzfeed.com', 'XqV3CWHTs3c', '12/11/2021', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-19 06:22:35', 'satcockpn@elpais.com', 'R6Rat5mXcF', '6/12/2022', 44);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-13 05:26:10', 'odimsdalepo@1und1.de', '6Da0fi', '12/11/2021', 54);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-15 00:05:16', 'dsuttabypp@deviantart.com', 'RQNxQGg7', '4/14/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-20 23:03:31', 'tcavalierpq@lycos.com', '6Osn7A', '10/14/2021', 90);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 01:50:21', 'vcullingfordpr@google.ca', 'IKEa4bk2RkCB', '1/14/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-28 10:39:32', 'dstampps@yahoo.com', 'IJf86Jzx', '12/5/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-04 16:47:53', 'swoolfordept@e-recht24.de', 'zlYMfwrfVtxS', '3/23/2022', 72);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-12 21:21:24', 'bfilisovpu@nature.com', '31mbs2cBlC', '2/11/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-19 14:09:25', 'pcubbinopv@archive.org', '5UvICzs', '4/16/2022', 65);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-31 08:29:40', 'hmarietonpw@1688.com', 'DIpIaf6om', '7/8/2022', 74);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-26 21:49:56', 'dthomassenpx@geocities.jp', 'vG7JV7N', '5/2/2022', 28);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-19 13:47:59', 'tpizzeypy@wired.com', 'W3YMcHadT', '4/16/2022', 40);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-24 11:44:40', 'agutanspz@constantcontact.com', 'XlclaML19J', '11/12/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-13 15:58:42', 'ncorsellesq0@bluehost.com', 'kX9sV2', '6/26/2022', 86);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-31 06:30:51', 'twhitehorneq1@smh.com.au', 'NIjjax', '2/12/2022', 67);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-06 13:43:31', 'mbasinigazziq2@home.pl', 'qQILqSQtuFvY', '8/12/2021', 60);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-29 20:11:21', 'ebesteq3@indiegogo.com', 'oXh0f3S', '3/6/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-26 23:04:55', 'nbeavenq4@tripadvisor.com', 'jqAb3sd', '2/23/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-17 14:08:19', 'tmacleseq5@nydailynews.com', 'ZHGC11QL47', '9/12/2021', 43);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-19 04:30:53', 'adolemanq6@ycombinator.com', 'WjG7lrF', '8/6/2021', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-15 00:09:35', 'jgheorgheq7@dot.gov', 'B7Y2RgSRP3y', '2/8/2022', 62);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-20 17:44:23', 'sdominicacciq8@163.com', '5JCMcLVc', '8/19/2021', 83);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-21 17:13:25', 'dgreenerq9@joomla.org', 'zqklNNTP5', '10/22/2021', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-14 10:55:57', 'rdiluciaqa@mediafire.com', 'j17rtnQ07', '8/22/2021', 77);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-08 02:17:57', 'mtaggettqb@craigslist.org', 'HDU6Dj2', '1/10/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-29 06:31:23', 'kbaggsqc@barnesandnoble.com', 'bVnJZDi', '6/4/2022', 37);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-25 09:23:18', 'obuckieqd@fema.gov', 'UOmkhp', '4/25/2022', 6);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-03 19:25:45', 'osaggsqe@wikispaces.com', 'gKL6RUyZpoa', '7/19/2022', 26);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-11-30 16:25:55', 'jscreatonqf@gizmodo.com', 'AP59opF39ap', '9/19/2021', 82);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-13 00:14:57', 'jborlandqg@nymag.com', '36DXaYajfB8', '6/19/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-27 10:12:43', 'larlowqh@yale.edu', 'GwmWqN', '4/24/2022', 7);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-14 16:19:58', 'cchamanqi@yellowpages.com', 'nuYGZ3r', '1/9/2022', 22);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-28 06:54:19', 'mmassimoqj@unc.edu', 'f768pC', '1/23/2022', 2);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-03 23:36:55', 'nscotterqk@yellowpages.com', 'SUgxyCj', '6/12/2022', 31);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-26 00:40:09', 'jschollql@1688.com', 'PmGw5qKUjC3c', '7/31/2022', 12);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-15 20:58:19', 'jgarrieqm@sfgate.com', 'AXTSqtsLy', '6/30/2022', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-09 22:15:47', 'amarpleqn@dropbox.com', '7KyndCyEr', '11/19/2021', 75);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-23 20:10:21', 'agullickqo@imdb.com', 'W57H1k', '6/3/2022', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-04 18:07:48', 'dclimerqp@plala.or.jp', 'BZmaqjaf', '11/24/2021', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-17 16:19:23', 'rbottomleyqq@diigo.com', 'fGw4zzn9', '5/24/2022', 87);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-08-01 09:22:48', 'gbromehedqr@walmart.com', 'aniGqNF1t', '4/17/2022', 98);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-19 07:51:55', 'rshovellqs@independent.co.uk', 'e2QhrqS', '3/13/2022', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-30 14:01:38', 'sspaldingqt@blinklist.com', 'HueUfgX4', '1/28/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-20 17:25:27', 'estowgillqu@cpanel.net', 'wwRDzUUwNh', '4/1/2022', 47);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-04-16 11:10:25', 'mhampeqv@npr.org', '3F1NgNHQ', '1/2/2022', 41);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-21 05:17:46', 'ktullochqw@phpbb.com', 'Sx4CHdk', '5/16/2022', 89);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-30 20:06:06', 'acrannisqx@va.gov', 'GvrOK9Yj165H', '10/16/2021', 64);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-21 19:21:35', 'mdavidescoqy@slashdot.org', 'l47KYvUfW', '4/5/2022', 3);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-15 13:10:57', 'clarrawayqz@shareasale.com', 'OQz7oSJ', '10/2/2021', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-14 08:09:44', 'awreakr0@dion.ne.jp', 'NwqcQSYnIU', '4/12/2022', 78);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-20 12:56:42', 'fvogeler1@salon.com', 'T9rndrBW70u3', '5/3/2022', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-01 00:32:07', 'rclappsonr2@multiply.com', '9nokX7d', '12/13/2021', 91);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-03 14:25:42', 'gkertonr3@imdb.com', 'D7ZoRcc', '10/7/2021', 93);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-09-03 02:26:16', 'knaismithr4@prlog.org', 'GazVxya', '11/12/2021', 11);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-18 20:21:12', 'bloughreyr5@ocn.ne.jp', 'QJ3XttoNEHe', '7/19/2022', 15);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-09 01:27:10', 'afaccinir6@macromedia.com', 'EEYcy3dPAMz', '12/23/2021', 9);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-18 02:12:55', 'pjzhakovr7@photobucket.com', 'W0cKpr', '5/28/2022', 5);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-10 11:32:30', 'jcraxfordr8@squarespace.com', 'MhznXaO51', '6/28/2022', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-19 08:50:21', 'pebbsr9@upenn.edu', 'obPTZWNdI37I', '7/13/2022', 19);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-14 22:23:59', 'sbrigstockra@wiley.com', 'W3igpMnR', '2/28/2022', 94);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-26 00:12:57', 'adavidssonrb@blogtalkradio.com', 'uL1D88S5L', '5/1/2022', 57);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-06-04 07:59:54', 'wbrokenshawrc@stumbleupon.com', 'HSgadSUTxxI', '8/8/2021', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-27 19:17:06', 'fhaycraftrd@msu.edu', 'Cbn7lPebn', '4/9/2022', 79);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-20 01:01:14', 'pwincklesre@wisc.edu', 'OFoVbjkB', '8/11/2021', 24);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-12-28 21:33:21', 'ijewsburyrf@netlog.com', 'UjIdgqNr', '12/1/2021', 32);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-28 06:17:56', 'wfaulkenerrg@disqus.com', 'vxwlzgSn', '8/23/2021', 42);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-22 00:07:46', 'imelvinrh@devhub.com', 'BUpJ5EV', '6/16/2022', 53);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-08 04:33:01', 'ghinckleyri@amazonaws.com', 'XJuzYqo', '9/30/2021', 10);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-31 21:25:35', 'ccroninrj@icq.com', 'x6iQnhHM', '4/16/2022', 20);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-03 14:48:34', 'swindousrk@newyorker.com', '6RjlrT7j1s', '10/14/2021', 81);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-10-14 12:25:26', 'jcapnorrl@eepurl.com', 'iSF5kJ6L8XE', '12/16/2021', 18);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-07-15 15:11:34', 'jlittlejohnsrm@toplist.cz', 'xj3FdEmetRg', '2/15/2022', 52);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-05-13 04:49:12', 'gtrewmanrn@mysql.com', 'r4vg2c1i5', '8/22/2021', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-02-19 19:31:43', 'hbattiero@opera.com', 'bNMCF9', '7/18/2022', 68);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-03-25 01:34:26', 'bakettrp@topsy.com', 'E00nWTfRPIX', '4/19/2022', 92);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2022-01-18 02:20:05', 'bbroughrq@sfgate.com', 'SnxLBD67lPCe', '5/19/2022', 71);
insert into @tempUsers (CompanyID, BusinessDate, UserName, Password, AddedDate, AddedBy) values (0, '2021-08-28 04:10:00', 'dcantrillrr@omniture.com', '4l4VM0V9M0J', '8/8/2021', 80);


INSERT INTO [dbo].[Users](CompanyID, BusinessDate, UserName, Salt, PasswordEncrypted, AddedDate, AddedBy)
select T.CompanyID, CONVERT(DATE, T.BusinessDate, 101), T.UserName, LoadSalt, dbo.SaltPassword(t.Password, LoadSalt), t.AddedDate, t.AddedBy from @tempUsers T
CROSS APPLY(
	select dbo.GenerateSalt(CONVERT(varchar(38), NEWID())) LoadSalt
) Salty


SELECT COUNT(*) FROM [dbo].[Users]

--*/
