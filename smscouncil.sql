USE [master]
GO
/****** Object:  Database [smscouncil]    Script Date: 2018/2/7 20:54:47 ******/
CREATE DATABASE [smscouncil]
GO
ALTER DATABASE [smscouncil] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [smscouncil].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [smscouncil] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [smscouncil] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [smscouncil] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [smscouncil] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [smscouncil] SET ARITHABORT OFF 
GO
ALTER DATABASE [smscouncil] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [smscouncil] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [smscouncil] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [smscouncil] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [smscouncil] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [smscouncil] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [smscouncil] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [smscouncil] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [smscouncil] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [smscouncil] SET  ENABLE_BROKER 
GO
ALTER DATABASE [smscouncil] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [smscouncil] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [smscouncil] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [smscouncil] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [smscouncil] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [smscouncil] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [smscouncil] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [smscouncil] SET RECOVERY FULL 
GO
ALTER DATABASE [smscouncil] SET  MULTI_USER 
GO
ALTER DATABASE [smscouncil] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [smscouncil] SET DB_CHAINING OFF 
GO
ALTER DATABASE [smscouncil] SET QUERY_STORE = ON
GO
ALTER DATABASE [smscouncil] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [smscouncil]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [smscouncil]
GO
/****** Object:  Table [dbo].[Conferences]    Script Date: 2018/2/7 20:54:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conferences](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[cparticipants] [varchar](max) NULL,
	[cnum] [smallint] NOT NULL,
	[uparticipants] [varchar](max) NULL,
	[unum] [smallint] NOT NULL,
	[ratio] [tinyint] NOT NULL,
	[state] [tinyint] NOT NULL,
	[time] [datetime] NOT NULL,
	[totalvote]  AS ([ratio]*[unum]+[cnum]) PERSISTED,
	[halfmajority]  AS (ceiling(([ratio]*[unum]+[cnum])/(2.0))) PERSISTED,
	[absmajority]  AS (ceiling((([ratio]*[unum]+[cnum])/(3.0))*(2))) PERSISTED,
 CONSTRAINT [PK_Conferences] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Delegations]    Script Date: 2018/2/7 20:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Delegations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[conference] [int] NOT NULL,
	[subject] [int] NOT NULL,
	[object] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Delegations] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Users]    Script Date: 2018/2/7 20:55:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](30) NOT NULL,
	[password] [char](32) NOT NULL,
	[name] [nvarchar](10) NOT NULL,
	[class] [tinyint] NULL,
	[unit] [nvarchar](10) NULL,
	[phone] [varchar](11) NULL,
	[role] [tinyint] NOT NULL,
	[activated] [bit] NOT NULL,
	[display] [bit] NOT NULL,
	[defaultpassword] [varchar](6) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Votes]    Script Date: 2018/2/7 20:55:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Votes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[conference] [int] NOT NULL,
	[title] [nvarchar](53) NOT NULL,
	[notvoted] [varchar](max) NULL,
	[consented] [varchar](max) NULL,
	[rejected] [varchar](max) NULL,
	[nvvote] [smallint] NOT NULL,
	[cvote] [smallint] NOT NULL,
	[rvote] [smallint] NOT NULL,
	[totalvote]  AS ((([nvvote]+[cvote])+[rvote])+[avote]) PERSISTED,
	[ratio] [tinyint] NOT NULL,
	[halfmajority] [smallint] NOT NULL,
	[absmajority] [smallint] NOT NULL,
	[active] [bit] NOT NULL,
	[time] [datetime] NOT NULL,
	[abstained] [varchar](max) NULL,
	[avote] [smallint] NOT NULL,
	[type] [tinyint] NOT NULL,
	[passvote] [int] NOT NULL,
 CONSTRAINT [PK_Votes] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER TABLE [dbo].[Conferences] ADD  CONSTRAINT [DF__tmp_ms_xx___cnum__4BAC3F29]  DEFAULT ((0)) FOR [cnum]
GO
ALTER TABLE [dbo].[Conferences] ADD  CONSTRAINT [DF__tmp_ms_xx___unum__4CA06362]  DEFAULT ((0)) FOR [unum]
GO
ALTER TABLE [dbo].[Conferences] ADD  CONSTRAINT [DF__tmp_ms_xx__ratio__4D94879B]  DEFAULT ((2)) FOR [ratio]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_activated]  DEFAULT ((1)) FOR [activated]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_display]  DEFAULT ((1)) FOR [display]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_defaultpassword]  DEFAULT ('无') FOR [defaultpassword]
GO
ALTER TABLE [dbo].[Votes] ADD  CONSTRAINT [DF_Votes_ratio]  DEFAULT ((2)) FOR [ratio]
GO
ALTER TABLE [dbo].[Votes] ADD  CONSTRAINT [DF_Votes_time]  DEFAULT ('1980-1-1 0:00') FOR [time]
GO
ALTER TABLE [dbo].[Votes] ADD  CONSTRAINT [DF_Votes_avote]  DEFAULT ((0)) FOR [avote]
GO
ALTER TABLE [dbo].[Votes] ADD  CONSTRAINT [DF_Votes_type]  DEFAULT ((1)) FOR [type]
GO
ALTER TABLE [dbo].[Votes] ADD  CONSTRAINT [DF_Votes_passvote]  DEFAULT ((0)) FOR [passvote]
GO
USE [master]
GO
ALTER DATABASE [smscouncil] SET  READ_WRITE 
GO
