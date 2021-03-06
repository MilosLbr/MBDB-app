USE [master]
GO
/****** Object:  Database [Movies]    Script Date: 30.1.2020. 21:21:54 ******/
CREATE DATABASE [Movies]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Movies', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Movies.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Movies_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Movies_log.ldf' , SIZE = 1536KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Movies] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Movies].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Movies] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Movies] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Movies] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Movies] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Movies] SET ARITHABORT OFF 
GO
ALTER DATABASE [Movies] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Movies] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Movies] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Movies] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Movies] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Movies] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Movies] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Movies] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Movies] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Movies] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Movies] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Movies] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Movies] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Movies] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Movies] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Movies] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Movies] SET  MULTI_USER 
GO
ALTER DATABASE [Movies] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Movies] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Movies] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Movies] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Movies] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Movies', N'ON'
GO
ALTER DATABASE [Movies] SET QUERY_STORE = OFF
GO
USE [Movies]
GO
/****** Object:  UserDefinedFunction [dbo].[CurrentYear]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CurrentYear]()
RETURNS INT
AS
BEGIN
	RETURN year(GetDate())
END
GO
/****** Object:  UserDefinedFunction [dbo].[format_currency]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[format_currency] (@monetary_value decimal(20,2) ) returns varchar(20)
as
begin
	declare @return_value varchar(20)
	declare @is_negative bit
	select @is_negative = case when @monetary_value<0 then 1 else 0 end

	if @is_negative = 1
		set @monetary_value = -1*@monetary_value

	set @return_value = convert(varchar, isnull(@monetary_value, 0))
	
	
		--------------------------------------------------------------------------------
		





	--------------------------------------------------------------------------------
	

	declare @before varchar(20), @after varchar(20)

	if charindex ('.', @return_value )>0 
	begin
		set @after= substring(@return_value,  charindex ('.', @return_value ), len(@return_value))	
		set @before= substring(@return_value,1,  charindex ('.', @return_value )-1)	
	end
	else
	begin
		set @before = @return_value
		set @after=''
	end
	-- after every third character:
	declare @i int
	if len(@before)>3 
	begin
		set @i = 3
		while @i>1 and @i < len(@before)
		begin
			set @before = substring(@before,1,len(@before)-@i) + ',' + right(@before,@i)
			set @i = @i + 4
		end
	end
	set @return_value = @before + @after

	if @is_negative = 1
		set @return_value = '-' + @return_value

	return @return_value 
end
GO
/****** Object:  UserDefinedFunction [dbo].[LeftPad]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeftPad](
	@stringToPad VARCHAR(8000),
	@finalLength INT,
	@paddingChar CHAR(1)
) 
RETURNS VARCHAR(8000)
AS
BEGIN    
	DECLARE @answer VARCHAR(8000)
	DECLARE @strLength INT
	DECLARE @charsToAdd INT
	
	SELECT @strLength = LEN(@stringToPad)
	SELECT @charsToAdd =  @finalLength - @strLength

	IF @charsToAdd<0 
		SELECT @answer = @stringToPad
	ELSE
		SELECT @answer = REPLICATE (@paddingChar, @charsToAdd) + @stringToPad

	RETURN @answer
END
GO
/****** Object:  UserDefinedFunction [dbo].[UkDate]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UkDate](
	@DateToFormat AS DATETIME		-- the date to format
)
RETURNS varchar(10)

AS

BEGIN

	DECLARE @DayNo smallint
	DECLARE @MonthNo smallint
	DECLARE @YearNo smallint
	
	SELECT @DayNo = day(@DateToFormat)
	SELECT @MonthNo = month(@DateToFormat)
	SELECT @YearNo = year(@DateToFormat)

	RETURN 
		dbo.LeftPad(@DayNo,2,'0') + '-' +
		dbo.LeftPad(@MonthNo,2,'0') + '-' +
		CAST(@YearNo AS char(4))
END
GO
/****** Object:  Table [dbo].[tblCertificate]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCertificate](
	[CertificateID] [bigint] NOT NULL,
	[Certificate] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCertificate] PRIMARY KEY CLUSTERED 
(
	[CertificateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwFilmDetails]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFilmDetails]
AS
SELECT     Certificate
FROM         dbo.tblCertificate
GO
/****** Object:  Table [dbo].[tblFilm]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFilm](
	[FilmID] [int] IDENTITY(1,1) NOT NULL,
	[FilmName] [nvarchar](255) NOT NULL,
	[FilmReleaseDate] [datetime] NULL,
	[FilmDirectorID] [int] NOT NULL,
	[FilmLanguageID] [int] NOT NULL,
	[FilmCountryID] [int] NOT NULL,
	[FilmStudioID] [int] NULL,
	[FilmSynopsis] [nvarchar](max) NOT NULL,
	[FilmRunTimeMinutes] [int] NULL,
	[FilmCertificateID] [bigint] NULL,
	[FilmBudgetDollars] [int] NULL,
	[FilmBoxOfficeDollars] [int] NULL,
	[FilmOscarNominations] [int] NULL,
	[FilmOscarWins] [int] NULL,
	[FilmLikes] [int] NULL,
	[FilmDislikes] [int] NULL,
 CONSTRAINT [PK_tblFilm] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwFilmSimple]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFilmSimple]
AS
SELECT     FilmID, FilmName, FilmBoxOfficeDollars
FROM         dbo.tblFilm
WHERE     (FilmBoxOfficeDollars = NULL)
GO
/****** Object:  Table [dbo].[tblDirector]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDirector](
	[DirectorID] [int] NOT NULL,
	[DirectorName] [nvarchar](255) NULL,
	[DirectorDOB] [datetime] NULL,
	[DirectorGender] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblDirector] PRIMARY KEY CLUSTERED 
(
	[DirectorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCountry]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCountry](
	[CountryID] [int] NOT NULL,
	[CountryName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCountry] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblStudio]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStudio](
	[StudioID] [int] NOT NULL,
	[StudioName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblStudio] PRIMARY KEY CLUSTERED 
(
	[StudioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblLanguage]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLanguage](
	[LanguageID] [int] NOT NULL,
	[Language] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblLanguage] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwFilms]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFilms]
AS
SELECT     dbo.tblFilm.FilmName, dbo.tblDirector.DirectorName, dbo.tblCountry.CountryName, dbo.tblLanguage.Language, dbo.tblCertificate.Certificate, 
                      dbo.tblStudio.StudioName
FROM         dbo.tblCertificate INNER JOIN
                      dbo.tblFilm ON dbo.tblCertificate.CertificateID = dbo.tblFilm.FilmCertificateID INNER JOIN
                      dbo.tblCountry ON dbo.tblFilm.FilmCountryID = dbo.tblCountry.CountryID INNER JOIN
                      dbo.tblDirector ON dbo.tblFilm.FilmDirectorID = dbo.tblDirector.DirectorID INNER JOIN
                      dbo.tblLanguage ON dbo.tblFilm.FilmLanguageID = dbo.tblLanguage.LanguageID INNER JOIN
                      dbo.tblStudio ON dbo.tblFilm.FilmStudioID = dbo.tblStudio.StudioID
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[CommentID] [int] IDENTITY(1,1) NOT NULL,
	[CommentContent] [nvarchar](max) NOT NULL,
	[CommentFilmID] [int] NOT NULL,
	[CommentUserID] [nvarchar](128) NOT NULL,
	[DateAdded] [date] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[CommentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilmGenres]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmGenres](
	[FilmId] [int] NOT NULL,
	[GenreId] [bigint] NOT NULL,
 CONSTRAINT [PK_FilmGenres] PRIMARY KEY CLUSTERED 
(
	[FilmId] ASC,
	[GenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FilmLikesAndDislikes]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FilmLikesAndDislikes](
	[FilmID] [int] NOT NULL,
	[UserID] [nvarchar](128) NOT NULL,
	[IsLiked] [tinyint] NOT NULL,
	[IsDisliked] [tinyint] NOT NULL,
 CONSTRAINT [PK_FilmLikesAndDislikes] PRIMARY KEY CLUSTERED 
(
	[FilmID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblActor]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblActor](
	[ActorID] [int] NOT NULL,
	[ActorName] [nvarchar](255) NULL,
	[ActorDOB] [datetime] NULL,
	[ActorGender] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblActor] PRIMARY KEY CLUSTERED 
(
	[ActorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCast]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCast](
	[CastID] [int] NOT NULL,
	[CastFilmID] [int] NULL,
	[CastActorID] [int] NULL,
	[CastCharacterName] [nvarchar](255) NULL,
 CONSTRAINT [PK_tblCast] PRIMARY KEY CLUSTERED 
(
	[CastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblGenre]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGenre](
	[GenreId] [bigint] NOT NULL,
	[GenreName] [varchar](50) NULL,
 CONSTRAINT [PK_tblGenre] PRIMARY KEY CLUSTERED 
(
	[GenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WatchList]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WatchList](
	[UserID] [nvarchar](128) NOT NULL,
	[FilmID] [int] NOT NULL,
 CONSTRAINT [PK_WatchList] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[FilmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'1', N'CanManageDatabase')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'72d12585-c6b4-45c8-9cfe-8f782a0fdc72', N'DummyRole')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'8071f5c5-3585-49fb-ba73-90a15de997f9', N'AnotherRole')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'96f961f2-c676-4698-84e3-c81076018d8e', N'JustAnotherRole')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'98ecbf2d-2c3d-4701-ab6c-57471797ad21', N'SampleRole')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'024b4cbb-709e-463f-9764-6ab02dd8197c', N'72d12585-c6b4-45c8-9cfe-8f782a0fdc72')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', N'72d12585-c6b4-45c8-9cfe-8f782a0fdc72')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', N'98ecbf2d-2c3d-4701-ab6c-57471797ad21')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', N'1')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', N'72d12585-c6b4-45c8-9cfe-8f782a0fdc72')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', N'8071f5c5-3585-49fb-ba73-90a15de997f9')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', N'96f961f2-c676-4698-84e3-c81076018d8e')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', N'98ecbf2d-2c3d-4701-ab6c-57471797ad21')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'de192eab-e00d-4751-adeb-98fa89091df4', N'72d12585-c6b4-45c8-9cfe-8f782a0fdc72')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'de192eab-e00d-4751-adeb-98fa89091df4', N'8071f5c5-3585-49fb-ba73-90a15de997f9')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'024b4cbb-709e-463f-9764-6ab02dd8197c', N'c@hmail.com', 0, N'ALYslBJLFMchaSPu780OiFSMlFvDjSgVONU6Ty9ggZxdygS3cnzC5+Kp/wngG4NceA==', N'c6284ff5-8867-47c3-9d3e-01a21af63156', NULL, 0, 0, NULL, 1, 0, N'c@hmail.com')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', N'mb@example.com', 0, N'AALXe3ZKy85BxH1Pa3upp6njxz1pdVeOXwpvFPMojb9RXGOVa1VE5an8qU4yuHaI8g==', N'20bbbea5-2ebb-4e42-8ccd-c9cbec089735', NULL, 0, 0, NULL, 1, 0, N'mb@example.com')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', N'admin@mbdb.com', 0, N'AAyoo6r/FrejUIptB0Rd8xY28lgZoZoYjb2zwSfWrt3zbqJs5REtnCMfSlsYwPzxEA==', N'2fdfc0e4-1359-43ec-9835-ebaa5f99974b', NULL, 0, 0, NULL, 1, 0, N'admin@mbdb.com')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', N'a@example.com', 0, N'AP9evhN9cAQyVxVS4JWMkCaySPqnJtOCLaP1SyUiCWgNAoZ+ZoKbKQzfSfSu9PFZvA==', N'01ec5ec2-f047-4603-8184-3e7977f4f1f9', NULL, 0, 0, NULL, 1, 0, N'a@example.com')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'de192eab-e00d-4751-adeb-98fa89091df4', N'd@gmail.com', 0, N'AHXHECU08HV6YDKo2PSRNTekDLMdvl9lonYK8ynt+jT8tdvZFEQI+rjFc7x174vOxA==', N'b2a15638-d13c-4606-8f76-50e86bc5f1c4', NULL, 0, 0, NULL, 1, 0, N'd@gmail.com')
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (1, N'Dobar', 150, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (2, N'Nije loš', 151, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (3, N'Prosek', 152, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (4, N'Super', 150, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (5, N'Odličan', 151, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (6, N'Lorem ipsum', 150, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2015-05-05' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (8, N'Ipsum Ipsum', 151, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (10, N'ok je', 23, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (11, N'Hmm... ok', 23, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (18, N'Moglo je bolje da se uradi.', 23, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (19, N'Preparing to watch this for a while...', 187, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (20, N'Classic action comedy, good one.', 52, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (21, N'One of the best thrillers', 171, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-19' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (22, N'Lorem ipsum

dolor sit amet

consectetur...', 152, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-22' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (23, N'Seen better', 151, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-22' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (25, N'Good one', 16, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (26, N'Great historical thriller..', 227, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-10-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (27, N'This would be nice to see...', 95, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-10-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (28, N'Very good classic!', 77, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-10-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (29, N'Slow movie, but complicated and interesting', 89, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-03' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (30, N'good action comedy
', 75, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-04' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (31, N'nice one', 272, N'bcedb949-422d-4779-b199-ec26c125e28f', CAST(N'2019-11-04' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (32, N'Lorem ipsum dolor sit amet', 254, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-14' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (33, N'Consectetur adisciping elit', 254, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-11-14' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (34, N'Nobel prize winner', 90, N'bcedb949-422d-4779-b199-ec26c125e28f', CAST(N'2019-11-14' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (35, N'Lorem ipsum dolor sit amet', 151, N'bcedb949-422d-4779-b199-ec26c125e28f', CAST(N'2019-11-14' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (36, N'classic tarantino', 257, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-15' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (37, N'western', 182, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (38, N'Raw denim taiyaki jianbing, tilde vape try-hard pickled unicorn meggings hammock lo-fi offal man braid schlitz. Everyday carry shoreditch truffaut PBR&B meditation. Artisan enamel pin hammock, twee quinoa vinyl cornhole 3 wolf moon fashion axe chicharrones ', 19, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (39, N'Twee wolf tacos migas godard. Schlitz enamel pin master cleanse, food truck YOLO pug celiac copper mug austin actually. Cornhole sriracha brooklyn air plant. Forage occupy taxidermy bushwick. Coloring book before they sold out humblebrag letterpress blog salvia chia pabst. Meggings knausgaard succulents, sustainable jianbing actually fashion axe listicle tumblr lomo vegan aesthetic kombucha cloud bread salvia. Jean shorts actually asymmetrical, crucifix wayfarers subway tile gastropub lomo distillery blue bottle austin mumblecore church-key art party artisan.

', 90, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (40, N'Edison bulb meh you probably haven''t heard of them, marfa irony franzen pitchfork gluten-free scenester messenger bag af twee neutra. Franzen small batch activated charcoal yuccie.', 106, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (41, N' Bread salvia. Jean shorts actually asymmetrical, crucifix wayfarers subway tile gastropub lomo distillery blue bottle austin mumblecore church-key art party artisan.', 213, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (42, N'gluten-free stumptown bitters wolf. Truffaut semiotics viral, microdosing tote bag hoodie prism. Knausgaard +1 DIY heirloom everyday carry twee. Squid art party quinoa snackwave butcher pour-over.', 213, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (43, N'ess DIY lo-fi mixtape, vaporware squid. Intelligentsia sriracha flexitarian meggings, DIY gentrify ethical helvetica thundercats fashion axe blue bottle. Pinterest bitters church-key lyft street art cray twee venmo selvage cliche fam authen', 176, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (44, N'r quinoa synth neutra slow-carb chicharrones hoodie. Woke aesthetic scenester lo-fi gochujang brunch. Kale chips ethical cardigan, 8-bit thundercats pinterest DIY YOLO jianbing synth affogato. Photo booth kombucha affogato pug ch', 70, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (45, N'Migas offal forage PBR&B cardigan pok pok semiotics, williamsburg echo park. Banh mi freegan sriracha, cornhole semiotics affogato kombucha before they sold out shaman lyft brooklyn drinking vinegar DIY. Tote bag leggings fingerstache, DIY bitters scenester ', 70, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (46, N'Pickled marfa cronut, gastropub af enamel pin gochujang. Chillwave helvetica palo santo 90''s freegan. Salvia you probably haven''t heard of them flannel,', 70, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (47, N'Pickled marfa cronut, gastropub af enamel pin gochujang. Chillwave helvetica palo santo 90''s freegan. Salvia you probably haven''t heard of them flannel,', 70, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (48, N'Hammock vexillologist heirloom, bitters sriracha lo-fi franzen hashtag palo santo quinoa unicorn vice keytar.', 66, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (49, N'Tumblr fanny pack health goth, woke beard yr before they sold out brooklyn readymade. Kitsch distillery umami farm-to-table banh mi leggings. Fam literally beard bushwick poke. Neutra raclette schlitz chillwave tacos sriracha. Raclette neutra banh mi sartorial snackwave viral master cleanse flannel franzen fashion axe pour-over.', 213, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (50, N'Lorem ipsum dolor sit amet consectetur adisciping elit..', 20, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (51, N'James bond with benicio del toro and Timothy dalton', 156, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (52, N'Good old one', 134, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', CAST(N'2019-11-24' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (54, N'Lorem ipsum dolor sit amet', 122, N'de192eab-e00d-4751-adeb-98fa89091df4', CAST(N'2019-11-29' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (56, N'Sci fi', 204, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2020-01-27' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (57, N'Lorem ipsum', 219, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', CAST(N'2020-01-27' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (58, N'Static ipsum dolor sit amet
', 261, N'bcedb949-422d-4779-b199-ec26c125e28f', CAST(N'2020-01-27' AS Date))
INSERT [dbo].[Comments] ([CommentID], [CommentContent], [CommentFilmID], [CommentUserID], [DateAdded]) VALUES (59, N'??', 91, N'bcedb949-422d-4779-b199-ec26c125e28f', CAST(N'2020-01-27' AS Date))
SET IDENTITY_INSERT [dbo].[Comments] OFF
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (1, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (1, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (1, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (1, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (2, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (2, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (2, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (3, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (3, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (3, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (3, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (5, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (5, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (6, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (6, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (7, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (7, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (7, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (8, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (8, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (8, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (8, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (9, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (9, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (9, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (9, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (9, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (10, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (10, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (10, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (11, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (11, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (11, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (11, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (11, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (12, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (12, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (12, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (12, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (13, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (13, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (13, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (13, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (14, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (14, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (14, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (15, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (15, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (15, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (16, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (16, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (16, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (16, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (16, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (16, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (17, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (17, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (18, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (18, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (18, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (18, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (19, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (19, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (20, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (20, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (20, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (20, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (20, 15)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (21, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (21, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (21, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (22, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (22, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (22, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (23, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (23, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (23, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (24, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (24, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (24, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (24, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (25, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (25, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (25, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (25, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (25, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (26, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (26, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (27, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (27, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (27, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (28, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (28, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (28, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (28, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (29, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (29, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (29, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (29, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (29, 17)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (29, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (30, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (30, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (30, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (31, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (31, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (31, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (32, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (32, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (32, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (32, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (32, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (33, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (33, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (34, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (34, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (34, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (35, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (35, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (35, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (35, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (36, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (36, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (37, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (37, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (38, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (38, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (38, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (39, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (39, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (39, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (39, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (40, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (40, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (40, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (41, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (41, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (41, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (42, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (42, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (42, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (42, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (43, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (43, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (43, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (44, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (44, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (44, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (45, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (45, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (45, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (46, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (46, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (46, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (46, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (47, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (47, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (47, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (47, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (47, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (48, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (48, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (48, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (48, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (49, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (49, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (49, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (49, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (50, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (50, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (51, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (51, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (51, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (52, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (52, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (53, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (53, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (54, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (54, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (54, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (54, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (54, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (55, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (55, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (55, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (55, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (55, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (56, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (56, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (56, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (56, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (57, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (57, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (58, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (58, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (58, 20)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (59, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (59, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (59, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (60, 1)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (60, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (60, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (60, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (60, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (61, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (61, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (61, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (62, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (62, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (62, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (62, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (62, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (63, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (63, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (64, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (64, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (64, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (65, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (65, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (65, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (65, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (66, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (66, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (66, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (66, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (67, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (67, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (67, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (68, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (68, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (68, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (69, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (69, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (69, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (70, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (70, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (71, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (71, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (71, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (72, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (72, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (72, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (73, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (73, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (73, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (74, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (74, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (74, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (75, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (75, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (75, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (75, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (76, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (76, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (76, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (76, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (77, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (77, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (77, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (77, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (78, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (78, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (78, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (79, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (79, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (79, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (80, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (80, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (80, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (80, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (80, 20)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (81, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (81, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (81, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (82, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (82, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (82, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (82, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (83, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (83, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (83, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (84, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (84, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (85, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (85, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (85, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (85, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (86, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (86, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (86, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (87, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (87, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (87, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (88, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (88, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (88, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (88, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (88, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (89, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (89, 8)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (89, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (90, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (90, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (91, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (91, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (91, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (92, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (92, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (92, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (92, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (92, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (93, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (93, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (93, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (94, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (94, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (94, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (95, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (95, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (95, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (96, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (96, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (96, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (97, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (97, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (97, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (97, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (98, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (98, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (98, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (98, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (99, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (99, 20)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (100, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (100, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (100, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (101, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (101, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (101, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (101, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (102, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (102, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (102, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (102, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (103, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (103, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (103, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (104, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (104, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (104, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (104, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (104, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (105, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (105, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (105, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (105, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (105, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (105, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (106, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (106, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (106, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (106, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (106, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (107, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (107, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (107, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (107, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (108, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (109, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (109, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (109, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (110, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (110, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (110, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (111, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (111, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (112, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (112, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (112, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (112, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (112, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (113, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (113, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (113, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (114, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (114, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (115, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (116, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (116, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (117, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (117, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (117, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (118, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (118, 2)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (118, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (119, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (119, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (119, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (119, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (120, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (120, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (120, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (121, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (121, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (121, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (121, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (122, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (122, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (122, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (123, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (123, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (123, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (124, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (124, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (124, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (125, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (125, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (125, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (125, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (125, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (126, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (126, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (127, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (127, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (127, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (128, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (128, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (128, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (128, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (129, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (129, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (129, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (129, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (130, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (130, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (130, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (130, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (131, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (131, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (131, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (131, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (132, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (132, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (132, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (132, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (133, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (133, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (133, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (133, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (134, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (134, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (135, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (135, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (135, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (136, 7)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (137, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (137, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (137, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (137, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (138, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (138, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (138, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (139, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (139, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (139, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (139, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (140, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (140, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (140, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (140, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (140, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (141, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (141, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (142, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (142, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (142, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (142, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (143, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (143, 3)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (143, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (143, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (143, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (144, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (144, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (144, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (145, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (145, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (146, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (146, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (146, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (146, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (146, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (147, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (147, 13)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (147, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (148, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (148, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (149, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (149, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (149, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (149, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (149, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (150, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (150, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (150, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (150, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (151, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (151, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (151, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (151, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (151, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (152, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (152, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (152, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (152, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (153, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (153, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (154, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (154, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (154, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (154, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (155, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (155, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (155, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (156, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (156, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (156, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (157, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (157, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (157, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (158, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (158, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (159, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (159, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (159, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (159, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (160, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (160, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (160, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (160, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (160, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (161, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (161, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (161, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (162, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (162, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (162, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (163, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (163, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (163, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (163, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (164, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (164, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (164, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (165, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (165, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (165, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (165, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (166, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (166, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (166, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (167, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (167, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (167, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (167, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (168, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (168, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (168, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (169, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (169, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (169, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (169, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (169, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (170, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (170, 20)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (171, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (171, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (171, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (171, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (172, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (172, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (172, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (173, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (173, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (173, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (173, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (174, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (174, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (174, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (174, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (174, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (175, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (175, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (176, 1)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (176, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (176, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (177, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (177, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (178, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (178, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (178, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (179, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (179, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (179, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (180, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (180, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (180, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (180, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (181, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (181, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (181, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (182, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (182, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (182, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (182, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (183, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (183, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (184, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (184, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (184, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (184, 14)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (185, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (185, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (185, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (186, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (187, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (187, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (187, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (188, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (188, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (188, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (189, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (190, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (190, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (191, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (191, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (191, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (192, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (192, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (192, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (192, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (193, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (193, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (193, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (193, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (194, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (194, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (194, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (195, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (195, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (195, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (195, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (196, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (196, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (196, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (197, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (197, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (199, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (199, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (199, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (200, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (200, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (200, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (201, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (201, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (201, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (202, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (203, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (203, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (203, 20)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (204, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (204, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (204, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (204, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (205, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (205, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (205, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (206, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (206, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (206, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (207, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (207, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (207, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (207, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (208, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (208, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (208, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (209, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (209, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (209, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (210, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (211, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (211, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (211, 22)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (212, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (212, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (212, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (213, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (213, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (213, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (213, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (214, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (214, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (215, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (215, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (216, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (216, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (217, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (217, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (217, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (217, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (218, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (218, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (219, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (219, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (219, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (219, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (220, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (220, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (220, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (220, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (221, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (222, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (222, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (222, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (223, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (223, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (223, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (223, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (224, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (224, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (224, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (224, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (224, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (225, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (225, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (225, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (226, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (226, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (226, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (226, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (227, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (227, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (227, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (227, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (228, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (228, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (228, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (229, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (229, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (229, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (229, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (230, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (230, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (231, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (231, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (232, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (232, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (232, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (233, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (233, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (233, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (234, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (234, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (236, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (236, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (236, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (237, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (237, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (238, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (238, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (238, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (238, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (239, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (239, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (239, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (240, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (240, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (240, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (241, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (241, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (241, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (242, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (242, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (242, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (243, 4)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (243, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (243, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (244, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (244, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (245, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (245, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (246, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (246, 2)
GO
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (246, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (246, 9)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (246, 24)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (249, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (249, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (249, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (250, 16)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (250, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (251, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (251, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (252, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (252, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (252, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (253, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (253, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (253, 13)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (253, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (254, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (254, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (254, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (255, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (255, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (256, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (256, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (256, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (257, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (257, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (257, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (258, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (258, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (258, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (259, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (259, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (259, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (259, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (260, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (260, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (260, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (261, 5)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (261, 7)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (261, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (262, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (262, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (262, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (263, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (263, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (264, 18)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (264, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (265, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (265, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (269, 2)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (269, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (269, 10)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (272, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (272, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (272, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (273, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (273, 17)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (281, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (281, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (281, 12)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (281, 22)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (281, 23)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (282, 1)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (282, 6)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (282, 8)
INSERT [dbo].[FilmGenres] ([FilmId], [GenreId]) VALUES (282, 22)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (5, N'bcedb949-422d-4779-b199-ec26c125e28f', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (19, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (20, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (28, N'bcedb949-422d-4779-b199-ec26c125e28f', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (38, N'024b4cbb-709e-463f-9764-6ab02dd8197c', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (38, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (60, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (64, N'bcedb949-422d-4779-b199-ec26c125e28f', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (71, N'bcedb949-422d-4779-b199-ec26c125e28f', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (72, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (73, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (75, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (77, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (82, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (89, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (90, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (90, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (102, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (115, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (121, N'bcedb949-422d-4779-b199-ec26c125e28f', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (122, N'de192eab-e00d-4751-adeb-98fa89091df4', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (128, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (134, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (134, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (151, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (151, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (151, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (152, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (152, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (156, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (171, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (190, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (195, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (199, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (200, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (218, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (219, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (228, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (254, N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 0, 1)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (257, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (261, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (269, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (272, N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (272, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (273, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (281, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[FilmLikesAndDislikes] ([FilmID], [UserID], [IsLiked], [IsDisliked]) VALUES (282, N'bcedb949-422d-4779-b199-ec26c125e28f', 1, 0)
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (1, N'Tom Cruise', CAST(N'1962-07-03T09:53:21.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (2, N'Sam Neill', CAST(N'1947-09-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (3, N'Laura Dern', CAST(N'1967-02-10T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (4, N'Jeff Goldblum', CAST(N'1952-10-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (5, N'Richard Attenborough', CAST(N'1923-08-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (6, N'Samuel L. Jackson', CAST(N'1948-12-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (7, N'Tobey Maguire', CAST(N'1975-06-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (8, N'Willem Dafoe', CAST(N'1955-07-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (9, N'Kirsten Dunst', CAST(N'1982-04-30T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (10, N'Naomi Watts', CAST(N'1968-09-28T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (11, N'Jack Black', CAST(N'1969-08-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (12, N'Adrien Brody', CAST(N'1973-04-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (13, N'Andy Serkis', CAST(N'1964-04-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (14, N'Brandon Routh', CAST(N'1979-10-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (15, N'Kate Bosworth', CAST(N'1983-01-02T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (16, N'Kevin Spacey', CAST(N'1959-07-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (17, N'Leonardo DiCaprio', CAST(N'1974-11-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (18, N'Kate Winslet', CAST(N'1975-10-05T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (19, N'Billy Zane', CAST(N'1966-02-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (20, N'Bill Paxton', CAST(N'1955-05-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (21, N'Steve Carell', CAST(N'1962-08-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (22, N'Morgan Freeman', CAST(N'1937-06-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (23, N'Kevin Costner', CAST(N'1955-01-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (24, N'Dennis Hopper', CAST(N'1936-05-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (25, N'Ben Affleck', CAST(N'1972-08-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (26, N'Josh Hartnett', CAST(N'1978-07-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (27, N'Kate Beckinsale', CAST(N'1973-07-26T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (28, N'Cuba Gooding Jr.', CAST(N'1968-01-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (29, N'Jon Voight', CAST(N'1938-12-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (30, N'Alec Baldwin', CAST(N'1958-04-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (31, N'Tom Sizemore', CAST(N'1961-11-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (32, N'Dan Aykroyd', CAST(N'1952-07-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (33, N'Shia LaBeouf', CAST(N'1986-06-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (34, N'John Turturro', CAST(N'1957-02-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (35, N'Peter Cullen', NULL, N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (36, N'Hugo Weaving', CAST(N'1960-04-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (37, N'Megan Fox', CAST(N'1986-05-16T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (38, N'Daniel Radcliffe', CAST(N'1989-07-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (39, N'Ralph Fiennes', CAST(N'1962-12-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (40, N'Brendan Gleeson', CAST(N'1955-03-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (41, N'Gary Oldman', CAST(N'1958-03-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (42, N'Michael Gambon', CAST(N'1940-10-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (43, N'Alan Rickman', CAST(N'1946-02-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (44, N'Emma Thompson', CAST(N'1959-04-15T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (45, N'Helena Bonham Carter', CAST(N'1966-05-26T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (46, N'Robbie Coltrane', CAST(N'1950-03-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (47, N'Emma Watson', CAST(N'1990-04-15T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (48, N'Rupert Grint', CAST(N'1988-08-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (49, N'Robin Wright Penn', CAST(N'1966-04-08T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (50, N'Anthony Hopkins', CAST(N'1937-12-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (51, N'John Malkovich', CAST(N'1953-12-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (52, N'Ray Winstone', CAST(N'1957-02-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (53, N'Angelina Jolie', CAST(N'1975-06-04T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (54, N'John Goodman', CAST(N'1952-06-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (55, N'Jerry Seinfeld', CAST(N'1954-04-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (56, N'Renee Zellweger', CAST(N'1969-04-25T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (57, N'Matthew Broderick', CAST(N'1962-03-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (58, N'Chris Rock', CAST(N'1965-02-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (59, N'Ray Liotta', CAST(N'1954-12-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (60, N'Rip Torn', CAST(N'1931-02-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (61, N'Johnny Depp', CAST(N'1963-06-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (62, N'Geoffrey Rush', CAST(N'1951-07-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (63, N'Orlando Bloom', CAST(N'1977-01-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (64, N'Keira Knightley', CAST(N'1985-03-26T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (65, N'Bill Nighy', CAST(N'1949-12-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (66, N'Jonathan Pryce', CAST(N'1947-06-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (67, N'Stellan Skarsgard', CAST(N'1951-06-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (68, N'Will Smith', CAST(N'1968-09-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (69, N'Patton Oswalt', CAST(N'1969-01-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (70, N'Ian Holm', CAST(N'1931-09-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (71, N'Brian Dennehy', CAST(N'1938-07-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (72, N'Peter O''Toole', CAST(N'1932-08-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (73, N'Brian Cox', CAST(N'1946-06-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (75, N'Brad Pitt', CAST(N'1963-12-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (76, N'Diane Kruger', CAST(N'1976-07-15T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (77, N'Eric Bana', CAST(N'1968-08-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (78, N'Christian Bale', CAST(N'1974-01-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (79, N'Michael Caine', CAST(N'1933-03-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (80, N'Liam Neeson', CAST(N'1952-06-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (81, N'Katie Holmes', CAST(N'1978-12-18T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (82, N'Rutger Hauer', CAST(N'1944-01-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (83, N'Ken Watanabe', CAST(N'1959-10-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (84, N'James Fox', CAST(N'1939-05-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (85, N'Christopher Lee', CAST(N'1922-05-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (86, N'Pierce Brosnan', CAST(N'1953-05-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (87, N'Halle Berry', CAST(N'1966-08-14T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (88, N'Rosamund Pike', CAST(N'1979-01-28T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (89, N'Judi Dench', CAST(N'1934-12-09T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (90, N'John Cleese', CAST(N'1939-10-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (91, N'Michael Madsen', CAST(N'1958-09-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (92, N'Samantha Bond', CAST(N'1961-11-27T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (93, N'Mel Gibson', CAST(N'1956-01-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (94, N'Danny Glover', CAST(N'1946-07-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (95, N'Joe Pesci', CAST(N'1943-02-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (96, N'Rene Russo', CAST(N'1954-02-17T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (97, N'Jet Li', CAST(N'1963-04-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (98, N'Bruce Willis', CAST(N'1955-03-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (99, N'Billy Bob Thornton', CAST(N'1955-08-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (100, N'Liv Tyler', CAST(N'1977-07-01T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (101, N'Steve Buscemi', CAST(N'1957-12-13T00:00:00.000' AS DateTime), N'Male')
GO
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (102, N'Owen Wilson', CAST(N'1968-11-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (103, N'Michael Clarke Duncan', CAST(N'1957-12-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (104, N'Peter Stormare', CAST(N'1953-08-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (105, N'Tommy Lee Jones', CAST(N'1946-09-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (106, N'Jamie Foxx', CAST(N'1967-12-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (107, N'Jessica Biel', CAST(N'1982-03-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (108, N'Ving Rhames', CAST(N'1959-05-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (109, N'Donald Sutherland', CAST(N'1935-07-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (110, N'James Woods', CAST(N'1947-04-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (111, N'Colin Farrell', CAST(N'1976-05-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (112, N'Ciaran Hinds', CAST(N'1953-02-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (113, N'Sophie Marceau', CAST(N'1966-11-17T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (114, N'Robert Carlyle', CAST(N'1961-04-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (115, N'Denise Richards', CAST(N'1971-02-17T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (116, N'Desmond Llewelyn', CAST(N'1913-09-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (117, N'Russell Crowe', CAST(N'1964-04-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (118, N'Paul Bettany', CAST(N'1971-05-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (119, N'Dakota Fanning', CAST(N'1994-02-23T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (120, N'Tim Robbins', CAST(N'1958-10-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (121, N'Matt Damon', CAST(N'1970-10-08T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (122, N'Julia Stiles', CAST(N'1981-03-28T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (123, N'David Strathairn', CAST(N'1949-01-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (124, N'Paddy Considine', CAST(N'1974-09-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (125, N'Albert Finney', CAST(N'1936-05-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (126, N'Monica Bellucci', CAST(N'1964-09-30T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (127, N'Laurence Fishburne', CAST(N'1961-07-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (128, N'Carrie-Anne Moss', CAST(N'1967-08-21T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (129, N'Keanu Reeves', CAST(N'1964-09-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (130, N'Tom Hanks', CAST(N'1956-07-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (131, N'Audrey Tautou', CAST(N'1976-08-09T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (132, N'Ian McKellen', CAST(N'1939-05-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (133, N'Jean Reno', CAST(N'1948-07-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (134, N'Jurgen Prochnow', CAST(N'1941-06-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (135, N'Richard Harris', CAST(N'1930-10-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (136, N'John Hurt', CAST(N'1940-01-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (137, N'Dennis Quaid', CAST(N'1954-04-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (138, N'Jake Gyllenhaal', CAST(N'1980-12-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (139, N'Billy Connolly', CAST(N'1942-11-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (140, N'Hiroyuki Sanada', CAST(N'1960-10-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (141, N'Cillian Murphy', CAST(N'1976-05-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (142, N'Michelle Yeoh', CAST(N'1962-08-06T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (143, N'George Clooney', CAST(N'1961-05-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (144, N'Mark Wahlberg', CAST(N'1971-06-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (145, N'John C. Reilly', CAST(N'1965-05-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (146, N'Mary Elizabeth Mastrantonio', CAST(N'1958-11-17T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (147, N'Michael Ironside', CAST(N'1950-02-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (148, N'Philip Seymour Hoffman', CAST(N'1967-07-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (149, N'Michelle Monaghan', CAST(N'1976-03-23T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (150, N'Simon Pegg', CAST(N'1970-02-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (151, N'Nicolas Cage', CAST(N'1964-01-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (152, N'Christian Slater', CAST(N'1969-08-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (153, N'Ewan McGregor', CAST(N'1971-03-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (154, N'Natalie Portman', CAST(N'1981-06-09T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (155, N'Hayden Christensen', CAST(N'1981-04-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (156, N'Frank Oz', CAST(N'1944-05-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (157, N'Ian McDiarmid', CAST(N'1944-08-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (158, N'Temuera Morrison', CAST(N'1960-12-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (159, N'Rena Owen', CAST(N'1962-07-22T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (160, N'Billy Crystal', CAST(N'1948-03-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (161, N'James Coburn', CAST(N'1928-08-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (162, N'Ray Park', CAST(N'1974-08-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (163, N'Anthony Daniels', CAST(N'1946-02-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (164, N'Kenny Baker', CAST(N'1934-08-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (165, N'Peter Mayhew', CAST(N'1944-05-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (166, N'Joe Don Baker', CAST(N'1936-02-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (167, N'Elliott Gould', CAST(N'1938-08-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (168, N'Andy Garcia', CAST(N'1956-04-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (169, N'Julia Roberts', CAST(N'1967-10-28T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (170, N'Don Cheadle', CAST(N'1964-11-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (171, N'Timothy Olyphant', CAST(N'1968-05-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (172, N'Jackie Chan', CAST(N'1954-04-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (173, N'Steve Coogan', CAST(N'1965-10-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (174, N'Arnold Schwarzenegger', CAST(N'1947-07-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (175, N'Maggie Q', CAST(N'1979-05-22T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (176, N'Sammo Hung', CAST(N'1952-01-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (177, N'Jim Broadbent', CAST(N'1949-05-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (178, N'Luke Wilson', CAST(N'1971-09-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (179, N'Jeremy Irons', CAST(N'1948-09-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (180, N'Edward Norton', CAST(N'1969-08-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (181, N'Vince Vaughan', CAST(N'1970-03-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (182, N'Cate Blanchett', CAST(N'1969-05-14T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (183, N'Jude Law', CAST(N'1972-12-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (184, N'Brent Spiner', CAST(N'1949-02-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (185, N'Viggo Mortensen', CAST(N'1958-10-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (186, N'Elijah Wood', CAST(N'1981-01-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (187, N'James Cromwell', CAST(N'1940-01-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (188, N'Bridget Moynahan', CAST(N'1971-04-28T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (189, N'Daniel Craig', CAST(N'1968-03-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (190, N'Max von Sydow', CAST(N'1929-04-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (191, N'Linda Hamilton', CAST(N'1956-09-26T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (192, N'Edward Furlong', CAST(N'1977-08-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (193, N'Robert Patrick', CAST(N'1958-11-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (194, N'Kenneth Branagh', CAST(N'1960-12-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (195, N'Denzel Washington', CAST(N'1954-12-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (196, N'Djimon Hounsou', CAST(N'1964-04-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (197, N'Jennifer Connelly', CAST(N'1970-12-12T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (198, N'Arnold Vosloo', CAST(N'1962-06-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (199, N'Joaquin Phoenix', CAST(N'1974-10-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (200, N'Connie Nielsen', CAST(N'1965-07-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (201, N'Oliver Reed', CAST(N'1937-02-13T00:00:00.000' AS DateTime), N'Male')
GO
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (202, N'Jamie Lee Curtis', CAST(N'1958-11-22T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (203, N'Tom Arnold', CAST(N'1959-03-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (204, N'Charlton Heston', CAST(N'1924-10-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (205, N'Tia Carrere', CAST(N'1967-01-02T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (206, N'Art Malik', CAST(N'1952-11-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (207, N'Eliza Dushku', CAST(N'1980-12-30T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (208, N'Daniel Day-Lewis', CAST(N'1957-04-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (209, N'Cameron Diaz', CAST(N'1972-08-30T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (210, N'Milla Jovovich', CAST(N'1975-12-17T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (211, N'Chris Tucker', CAST(N'1972-08-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (212, N'Sean Bean', CAST(N'1959-04-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (213, N'Karl Urban', CAST(N'1972-06-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (214, N'Linda Fiorentino', CAST(N'1958-03-09T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (215, N'Jack Nicholson', CAST(N'1937-04-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (216, N'Martin Sheen', CAST(N'1940-08-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (217, N'Paul Giamatti', CAST(N'1967-06-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (218, N'F. Murray Abraham', CAST(N'1939-10-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (219, N'Charles Dance', CAST(N'1946-10-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (221, N'Catherine Zeta-Jones', CAST(N'1969-09-25T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (222, N'Adam Sandler', CAST(N'1966-09-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (223, N'Christopher Walken', CAST(N'1943-03-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (224, N'David Hasselhoff', CAST(N'1952-07-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (225, N'Henry Winkler', CAST(N'1945-10-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (226, N'Jim Carrey', CAST(N'1962-01-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (227, N'Jennifer Aniston', CAST(N'1969-02-11T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (228, N'Emmanuelle Beart', CAST(N'1963-08-14T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (229, N'Robert Duvall', CAST(N'1931-01-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (230, N'Tea Leoni', CAST(N'1966-02-25T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (231, N'Jon Favreau', CAST(N'1966-10-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (232, N'Vanessa Redgrave', CAST(N'1937-01-30T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (233, N'Paul Newman', CAST(N'1925-01-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (234, N'Stanley Tucci', CAST(N'1960-11-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (235, N'Ed Harris', CAST(N'1950-11-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (236, N'Christopher Plummer', CAST(N'1929-12-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (237, N'Clive Owen', CAST(N'1964-10-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (238, N'Bill Pullman', CAST(N'1953-12-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (239, N'Mary McDonnell', CAST(N'1952-04-28T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (240, N'Randy Quaid', CAST(N'1950-10-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (241, N'Hugh Jackman', CAST(N'1968-10-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (242, N'Patrick Stewart', CAST(N'1940-07-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (243, N'Famke Janssen', CAST(N'1965-11-05T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (244, N'Sean Connery', CAST(N'1930-08-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (245, N'Michael Biehn', CAST(N'1956-07-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (246, N'Rachel Weisz', CAST(N'1971-03-07T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (247, N'Will Ferrell', CAST(N'1967-07-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (248, N'Sacha Baron Cohen', CAST(N'1971-10-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (249, N'Dan Castellaneta', CAST(N'1957-05-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (250, N'Julie Kavner', CAST(N'1950-09-07T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (251, N'Nancy Cartwright', CAST(N'1957-10-25T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (252, N'Yeardley Smith', CAST(N'1964-07-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (253, N'Patrick McGoohan', CAST(N'1928-03-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (254, N'William Hurt', CAST(N'1950-03-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (255, N'Sigourney Weaver', CAST(N'1949-10-08T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (256, N'Mike Myers', CAST(N'1963-05-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (257, N'Eddie Murphy', CAST(N'1961-04-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (258, N'Antonio Banderas', CAST(N'1960-08-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (259, N'Jonathan Frakes', CAST(N'1952-08-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (260, N'LeVar Burton', CAST(N'1957-02-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (261, N'Michael Dorn', CAST(N'1952-12-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (262, N'Gates McFadden', CAST(N'1949-03-02T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (263, N'Marina Sirtis', CAST(N'1955-03-29T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (264, N'Bob Hoskins', CAST(N'1942-10-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (265, N'Christopher Lloyd', CAST(N'1938-10-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (266, N'Kathleen Turner', CAST(N'1954-06-19T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (267, N'Christina Ricci', CAST(N'1980-02-12T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (268, N'Vin Diesel', CAST(N'1967-07-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (269, N'William Sadler', CAST(N'1950-04-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (270, N'Bonnie Bedelia', CAST(N'1948-03-25T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (271, N'Geena Davis', CAST(N'1956-01-21T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (272, N'Kevin Bacon', CAST(N'1958-07-08T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (273, N'Gary Sinise', CAST(N'1955-03-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (274, N'Sharon Stone', CAST(N'1958-03-10T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (275, N'Sylvester Stallone
advertisement', CAST(N'1946-07-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (276, N'John Lithgow', CAST(N'1945-10-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (277, N'Michael Rooker', CAST(N'1955-04-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (278, N'Harrison Ford', CAST(N'1942-07-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (279, N'Scarlett Johansson', CAST(N'1984-11-22T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (280, N'Hilary Swank', CAST(N'1974-07-30T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (281, N'Kathleen Quinlan', CAST(N'1954-11-19T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (282, N'Joely Richardson', CAST(N'1965-01-09T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (283, N'Sean Pertwee', CAST(N'1964-06-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (284, N'Ron Perlman', CAST(N'1950-04-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (285, N'Selma Blair', CAST(N'1972-06-23T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (286, N'Ben Stiller', CAST(N'1965-11-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (287, N'Juliette Lewis', CAST(N'1973-06-21T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (288, N'Fred Williamson', CAST(N'1938-03-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (289, N'Snoop Dogg', CAST(N'1971-10-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (290, N'Chris Penn', CAST(N'1965-10-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (291, N'Gerard Butler', CAST(N'1969-11-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (292, N'Dominic West', CAST(N'1969-10-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (293, N'David Wenham', CAST(N'1965-09-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (294, N'Lena Headey', CAST(N'1973-10-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (295, N'Malcolm McDowell', CAST(N'1943-06-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (296, N'James Doohan', CAST(N'1920-03-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (297, N'Walter Koenig', CAST(N'1936-09-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (298, N'William Shatner', CAST(N'1931-03-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (299, N'Leonard Nimoy', CAST(N'1931-03-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (300, N'DeForest Kelley', CAST(N'1920-01-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (301, N'George Takei', CAST(N'1937-04-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (302, N'Nichelle Nichols', CAST(N'1932-12-28T00:00:00.000' AS DateTime), N'Female')
GO
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (303, N'Ricardo Montalban', CAST(N'1920-11-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (305, N'Marlon Brando', CAST(N'1924-04-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (306, N'Gene Hackman', CAST(N'1930-01-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (307, N'Christopher Reeve', CAST(N'1952-09-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (308, N'Margot Kidder', CAST(N'1948-10-17T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (309, N'James Gandolfini', CAST(N'1961-09-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (310, N'Val Kilmer', CAST(N'1959-12-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (311, N'Jim Caviezel', CAST(N'1968-09-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (312, N'Uma Thurman', CAST(N'1970-04-29T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (313, N'Lucy Liu', CAST(N'1968-12-02T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (314, N'Daryl Hannah', CAST(N'1960-12-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (315, N'David Carradine', CAST(N'1936-12-08T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (316, N'Charles S. Dutton', CAST(N'1951-01-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (317, N'Pete Postlethwaite', CAST(N'1946-02-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (318, N'Wesley Snipes', CAST(N'1962-07-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (319, N'Kris Kristofferson', CAST(N'1936-06-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (320, N'Donnie Yen', CAST(N'1963-07-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (321, N'Ryan Phillippe', CAST(N'1974-09-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (322, N'Robert De Niro', CAST(N'1943-08-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (323, N'John Rhys-Davies', CAST(N'1944-05-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (324, N'Stephen Dorff', CAST(N'1973-07-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (325, N'James Earl Jones', CAST(N'1931-01-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (326, N'Julianne Moore', CAST(N'1960-12-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (327, N'Joe Pantoliano', CAST(N'1951-09-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (328, N'Madeleine Stowe', CAST(N'1958-08-18T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (329, N'Russell Means', CAST(N'1939-11-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (330, N'Wes Studi', CAST(N'1947-12-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (331, N'Rudy Youngblood', CAST(N'1982-09-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (332, N'Dalia Hernandez', CAST(N'1985-08-14T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (333, N'Rachel McAdams', CAST(N'1976-10-07T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (334, N'Isla Fisher', CAST(N'1976-02-03T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (335, N'Jane Seymour', CAST(N'1951-02-15T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (336, N'Michael J. Fox', CAST(N'1961-06-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (337, N'Thomas F. Wilson', CAST(N'1959-04-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (338, N'Timothy Dalton', CAST(N'1944-03-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (339, N'Benicio Del Toro', CAST(N'1967-02-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (340, N'Robert Brown', CAST(N'1921-07-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblActor] ([ActorID], [ActorName], [ActorDOB], [ActorGender]) VALUES (341, N'David Hedison', CAST(N'1927-05-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (1, 33, 1, N'Ray Ferrier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (2, 1, 2, N'Dr. Alan Grant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (3, 1, 3, N'Dr. Ellie Sattler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (4, 1, 4, N'Dr. Ian Malcolm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (5, 1, 5, N'John Hammond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (6, 1, 6, N'Ray Arnold')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (7, 2, 7, N'Peter Parker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (8, 2, 8, N'Norman Osborn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (9, 2, 9, N'Mary Jane Watson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (10, 3, 10, N'Ann Darrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (11, 3, 11, N'Carl Denham')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (12, 3, 12, N'Jack Driscoll')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (13, 3, 13, N'Kong')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (14, 5, 14, N'Clark Kent')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (15, 5, 15, N'Lois Lane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (16, 5, 16, N'Lex Luthor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (17, 6, 17, N'Jack Dawson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (18, 6, 18, N'Rose DeWitt Bukater')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (19, 6, 19, N'Caledon ''Cal'' Hockley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (20, 6, 20, N'Brock Lovett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (21, 7, 21, N'Evan Baxter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (22, 7, 22, N'God')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (23, 8, 23, N'Mariner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (24, 8, 24, N'Deacon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (25, 8, 11, N'Pilot')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (26, 9, 25, N'Captain Rafe McCawley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (27, 9, 26, N'Captain Danny Walker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (28, 9, 27, N'Nurse Lt. Evelyn Johnson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (29, 9, 28, N'Petty Officer Doris Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (30, 9, 29, N'President Franklin Delano Roosevelt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (31, 9, 30, N'Lt. Col. James Doolittle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (32, 9, 31, N'Sgt. Earl Sistern')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (33, 9, 32, N'Captain Thurman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (34, 10, 33, N'Sam Witwicky')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (35, 10, 37, N'Mikaela Banes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (36, 10, 29, N'Defense Secretary John Keller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (37, 10, 34, N'Agent Simmons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (38, 10, 35, N'Optimus Prime')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (39, 10, 36, N'Megatron')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (40, 11, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (41, 11, 39, N'Lord Voldemort')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (42, 11, 40, N'Alastor ''Mad-Eye'' Moody')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (43, 11, 41, N'Sirius Black')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (44, 11, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (45, 11, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (46, 11, 42, N'Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (47, 11, 43, N'Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (48, 11, 44, N'Sybil Trelawney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (49, 11, 45, N'Bellatrix Lestrange')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (50, 11, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (51, 12, 49, N'Wealthow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (52, 12, 50, N'Hrothgar')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (53, 12, 51, N'Unferth')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (54, 12, 52, N'Beowulf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (55, 12, 40, N'Wiglaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (56, 12, 53, N'Grendel''s Mother')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (57, 7, 54, N'Congressman Long')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (58, 13, 55, N'Barry B. Benson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (59, 13, 56, N'Vanessa Bloome')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (60, 13, 57, N'Adam Flayman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (61, 13, 54, N'Layton T. Montgomery')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (62, 13, 58, N'Mooseblood')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (63, 13, 59, N'Ray Liotta')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (64, 13, 60, N'Lou Lo Duca')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (65, 14, 61, N'Captain Jack Sparrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (66, 14, 62, N'Captain Barbossa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (67, 14, 63, N'Will Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (68, 14, 64, N'Elizabeth Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (69, 14, 65, N'Davy Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (70, 14, 66, N'Governor Weatherby Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (71, 14, 67, N'''Bootstrap'' Bill Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (72, 15, 68, N'Robert Neville')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (73, 15, 44, N'Dr. Alice Krippin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (74, 16, 69, N'Remy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (75, 16, 70, N'Skinner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (76, 16, 71, N'Django')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (77, 16, 72, N'Anton Ego')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (78, 17, 73, N'Agamemnon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (79, 17, 75, N'Achilles')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (80, 17, 40, N'Menelaus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (81, 17, 76, N'Helen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (82, 17, 77, N'Hector')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (83, 17, 63, N'Paris')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (84, 18, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (85, 18, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (86, 18, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (87, 18, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (88, 18, 42, N'Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (89, 18, 43, N'Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (90, 18, 40, N'Professor Alastor ''Mad­Eye'' Moody')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (91, 18, 41, N'Sirius Black')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (92, 18, 39, N'Lord Voldemort')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (93, 19, 78, N'Bruce Wayne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (94, 19, 79, N'Alfred')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (95, 19, 80, N'Henri Ducard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (96, 19, 81, N'Rachel Dawes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (97, 19, 41, N'Jim Gordon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (98, 19, 82, N'Earle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (99, 19, 83, N'Ra''s Al Ghul')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (100, 19, 22, N'Lucius Fox')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (101, 20, 61, N'Willy Wonka')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (102, 20, 45, N'Mrs. Bucket')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (103, 20, 84, N'Mr. Salt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (104, 20, 85, N'Dr. Wonka')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (105, 21, 61, N'Captain Jack Sparrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (106, 21, 63, N'Will Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (107, 21, 64, N'Elizabeth Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (108, 21, 65, N'Davy Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (109, 21, 66, N'Governor Weatherby Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (110, 21, 67, N'''Bootstrap'' Bill Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (111, 22, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (112, 22, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (113, 22, 90, N'R')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (114, 22, 87, N'Jinx')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (115, 22, 88, N'Miranda Frost')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (116, 22, 91, N'Damian Falco')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (117, 22, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (118, 23, 93, N'Martin Riggs')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (119, 23, 94, N'Roger Murtaugh')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (120, 23, 95, N'Leo Getz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (121, 23, 96, N'Lorna Cole')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (122, 23, 58, N'Detective Lee Butters')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (123, 23, 97, N'Wah Sing Ku')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (124, 24, 98, N'Harry S. Stamper')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (125, 24, 99, N'Dan Truman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (126, 24, 25, N'A.J. Frost')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (127, 24, 100, N'Grace Stamper')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (128, 24, 101, N'Rockhound')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (129, 24, 102, N'Oscar Choi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (130, 24, 103, N'Jayotis ''Bear'' Kurleenbear')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (131, 24, 104, N'Lev Andropov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (132, 25, 68, N'Agent Jay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (133, 25, 105, N'Agent Kay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (134, 25, 60, N'Zed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (135, 26, 7, N'Peter Parker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (136, 26, 9, N'Mary Jane Watson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (137, 27, 7, N'Peter Parker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (138, 27, 9, N'Mary Jane Watson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (139, 27, 8, N'Norman Osborn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (140, 28, 106, N'Lt. Henry Purcell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (141, 28, 107, N'Lt. Kara Wade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (142, 29, 30, N'Captain Gray Edwards')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (143, 29, 108, N'Sgt. Ryan Whitaker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (144, 29, 101, N'Officer Neil Fleming')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (145, 29, 109, N'Dr. Cid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (146, 29, 110, N'General Hein')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (147, 30, 111, N'Sonny Crockett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (148, 30, 106, N'Ricardo Tubbs')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (149, 30, 112, N'FBI Agent Fujima')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (150, 31, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (151, 31, 113, N'Elektra')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (152, 31, 114, N'Renard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (153, 31, 115, N'Christmas Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (154, 31, 46, N'Valentin Zukovsky')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (155, 31, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (156, 31, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (157, 31, 90, N'R')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (158, 31, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (159, 32, 117, N'Captain Jack Aubrey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (160, 32, 118, N'Dr. Stephen Maturin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (161, 33, 119, N'Rachel Ferrier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (162, 33, 120, N'Harlan Ogilvy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (163, 34, 121, N'Jason Bourne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (164, 34, 122, N'Nicky Parsons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (165, 34, 123, N'Deputy Director Noah Vosen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (166, 34, 124, N'Simon Ross')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (167, 34, 125, N'Dr. Albert Hirsch')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (168, 35, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (169, 35, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (170, 35, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (171, 35, 41, N'Sirius Black')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (172, 35, 43, N'Professor Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (173, 35, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (174, 35, 44, N'Professor Sybil Trelawney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (175, 36, 126, N'Persephone')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (176, 36, 127, N'Morpheus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (177, 36, 128, N'Trinity')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (178, 36, 129, N'Neo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (179, 36, 36, N'Agent Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (180, 37, 130, N'Dr. Robert Langdon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (181, 37, 131, N'Agent Sophie Neveu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (182, 37, 132, N'Sir Leigh Teabing')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (183, 37, 133, N'Captain Bezu Fache')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (184, 37, 118, N'Silas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (185, 37, 134, N'Andre Vernet')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (186, 38, 135, N'Professor Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (187, 38, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (188, 38, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (189, 38, 136, N'Mr. Ollivander')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (190, 38, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (191, 38, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (192, 38, 90, N'Nearly Headless Nick')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (193, 38, 43, N'Professor Severus Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (194, 39, 137, N'Jack Hall')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (195, 39, 138, N'Sam Hall')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (196, 39, 70, N'Terry Rapson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (197, 40, 61, N'Captain Jack Sparrow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (198, 40, 63, N'Will Turner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (199, 40, 64, N'Elizabeth Swann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (200, 40, 66, N'Governor Weatherby Swann')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (201, 40, 62, N'Captain Barbossa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (202, 41, 1, N'Nathan Algren')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (203, 41, 83, N'Katsumoto')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (204, 264, 140, N'Kaneda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (205, 264, 141, N'Capa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (206, 264, 142, N'Corazon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (207, 19, 141, N'Dr. Jonathan Crane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (208, 41, 140, N'Ujio')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (209, 41, 139, N'Zebulon Gant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (210, 42, 143, N'Captain Billy Tyne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (211, 42, 144, N'Bobby Shatford')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (212, 42, 145, N'Dale ''Murph'' Murphy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (213, 42, 146, N'Linda Greenlaw')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (214, 42, 147, N'Bob Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (215, 43, 1, N'Ethan Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (216, 43, 148, N'Owen Davian')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (217, 43, 108, N'Luther')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (218, 43, 149, N'Julia')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (219, 43, 150, N'Benji')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (220, 43, 127, N'Theodore Brassel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (221, 44, 1, N'Ethan Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (222, 44, 108, N'Luther Stickell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (223, 44, 40, N'John C. McCloy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (224, 45, 151, N'Christian Slater')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (225, 45, 104, N'Gunnery Sergeant Hjelmstad')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (226, 45, 152, N'Sgt. Pete ''Ox'' Anderson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (227, 46, 153, N'Obi-Wan Kenobi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (228, 46, 154, N'Senator Padme Amidala')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (229, 46, 155, N'Anakin Skywalker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (230, 46, 85, N'Count Dooku')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (231, 46, 6, N'Mace Windu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (232, 46, 156, N'Yoda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (233, 46, 157, N'Chancellor Palpatine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (234, 46, 158, N'Jango Fett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (235, 265, 158, N'Jake Heke')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (236, 265, 159, N'Beth Heke')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (237, 47, 54, N'James P. "Sulley" Sullivan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (238, 47, 160, N'Mike Wazowski')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (239, 47, 101, N'Randall Boggs')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (240, 47, 161, N'Henry J. Waternoose')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (241, 47, 156, N'Fungus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (242, 48, 80, N'Qui-Gon Jinn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (243, 48, 153, N'Obi-Wan Kenobi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (244, 48, 154, N'Queen Padme Amidala')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (245, 48, 156, N'Yoda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (246, 48, 157, N'Senator Palpatine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (247, 48, 162, N'Darth Maul')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (248, 48, 163, N'C-3PO')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (249, 48, 164, N'R2-D2')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (250, 48, 6, N'Mace Windu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (251, 48, 64, N'Sabé')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (252, 49, 153, N'Obi-Wan Kenobi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (253, 49, 154, N'Padme')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (254, 49, 155, N'Anakin Skywalker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (255, 49, 157, N'Supreme Chancellor Palpatine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (256, 49, 6, N'Mace Windu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (257, 49, 156, N'Yoda')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (258, 49, 163, N'C-3PO')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (259, 49, 164, N'R2-D2')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (260, 49, 85, N'Count Dooku')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (261, 49, 158, N'Commander Cody')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (262, 49, 165, N'Chewbacca')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (263, 49, 159, N'Nee Alavar')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (264, 50, 126, N'Persephone')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (265, 50, 127, N'Morpheus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (266, 50, 128, N'Trinity')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (267, 50, 129, N'Neo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (268, 50, 36, N'Agent Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (269, 51, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (270, 51, 66, N'Elliot Carver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (271, 51, 142, N'Wai Lin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (272, 51, 166, N'Jack Wade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (273, 51, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (274, 51, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (275, 51, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (276, 52, 143, N'Danny Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (277, 52, 75, N'Rusty Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (278, 52, 167, N'Reuben Tishkoff')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (279, 52, 121, N'Linus Caldwell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (280, 52, 168, N'Terry Benedict')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (281, 52, 169, N'Tess Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (282, 52, 170, N'Basher Tarr')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (283, 53, 98, N'John McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (284, 53, 171, N'Thomas Gabriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (285, 53, 175, N'Mai')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (286, 54, 172, N'Passepartout')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (287, 54, 173, N'Phileas Fogg')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (288, 54, 177, N'Lord Kelvin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (289, 54, 174, N'Prince Hapi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (290, 54, 175, N'Female Agent')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (291, 54, 176, N'Wong Fei Hung')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (292, 54, 102, N'Wilbur Wright')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (293, 54, 90, N'Grizzled Sergeant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (294, 54, 178, N'Orville Wright')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (295, 55, 80, N'Godfrey de Ibelin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (296, 55, 63, N'Balian de Ibelin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (297, 55, 40, N'Reynald')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (298, 55, 179, N'Tiberias')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (299, 55, 180, N'King Baldwin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (300, 56, 75, N'John Smith')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (301, 56, 53, N'Jane Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (302, 56, 181, N'Eddie')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (303, 56, 149, N'Gwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (304, 57, 17, N'Howard Hughes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (305, 57, 182, N'Katharine Hepburn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (306, 57, 27, N'Ava Gardner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (307, 57, 145, N'Noah Dietrich')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (308, 57, 30, N'Juan Trippe')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (309, 57, 70, N'Professor Fitz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (310, 57, 183, N'Errol Flynn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (311, 57, 184, N'Robert Gross')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (312, 57, 8, N'Roland Sweet')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (313, 58, 68, N'Muhammad Ali')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (314, 58, 106, N'Drew ''Bundini'' Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (315, 58, 29, N'Howard Cosell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (316, 59, 182, N'Galadriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (317, 59, 63, N'Legolas Greenleaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (318, 59, 70, N'Bilbo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (319, 59, 85, N'Saruman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (320, 59, 13, N'Gollum')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (321, 59, 132, N'Gandalf the Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (322, 59, 185, N'Aragorn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (323, 59, 100, N'Arwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (324, 59, 36, N'Elrond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (325, 59, 186, N'Frodo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (326, 60, 68, N'Del Spooner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (327, 60, 33, N'Farber')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (328, 60, 188, N'Susan Calvin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (329, 60, 187, N'Dr. Alfred Lanning')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (330, 61, 189, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (331, 61, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (332, 62, 1, N'Chief John Anderton')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (333, 62, 190, N'Director Lamar Burgess')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (334, 62, 111, N'Danny Witwer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (335, 62, 104, N'Dr. Solomon Eddie')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (336, 63, 174, N'The Terminator')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (337, 63, 191, N'Sarah Connor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (338, 63, 192, N'John Connor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (339, 63, 193, N'T-1000')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (340, 64, 87, N'Patience Phillips')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (341, 65, 38, N'Harry Potter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (342, 65, 48, N'Ron Weasley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (343, 65, 47, N'Hermione Granger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (344, 65, 46, N'Rubeus Hagrid')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (345, 65, 194, N'Professor Gilderoy Lockhart')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (346, 65, 43, N'Professor Snape')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (347, 65, 135, N'Professor Albus Dumbledore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (348, 65, 90, N'Nearly Headless Nick')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (349, 66, 195, N'Frank Lucas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (350, 66, 117, N'Detective Richie Roberts')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (351, 67, 17, N'Danny Archer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (352, 67, 196, N'Solomon Vandy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (353, 67, 197, N'Maddy Bowen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (354, 67, 198, N'Colonel Coetzee')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (355, 68, 117, N'Maximus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (356, 68, 199, N'Commodus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (357, 68, 200, N'Lucilla')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (358, 68, 201, N'Proximo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (359, 68, 135, N'Marcus Aurelius')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (360, 68, 196, N'Juba')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (361, 69, 174, N'Harry Tasker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (362, 69, 202, N'Helen Tasker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (363, 69, 203, N'Albert Gibson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (364, 69, 20, N'Simon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (365, 69, 204, N'Spencer Trilby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (366, 69, 205, N'Juno Skinner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (367, 69, 206, N'Salim Abu Aziz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (368, 69, 207, N'Dana Tasker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (369, 70, 17, N'Amsterdam Vallon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (370, 70, 208, N'Bill ''The Butcher'' Cutting')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (371, 70, 209, N'Jenny Everdeane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (372, 70, 177, N'Boss Tweed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (373, 70, 145, N'Happy Jack')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (374, 70, 80, N'''Priest'' Vallon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (375, 70, 40, N'Walter ''Monk'' McGinn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (376, 71, 26, N'Eversmann')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (377, 71, 153, N'Grimes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (378, 71, 31, N'McKnight')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (379, 71, 77, N'Hoot')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (380, 72, 98, N'Korben Dallas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (381, 72, 41, N'Jean-Baptiste Emanuel Zorg')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (382, 72, 70, N'Father Vito Cornelius')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (383, 72, 210, N'Leeloo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (384, 72, 211, N'Ruby Rhod')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (385, 59, 212, N'Boromir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (386, 73, 212, N'Boromir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (387, 73, 182, N'Galadriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (388, 73, 63, N'Legolas Greenleaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (389, 73, 70, N'Bilbo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (390, 73, 132, N'Gandalf the White')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (391, 73, 185, N'Aragorn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (392, 73, 13, N'Gollum')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (393, 73, 100, N'Arwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (394, 73, 36, N'Elrond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (395, 73, 186, N'Frodo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (396, 73, 85, N'Saruman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (397, 74, 182, N'Galadriel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (398, 74, 63, N'Legolas Greenleaf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (399, 74, 85, N'Saruman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (400, 74, 132, N'Gandalf the White')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (401, 74, 185, N'Aragorn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (402, 74, 13, N'Gollum')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (403, 74, 100, N'Arwen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (404, 74, 213, N'Eomer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (405, 73, 213, N'Eomer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (406, 74, 36, N'Elrond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (407, 74, 186, N'Frodo Baggins')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (408, 74, 212, N'Boromir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (409, 75, 172, N'Chief Inspector Lee')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (410, 75, 211, N'Detective James Carter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (411, 75, 190, N'Varden Reynard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (412, 75, 140, N'Kenji')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (413, 76, 172, N'Chief Inspector Lee')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (414, 76, 211, N'Detective James Carter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (415, 76, 175, N'Girl in Car')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (416, 76, 170, N'Kenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (417, 77, 105, N'Agent Kay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (418, 77, 68, N'Agent Jay')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (419, 77, 60, N'Zed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (420, 77, 214, N'Dr. Laurel Weaver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (421, 78, 17, N'William M. ''Billy'' Costigan Jr.')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (422, 78, 121, N'Colin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (423, 78, 215, N'Costello')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (424, 78, 144, N'Dignam')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (425, 78, 216, N'Queenan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (426, 78, 52, N'Mr. French')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (427, 78, 30, N'Ellerby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (428, 79, 98, N'John McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (429, 79, 179, N'Simon Gruber')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (430, 79, 6, N'Zeus Carver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (431, 80, 117, N'Jim Braddock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (432, 80, 56, N'Mae Braddock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (433, 80, 217, N'Joe Gould')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (434, 80, 124, N'Mike Wilson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (435, 81, 121, N'Jason Bourne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (436, 81, 73, N'Ward Abbott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (437, 81, 122, N'Nicky Parsons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (438, 81, 213, N'Kirill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (439, 81, 149, N'Kim')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (440, 82, 174, N'Jack Slater')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (441, 82, 218, N'John Practice')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (442, 82, 132, N'Death')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (443, 82, 219, N'Benedict')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (444, 83, 130, N'Chuck Noland')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (445, 84, 75, N'Rusty Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (446, 84, 221, N'Isabel Lahiri')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (447, 84, 143, N'Danny Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (448, 84, 169, N'Tess Ocean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (449, 84, 168, N'Terry Benedict')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (450, 84, 170, N'Basher Tarr')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (451, 84, 121, N'Linus Caldwell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (452, 84, 167, N'Reuben Tishkoff')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (453, 84, 125, N'Gaspar LeMarque')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (454, 85, 222, N'Michael Newman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (455, 85, 27, N'Donna Newman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (456, 85, 223, N'Morty')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (457, 85, 224, N'Ammer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (458, 85, 225, N'Ted Newman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (459, 86, 226, N'Bruce Nolan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (460, 86, 22, N'God')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (461, 86, 227, N'Grace Connelly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (462, 86, 21, N'Evan Baxter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (463, 87, 1, N'Ethan Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (464, 87, 29, N'Jim Phelps')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (465, 87, 228, N'Claire Phelps')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (466, 87, 133, N'Franz Krieger')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (467, 87, 108, N'Luther Stickell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (468, 87, 232, N'Max')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (469, 88, 229, N'Captain Spurgeon ''Fish'' Tanner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (470, 88, 230, N'Jenny Lerner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (471, 88, 186, N'Leo Beiderman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (472, 88, 232, N'Robin Lerner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (473, 88, 22, N'President Tom Beck')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (474, 88, 187, N'Alan Rittenhouse')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (475, 88, 231, N'Dr. Gus Partenza')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (476, 89, 130, N'Michael Sullivan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (477, 89, 233, N'John Rooney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (478, 89, 189, N'Connor Rooney')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (479, 89, 112, N'Finn McGovern')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (480, 89, 183, N'Harlen Maguire')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (481, 89, 234, N'Frank Nitti')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (482, 90, 117, N'John Nash')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (483, 90, 235, N'Parcher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (484, 90, 197, N'Alicia Nash')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (485, 90, 236, N'Dr. Rosen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (486, 90, 118, N'Charles')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (487, 91, 79, N'Jasper')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (488, 91, 237, N'Theo Faron')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (489, 92, 77, N'Avner')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (490, 92, 189, N'Steve')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (491, 92, 112, N'Carl')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (492, 92, 62, N'Ephraim')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (493, 93, 68, N'Captain Steven Hiller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (494, 93, 238, N'President Thomas J. Whitmore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (495, 93, 4, N'David Levinson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (496, 93, 239, N'First Lady Marilyn Whitmore')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (497, 93, 240, N'Russell Casse')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (498, 93, 184, N'Dr. Brackish Okun')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (499, 94, 241, N'Wolverine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (500, 94, 242, N'Professor Charles Xavier')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (501, 94, 132, N'Magneto')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (502, 94, 243, N'Jean Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (503, 94, 87, N'Storm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (504, 94, 162, N'Toad')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (505, 95, 242, N'Professor Charles Xavier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (506, 95, 241, N'Wolverine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (507, 95, 132, N'Magneto')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (508, 95, 87, N'Storm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (509, 95, 243, N'Jean Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (510, 95, 73, N'William Stryker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (511, 96, 244, N'John Patrick Mason')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (512, 96, 151, N'Dr. Stanley Goodspeed')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (513, 96, 235, N'Brigadier General Francis X. Hummel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (514, 96, 245, N'Commander Anderson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (515, 97, 129, N'John Constantine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (516, 97, 246, N'Angela Dodson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (517, 97, 33, N'Chas Kramer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (518, 97, 196, N'Midnite')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (519, 97, 104, N'Satan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (520, 98, 98, N'David Dunn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (521, 98, 6, N'Elijah Price')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (522, 98, 49, N'Audrey Dunn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (523, 99, 103, N'Lucius Washington')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (524, 99, 247, N'Ricky Bobby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (525, 99, 145, N'Cal Naughton, Jr.')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (526, 99, 248, N'Jean Girard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (527, 100, 249, N'Homer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (528, 100, 251, N'Bart')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (529, 100, 250, N'Marge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (530, 100, 252, N'Lisa')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (531, 101, 93, N'William Wallace')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (532, 101, 73, N'Argyle Wallace')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (533, 101, 253, N'King Edward I')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (534, 101, 113, N'Princess Isabelle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (535, 101, 40, N'Hamish Campbell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (536, 102, 138, N'Anthony Swofford')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (537, 102, 106, N'Staff Sergeant Sykes')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (538, 103, 199, N'Lucius Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (539, 103, 12, N'Noah Percy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (540, 103, 254, N'Edward Walker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (541, 103, 255, N'Alice Hunt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (542, 103, 40, N'August Nicholson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (543, 104, 256, N'Shrek')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (544, 104, 257, N'Donkey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (545, 104, 258, N'Puss in Boots')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (546, 104, 90, N'King')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (547, 105, 256, N'Shrek')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (548, 105, 257, N'Donkey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (549, 105, 258, N'Puss in Boots')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (550, 105, 90, N'King')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (551, 105, 209, N'Princess Fiona')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (552, 104, 209, N'Princess Fiona')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (553, 106, 235, N'Virgil ''Bud'' Brigman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (554, 106, 146, N'Lindsey Brigman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (555, 106, 245, N'Lt. Hiram Coffey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (556, 107, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (557, 107, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (558, 107, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (559, 107, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (560, 107, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (561, 107, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (562, 107, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (563, 107, 218, N'Ad''har Ru''afo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (564, 108, 264, N'Eddie Valiant')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (565, 108, 265, N'Judge Doom')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (566, 108, 266, N'Jessica Rabbit')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (567, 108, 251, N'Dipped Shoe')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (568, 109, 61, N'Ichabod Crane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (569, 109, 267, N'Katrina Van Tassel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (570, 109, 42, N'Baltus Van Tassel')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (571, 109, 157, N'Doctor Lancaster')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (572, 109, 223, N'Hessian Horseman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (573, 109, 85, N'Burgomaster')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (574, 110, 268, N'Xander Cage')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (575, 110, 6, N'Agent Augustus Gibbons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (576, 111, 98, N'John McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (577, 111, 270, N'Holly McClane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (578, 111, 269, N'Colonel Stuart')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (579, 111, 193, N'O''Reilly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (580, 112, 271, N'Samantha Caine')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (581, 112, 6, N'Mitch Henessey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (582, 112, 73, N'Dr. Nathan Waldman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (583, 113, 130, N'Jim Lovell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (584, 113, 20, N'Fred Haise')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (585, 113, 272, N'Jack Swigert')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (586, 113, 273, N'Ken Mattingly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (587, 113, 235, N'Gene Kranz')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (588, 114, 130, N'Captain John H. Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (589, 114, 31, N'Sergeant Mike Horvath')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (590, 114, 268, N'Private Adrian Caparzo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (591, 114, 121, N'Private James Francis Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (592, 114, 217, N'Sergeant Hill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (593, 115, 180, N'The Narrator')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (594, 115, 75, N'Tyler Durden')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (595, 115, 45, N'Marla Singer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (596, 116, 129, N'Neo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (597, 116, 128, N'Trinity')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (598, 116, 127, N'Morpheus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (599, 116, 36, N'Agent Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (600, 117, 174, N'Douglas Quaid')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (601, 64, 274, N'Laurel Hedare')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (602, 82, 274, N'Catherine Tramell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (603, 117, 274, N'Lori')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (604, 117, 147, N'Richter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (605, 118, 275, N'Gabe Walker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (606, 118, 276, N'Eric Qualen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (607, 118, 277, N'Hal Tucker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (608, 119, 278, N'Jack Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (609, 119, 8, N'John Clark')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (610, 120, 86, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (611, 120, 212, N'Alec Trevelyan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (612, 120, 243, N'Xenia Zirgavna Onatopp')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (613, 120, 166, N'Jack Wade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (614, 120, 89, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (615, 120, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (616, 120, 92, N'Miss Moneypenny')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (617, 121, 26, N'Dwight ''Bucky'' Bleichert')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (618, 121, 279, N'Kay Lake')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (619, 121, 280, N'Madeleine Linscott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (620, 122, 226, N'Truman Burbank')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (621, 122, 235, N'Christof')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (622, 122, 217, N'Control Room Director')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (623, 123, 127, N'Captain Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (624, 123, 2, N'Dr. William Weir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (625, 123, 281, N'Peters, Med Tech')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (626, 113, 281, N'Marilyn Lovell')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (627, 123, 282, N'Lt. Starck')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (628, 123, 283, N'Smith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (629, 124, 121, N'Jason Bourne')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (630, 124, 237, N'The Professor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (631, 124, 73, N'Ward Abbott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (632, 124, 122, N'Nicky Parsons')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (633, 125, 284, N'Hellboy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (634, 125, 136, N'Trevor ''Broom'' Bruttenholm')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (635, 125, 285, N'Liz Sherman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (637, 126, 102, N'Ken Hutchinson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (638, 126, 286, N'David Starsky')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (639, 126, 289, N'Huggy Bear')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (640, 126, 288, N'Captain Doby')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (641, 126, 181, N'Reese Feldman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (642, 126, 287, N'Kitty')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (643, 126, 290, N'Manetti')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (644, 126, 69, N'Disco DJ')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (645, 127, 143, N'Miles')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (646, 127, 221, N'Marylin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (647, 127, 62, N'Donovan Donaly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (648, 127, 99, N'Howard D. Doyle')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (649, 73, 293, N'Faramir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (650, 74, 293, N'Faramir')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (651, 128, 291, N'King Leonidas')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (652, 128, 294, N'Queen Gorgo')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (653, 128, 292, N'Theron')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (654, 128, 293, N'Dilios')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (655, 129, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (656, 129, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (657, 129, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (658, 129, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (659, 129, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (660, 129, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (661, 129, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (662, 129, 284, N'The Reman Viceroy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (663, 146, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (664, 146, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (665, 146, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (666, 146, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (667, 146, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (668, 146, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (669, 146, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (670, 146, 187, N'Dr. Zefram Cochrane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (671, 160, 242, N'Captain Jean-Luc Picard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (672, 160, 259, N'Commander William T. Riker')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (673, 160, 184, N'Lt. Commander Data')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (674, 160, 260, N'Lt. Commander Geordi La Forge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (675, 160, 261, N'Lt. Commander Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (676, 160, 262, N'Dr. Beverly Crusher')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (677, 160, 263, N'Commander Deanna Troi')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (678, 160, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (679, 160, 295, N'Dr. Tolian Soran')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (680, 160, 296, N'Captain Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (681, 160, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (682, 225, 298, N'Admiral James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (683, 225, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (684, 225, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (685, 225, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (686, 225, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (688, 225, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (689, 225, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (690, 225, 303, N'Khan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (700, 162, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (701, 162, 297, N'Lt. Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (702, 162, 301, N'Lt. Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (703, 162, 302, N'Lt. Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (704, 162, 298, N'Admiral James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (705, 162, 299, N'Mr Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (706, 162, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (708, 201, 265, N'Commander Kruge')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (709, 201, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (710, 201, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (711, 201, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (712, 201, 302, N'Commander Uhura')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (713, 201, 298, N'Admiral James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (714, 201, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (715, 201, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (716, 174, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (717, 174, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (718, 174, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (719, 174, 296, N'Captain Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (720, 174, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (721, 174, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (722, 174, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (723, 180, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (724, 180, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (725, 180, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (726, 180, 296, N'Captain Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (727, 180, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (728, 180, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (729, 180, 301, N'Captain Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (730, 180, 236, N'General Chang')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (731, 180, 261, N'Colonel Worf')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (732, 180, 152, N'Excelsior Communications Officer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (733, 191, 298, N'Captain James T. Kirk')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (734, 191, 299, N'Captain Spock')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (735, 191, 300, N'Dr. Leonard "Bones" McCoy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (736, 191, 296, N'Commander Montgomery "Scotty" Scott')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (737, 191, 301, N'Commander Hikaru Sulu')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (738, 191, 297, N'Commander Pavel Chekov')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (739, 191, 302, N'Commander Uhura')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (740, 130, 307, N'Clark Kent')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (741, 130, 305, N'Jor-El')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (742, 130, 306, N'Lex Luthor')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (743, 130, 308, N'Lois Lane')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (744, 131, 195, N'Lt. Commander Ron Hunter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (745, 131, 306, N'Captain Frank Ramsey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (746, 131, 185, N'Lt. Peter ''WEAPS'' Ince')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (747, 131, 309, N'Lt. Bobby Dougherty')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (748, 132, 195, N'Agent Doug Carlin')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (749, 132, 310, N'Agent Paul Pryzwarra')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (750, 132, 311, N'Carroll Oerstadt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (751, 133, 195, N'Creasy')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (752, 133, 119, N'Pita')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (753, 133, 223, N'Rayburn')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (754, 134, 68, N'Robert Clayton Dean')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (755, 134, 306, N'Brill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (756, 134, 29, N'Reynolds')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (757, 134, 11, N'Fiedler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (758, 134, 31, N'Boss Paulie Pintero')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (759, 135, 312, N'The Bride')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (760, 135, 313, N'O-Ren Ishii')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (761, 135, 314, N'Elle Driver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (762, 135, 315, N'Bill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (763, 135, 91, N'Budd')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (764, 136, 255, N'Ellen Ripley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (765, 136, 316, N'Dillon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (766, 136, 219, N'Clemens')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (767, 136, 317, N'David')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (768, 137, 172, N'Chon Wang')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (769, 137, 102, N'Roy O''Bannon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (770, 137, 313, N'Princess Pei Pei')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (771, 138, 312, N'The Bride')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (772, 138, 315, N'Bill')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (773, 138, 313, N'O-Ren Ishii')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (774, 138, 91, N'Budd')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (775, 138, 314, N'Elle Driver')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (776, 138, 6, N'Rufus')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (777, 139, 318, N'Blade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (778, 139, 319, N'Abraham Whistler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (779, 139, 284, N'Reinhardt')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (780, 139, 320, N'Snowman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (781, 140, 321, N'John "Doc" Bradley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (782, 140, 193, N'Colonel Chandler Johnson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (783, 141, 322, N'Sam ''Ace'' Rothstein')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (784, 141, 274, N'Ginger McKenna')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (785, 141, 95, N'Nicky Santoro')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (786, 141, 110, N'Lester Diamond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (787, 142, 23, N'Robin of Locksley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (788, 142, 22, N'Azeem')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (789, 142, 146, N'Marian Dubois')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (790, 142, 152, N'Will Scarlett')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (791, 142, 43, N'Sheriff of Nottingham')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (792, 142, 244, N'King Richard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (793, 143, 256, N'Shrek')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (794, 143, 257, N'Donkey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (795, 143, 209, N'Princess Fiona')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (796, 143, 276, N'Lord Farquaad')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (797, 144, 172, N'Chon Wang')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (798, 144, 102, N'Roy O''Bannon')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (799, 144, 320, N'Wu Chow')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (800, 145, 278, N'Indiana Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (801, 145, 244, N'Professor Henry Jones')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (802, 145, 323, N'Sallah')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (803, 59, 323, N'Gimli')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (804, 73, 323, N'Gimli')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (805, 74, 323, N'Gimli')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (806, 147, 318, N'Blade')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (807, 147, 319, N'Abraham Whistler')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (808, 147, 324, N'Deacon Frost')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (809, 148, 278, N'Jack Ryan')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (810, 148, 212, N'Sean Miller')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (811, 148, 6, N'Lt. Cmdr. Robby Jackson')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (812, 148, 135, N'Paddy O''Neil')
GO
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (813, 148, 325, N'Admiral James Greer')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (814, 149, 278, N'Dr. Richard David Kimble')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (815, 149, 105, N'Marshal Samuel Gerard')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (816, 149, 326, N'Dr. Anne Eastman')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (817, 149, 327, N'Deputy Marshal Cosmo Renfro')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (818, 150, 241, N'Robert Angier')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (819, 150, 78, N'Alfred Borden')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (820, 150, 79, N'Cutter')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (821, 150, 279, N'Olivia Wenscombe')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (822, 150, 13, N'Alley')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (823, 151, 208, N'Hawkeye')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (824, 151, 328, N'Cora Munro')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (825, 151, 329, N'Chinachgook')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (826, 151, 330, N'Magua')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (827, 152, 331, N'Jaguar Paw')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (828, 152, 332, N'Seven')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (829, 153, 102, N'John Beckwith')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (830, 153, 181, N'Jeremy Grey')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (831, 153, 223, N'Secretary William Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (832, 153, 333, N'Claire Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (833, 153, 334, N'Gloria Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (834, 153, 335, N'Kathleen Cleary')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (835, 154, 336, N'Marty McFly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (836, 154, 265, N'Dr. Emmett Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (837, 154, 337, N'Buford ''Mad Dog'' Tannen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (838, 155, 336, N'Marty McFly')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (839, 155, 265, N'Dr. Emmett Brown')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (840, 155, 337, N'Biff Tannen')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (841, 156, 338, N'James Bond')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (842, 156, 339, N'Dario')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (843, 156, 116, N'Q')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (844, 156, 340, N'M')
INSERT [dbo].[tblCast] ([CastID], [CastFilmID], [CastActorID], [CastCharacterName]) VALUES (845, 156, 341, N'Felix Leiter')
INSERT [dbo].[tblCertificate] ([CertificateID], [Certificate]) VALUES (1, N'U')
INSERT [dbo].[tblCertificate] ([CertificateID], [Certificate]) VALUES (2, N'PG')
INSERT [dbo].[tblCertificate] ([CertificateID], [Certificate]) VALUES (3, N'12')
INSERT [dbo].[tblCertificate] ([CertificateID], [Certificate]) VALUES (4, N'12A')
INSERT [dbo].[tblCertificate] ([CertificateID], [Certificate]) VALUES (5, N'15')
INSERT [dbo].[tblCertificate] ([CertificateID], [Certificate]) VALUES (6, N'18')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (48, N'China')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (79, N'France')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (118, N'Japan')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (167, N'New Zealand')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (240, N'United Kingdom')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (241, N'United States')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (257, N'Germany')
INSERT [dbo].[tblCountry] ([CountryID], [CountryName]) VALUES (258, N'Russia')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (4, N'Steven Spielberg', CAST(N'1946-12-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (5, N'Joel Coen', CAST(N'1954-11-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (6, N'Ethan Coen', CAST(N'1957-09-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (7, N'George Lucas', CAST(N'1944-05-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (8, N'Ang Lee', CAST(N'1954-10-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (9, N'Martin Scorsese', CAST(N'1942-11-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (10, N'Clint Eastwood', CAST(N'1930-05-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (11, N'Sam Raimi', CAST(N'1959-10-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (12, N'Peter Jackson', CAST(N'1961-10-31T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (14, N'Bryan Singer', CAST(N'1965-09-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (15, N'James Cameron', CAST(N'1954-08-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (16, N'Tom Shadyac', CAST(N'1958-12-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (17, N'Kevin Reynolds', CAST(N'1952-01-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (18, N'Michael Bay', CAST(N'1965-02-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (19, N'David Yates', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (20, N'Robert Zemeckis', CAST(N'1952-05-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (21, N'Steve Hickner', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (22, N'Gore Verbinski', CAST(N'1964-03-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (23, N'Francis Lawrence', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (24, N'Brad Bird', CAST(N'1957-09-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (25, N'Wolfgang Peterson', CAST(N'1941-03-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (26, N'Mike Newell', CAST(N'1942-03-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (27, N'Christopher Nolan', CAST(N'1970-07-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (28, N'Tim Burton', CAST(N'1958-08-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (29, N'Lee Tamahori', CAST(N'1950-06-17T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (30, N'Richard Donner', CAST(N'1930-04-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (31, N'Barry Sonnenfeld', CAST(N'1953-04-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (32, N'Rob Cohen', CAST(N'1949-03-12T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (33, N'Hironobu Sakaguchi', CAST(N'1962-11-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (34, N'Michael Mann', CAST(N'1943-02-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (35, N'Michael Apted', CAST(N'1941-02-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (36, N'Peter Weir', CAST(N'1944-08-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (37, N'Paul Greengrass', CAST(N'1955-08-13T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (38, N'Alfonso Cuaron', CAST(N'1961-11-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (39, N'Andy Wachowski', CAST(N'1967-12-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (40, N'Ron Howard', CAST(N'1954-03-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (41, N'Chris Columbus', CAST(N'1958-09-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (42, N'Roland Emmerich', CAST(N'1955-11-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (43, N'Edward Zwick', CAST(N'1952-10-08T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (44, N'J. J. Abrams', CAST(N'1966-06-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (45, N'John Woo', CAST(N'1946-09-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (46, N'Pete Docter', CAST(N'1968-08-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (47, N'Roger Spottiswoode', CAST(N'1945-01-05T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (48, N'Steven Soderbergh', CAST(N'1963-01-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (49, N'Len Wiseman', CAST(N'1973-03-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (50, N'Frank Coraci', CAST(N'1966-02-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (51, N'Ridley Scott', CAST(N'1937-11-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (52, N'Doug Liman', CAST(N'1965-07-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (53, N'Alex Proyas', CAST(N'1963-09-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (54, N'Martin Campbell', CAST(N'1940-10-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (55, N'Jean-Christophe Comar', CAST(N'1957-07-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (56, N'Luc Besson', CAST(N'1959-03-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (57, N'Brett Ratner', CAST(N'1969-03-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (58, N'John McTiernan', CAST(N'1951-01-08T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (59, N'Brian De Palma', CAST(N'1940-09-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (60, N'Mimi Leder', CAST(N'1952-01-26T00:00:00.000' AS DateTime), N'Female')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (61, N'Sam Mendes', CAST(N'1965-08-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (62, N'M. Night Shyamalan', CAST(N'1970-08-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (63, N'Adam McKay', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (64, N'David Silverman', CAST(N'1957-03-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (65, N'Mel Gibson', CAST(N'1956-01-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (66, N'Chris Miller', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (67, N'Andrew Adamson', CAST(N'1966-12-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (68, N'Jonathon Frakes', CAST(N'1952-08-19T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (69, N'Renny Harlin', CAST(N'1959-03-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (70, N'David Fincher', CAST(N'1962-08-28T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (71, N'Guillermo del Toro', CAST(N'1964-10-09T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (72, N'Paul Verhoeven', CAST(N'1938-07-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (73, N'Phillip Noyce', CAST(N'1950-04-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (74, N'Paul Anderson', CAST(N'1965-03-04T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (75, N'Todd Phillips', CAST(N'1970-12-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (76, N'Zack Snyder', CAST(N'1966-03-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (77, N'Stuart Baird', CAST(N'1947-11-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (78, N'Tony Scott', CAST(N'1944-06-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (79, N'Quentin Tarantino', CAST(N'1963-03-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (80, N'Tom Dey', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (81, N'David Dobkin', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (82, N'Stephen Norrington', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (83, N'Andrew Davis', CAST(N'1946-11-21T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (84, N'John Glen', CAST(N'1932-05-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (85, N'Frank Miller', CAST(N'1957-01-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (86, N'Joss Whedon', CAST(N'1964-06-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (87, N'David Carson', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (88, N'Irvin Kershner', CAST(N'1923-04-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (89, N'Robert Wise', CAST(N'1914-09-10T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (90, N'Richard Marquand', CAST(N'1938-04-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (91, N'David Cronenberg', CAST(N'1943-03-15T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (92, N'Lewis Gilbert', CAST(N'1920-03-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (93, N'Andrew Dominik', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (94, N'Ivan Reitman', CAST(N'1946-10-27T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (95, N'William Shatner', CAST(N'1931-03-22T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (96, N'Nicholas Meyer', CAST(N'1945-12-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (97, N'Paul Michael Glaser', CAST(N'1943-03-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (98, N'Kevin Costner', CAST(N'1955-01-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (99, N'Leonard Nimoy', CAST(N'1931-03-26T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (100, N'John Guillermin', CAST(N'1925-11-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (101, N'Richard Attenborough', CAST(N'1923-08-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (102, N'Kurt Wimmer', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (103, N'Robert Rodriguez', CAST(N'1968-06-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (104, N'Larry Charles', CAST(N'1956-02-20T00:00:00.000' AS DateTime), N'Male')
GO
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (105, N'Yimou Zhang', CAST(N'1951-11-14T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (106, N'Edgar Wright', CAST(N'1974-04-18T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (107, N'Ang Lee', CAST(N'1954-10-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (108, N'Danny Boyle', CAST(N'1956-10-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (109, N'Oliver Hirschbiegel', CAST(N'1957-12-29T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (110, N'Val Guest', CAST(N'1911-12-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (111, N'Jean-Pierre Jeunet', CAST(N'1953-09-03T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (112, N'Terence Young', CAST(N'1915-06-20T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (113, N'Peter R. Hunt', CAST(N'1925-03-11T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (114, N'Stanley Tong', NULL, N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (115, N'Guy Hamilton', CAST(N'1922-09-16T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (116, N'George Clooney', CAST(N'1961-05-06T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (117, N'Michael Anderson', CAST(N'1920-01-30T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (118, N'Sammo Hung', CAST(N'1952-01-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (119, N'Timur Bekmambetov', CAST(N'1961-06-25T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (120, N'Florian Henckel von Donnersmarck', CAST(N'1973-05-02T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (121, N'Merian C. Cooper', CAST(N'1893-10-24T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (122, N'Akira Kurosawa', CAST(N'1910-10-23T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (123, N'Morgan Spurlock', CAST(N'1970-11-07T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (124, N'Oliver Owl', CAST(N'1970-01-01T00:00:00.000' AS DateTime), N'Male')
INSERT [dbo].[tblDirector] ([DirectorID], [DirectorName], [DirectorDOB], [DirectorGender]) VALUES (125, N'Wendy Wise', CAST(N'1971-02-01T00:00:00.000' AS DateTime), N'Female')
SET IDENTITY_INSERT [dbo].[tblFilm] ON 

INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (1, N'Jurassic Park', CAST(N'1993-07-16T00:00:00.000' AS DateTime), 4, 1, 241, 1, N'Scientists clone dinosaurs to populate a theme park which suffers a major security breakdown and releases the dinosaurs.', 127, 2, 63000000, 920100000, 3, 3, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (2, N'Spider-Man', CAST(N'2002-06-14T00:00:00.000' AS DateTime), 11, 1, 241, 5, N'When bitten by a genetically modified spider, a nerdy, shy, and awkward high school student gains spider-like abilities that he eventually must use to fight evil as a superhero after tragedy befalls his family.', 121, 4, 139000000, 821606375, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (3, N'King Kong', CAST(N'2005-12-15T00:00:00.000' AS DateTime), 12, 1, 241, 1, N'In 1933 New York, an overly ambitious movie producer coerces his cast and hired ship crew to travel to mysterious Skull Island, where they encounter Kong, a giant ape who is immediately smitten with leading lady Ann Darrow.', 187, 4, 207000000, 550316796, 4, 3, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (5, N'Superman Returns', CAST(N'2006-07-16T00:00:00.000' AS DateTime), 14, 1, 241, 6, N'After a long visit to the lost remains of the planet Krypton, the Man of Steel returns to earth to become the peoples savior once again and reclaim the love of Lois Lane.', 154, 4, 204000000, 391120000, 1, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (6, N'Titanic', CAST(N'1998-01-23T00:00:00.000' AS DateTime), 15, 1, 241, 4, N'Fictional romantic tale of a rich girl and poor boy who meet on the ill-fated voyage of the ''unsinkable'' ship.', 194, 3, 200000000, 1835400000, 14, 11, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (7, N'Evan Almighty', CAST(N'2007-08-03T00:00:00.000' AS DateTime), 16, 1, 241, 1, N'God (Freeman) contacts Congressman Evan Baxter (Carell) and tells him to build an ark in preparation for a great flood.', 95, 2, 175000000, 173219280, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (8, N'Waterworld', CAST(N'1995-08-11T00:00:00.000' AS DateTime), 17, 1, 241, 1, N'In a future where the polar ice caps have melted and most of Earth is underwater, a mutated mariner fights starvation and outlaw "smokers," and reluctantly helps a woman and a young girl find dry land.', 136, 3, 175000000, 264246220, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (9, N'Pearl Harbor', CAST(N'2001-06-01T00:00:00.000' AS DateTime), 18, 1, 241, 7, N'Pearl Harbor follows the story of two best friends, Rafe and Danny, and their love lives as they go off to join the war.', 183, 3, 151500000, 450500000, 4, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (10, N'Transformers', CAST(N'2007-07-27T00:00:00.000' AS DateTime), 18, 1, 241, 8, N'A war re-erupts on Earth between two robotic clans, the heroic Autobots and the evil Decepticons, leaving the fate of mankind hanging in the balance.', 144, 4, 151000000, 707675744, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (11, N'Harry Potter and the Order of the Phoenix', CAST(N'2007-07-12T00:00:00.000' AS DateTime), 19, 1, 240, 6, N'With their warning about Lord Voldemort''s return scoffed at, Harry and Dumbledore are targeted by the Wizard authorities as an authoritarian bureaucrat slowly seizes power at Hogwarts.', 138, 4, 150000000, 938454486, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (12, N'Beowulf', CAST(N'2007-11-16T00:00:00.000' AS DateTime), 20, 1, 241, 2, N'The warrior Beowulf must fight and defeat the monster Grendel who is terrorizing towns, and later, Grendel''s mother, who begins killing out of revenge.', 113, 4, 150000000, 194995215, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (13, N'Bee Movie', CAST(N'2007-12-14T00:00:00.000' AS DateTime), 21, 1, 241, 8, N'Barry B. Benson, a bee who has just graduated from college, is disillusioned at his lone career choice: making honey. On a special trip outside the hive, Barry''s life is saved by Vanessa, a florist in New York City. As their relationship blossoms, he discovers humans actually eat honey, and subsequently decides to sue us.', 90, 1, 150000000, 286758211, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (14, N'Pirates of the Caribbean: At World''s End', CAST(N'2007-05-24T00:00:00.000' AS DateTime), 22, 1, 241, 3, N'Captain Barbossa, Will Turner and Elizabeth Swann must sail off the edge of the map, navigate treachery and betrayal, and make their final alliances for one last decisive battle.', 168, 4, 150000000, 952404152, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (15, N'I am Legend', CAST(N'2007-12-26T00:00:00.000' AS DateTime), 23, 1, 241, 6, N'Years after a plague kills most of humanity and transforms the rest into monsters, the sole survivor in New York City struggles valiantly to find a cure.', 101, 5, 150000000, 583527323, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (16, N'Ratatouille', CAST(N'2007-10-12T00:00:00.000' AS DateTime), 24, 1, 241, 10, N'Remy is a young rat in the French countryside who arrives in Paris, only to find out that his cooking idol is dead. When he makes an unusual alliance with a restaurant''s new garbage boy, the culinary and personal adventures begin despite Remy''s family''s skepticism and the rat-hating world of humans.', 106, 1, 150000000, 617245654, 5, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (17, N'Troy', CAST(N'2004-05-21T00:00:00.000' AS DateTime), 25, 1, 241, 6, N'An adaptation of Homer''s great epic, the film follows the assault on Troy by the united Greek forces and chronicles the fates of the men involved.', 163, 5, 150000000, 497298577, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (18, N'Harry Potter and the Goblet of Fire', CAST(N'2005-11-18T00:00:00.000' AS DateTime), 26, 1, 241, 6, N'Harry finds himself selected as an underaged competitor in a dangerous multi-wizardary school competition.', 157, 4, 150000000, 896013036, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (19, N'Batman Begins', CAST(N'2005-06-16T00:00:00.000' AS DateTime), 27, 1, 241, 6, N'The story of how Bruce Wayne became what he was destined to be: Batman.', 140, 4, 150000000, 371824647, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (20, N'Charlie and the Chocolate Factory', CAST(N'2005-07-29T00:00:00.000' AS DateTime), 28, 1, 241, 6, N'A young boy wins a tour through the most magnificent chocolate factory in the world, led by the world''s most unusual candy maker.', 115, 2, 150000000, 473459076, 1, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (21, N'Pirates of the Caribbean: Dead Man''s Chest', CAST(N'2006-07-06T00:00:00.000' AS DateTime), 22, 1, 241, 3, N'Jack Sparrow races to recover the heart of Davy Jones to avoid enslaving his soul to Jones'' service, as other friends and foes seek the heart for their own agenda as well.', 150, 4, 150000000, 1065659812, 4, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (22, N'Die Another Day', CAST(N'2002-11-20T00:00:00.000' AS DateTime), 29, 1, 240, 11, N'James Bond is sent to investigate the connection between a North Korean terrorist and a diamond mogul who is funding the development of an international space weapon.', 133, 4, 142000000, 431942139, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (23, N'Lethal Weapon 4', CAST(N'1998-09-18T00:00:00.000' AS DateTime), 30, 1, 241, 6, N'With personal crises and age weighing in on them, LAPD officers Riggs and Murtaugh must contend with a deadly Chinese crimelord trying to get his brother out of prison.', 127, 5, 140000000, 285400000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (24, N'Armageddon', CAST(N'1998-08-07T00:00:00.000' AS DateTime), 18, 1, 241, 7, N'When an asteroid the size of Texas is headed for Earth the world''s best deep core drilling team is sent to nuke the rock from the inside.', 150, 3, 140000000, 554600000, 4, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (25, N'Men in Black II', CAST(N'2002-08-02T00:00:00.000' AS DateTime), 31, 1, 241, 5, N'Agent J needs help so he is sent to find Agent K and restore his memory.', 88, 2, 140000000, 441818803, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (26, N'Spider-Man 3', CAST(N'2007-05-04T00:00:00.000' AS DateTime), 11, 1, 241, 5, N'A strange black entity from another world bonds with Peter Parker and causes inner turmoil as he contends with new villains, temptations, and revenge.', 139, 4, 258000000, 891930303, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (27, N'Spider-Man 2', CAST(N'2004-07-16T00:00:00.000' AS DateTime), 11, 1, 241, 5, N'Peter Parker is beset with troubles in his failing personal life as he battles a brilliant scientist named Doctor Otto Octavius, who becomes Doctor Octopus (aka Doc Ock), after an accident causes him to bond psychically with mechanical tentacles that do his bidding.', 127, 4, 200000000, 784024485, 3, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (28, N'Stealth', CAST(N'2005-08-05T00:00:00.000' AS DateTime), 32, 1, 241, 5, N'Deeply ensconced in a top-secret military program, three pilots struggle to bring an artificial intelligence program under control ... before it initiates the next world war.', 121, 4, 138000000, 76416746, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (29, N'Final Fantasy: The Spirits Within', CAST(N'2001-08-03T00:00:00.000' AS DateTime), 33, 1, 118, 12, N'A female scientist makes a last stand on Earth with the help of a ragtag team of soldiers against an invasion of alien phantoms.', 106, NULL, 137000000, 85131830, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (30, N'Miami Vice', CAST(N'2006-08-04T00:00:00.000' AS DateTime), 34, 1, 241, 1, N'Based on the 1980''s TV action/drama, this update focuses on vice detectives Crockett and Tubbs as their respective personal and professional lives become dangerously intertwined.', 134, NULL, 135000000, 163818556, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (31, N'The World Is Not Enough', CAST(N'1999-11-26T00:00:00.000' AS DateTime), 35, 1, 240, 11, N'James Bond uncovers a nuclear plot when he protects an oil heiress from her former kidnapper, an international terrorist who can''t feel pain.', 128, 3, 135000000, 361730660, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (32, N'Master and Commander: The Far Side of the World', CAST(N'2003-11-28T00:00:00.000' AS DateTime), 36, 1, 241, 4, N'During the Napoleonic Wars, a brash British captain pushes his ship and crew to their limits in pursuit of a formidable French war vessel around South America.', 138, 4, 135000000, 209486484, 10, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (33, N'War of the Worlds', CAST(N'2005-07-01T00:00:00.000' AS DateTime), 4, 1, 241, 2, N'As Earth is invaded by alien tripod fighting machines, one family fights for survival.', 116, 4, 132000000, 591745532, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (34, N'The Bourne Ultimatum', CAST(N'2007-08-17T00:00:00.000' AS DateTime), 37, 1, 241, 1, N'Bourne dodges new, superior assassins as he searches for his unknown past while a government agent tries to track him down.', 115, 4, 130000000, 442748521, 3, 3, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (35, N'Harry Potter and the Prisoner of Azkaban', CAST(N'2004-05-31T00:00:00.000' AS DateTime), 38, 1, 240, 6, N'It''s Harry''s third year at Hogwarts; not only does he have a new "Defense Against the Dark Arts" teacher, but there is also trouble brewing. Convicted murderer Sirius Black has escaped the Wizards'' Prison and is coming after Harry.', 141, 2, 130000000, 795538952, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (36, N'The Matrix Reloaded', CAST(N'2003-05-21T00:00:00.000' AS DateTime), 39, 1, 241, 6, N'Neo and the rebel leaders estimate that they have 72 hours until 250,000 probes discover Zion and destroy it and its inhabitants. During this, Neo must decide how he can save Trinity from a dark fate in his dreams.', 138, 5, 127000000, 738576929, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (37, N'The Da Vinci Code', CAST(N'2006-05-19T00:00:00.000' AS DateTime), 40, 1, 241, 5, N'A murder inside the Louvre and clues in Da Vinci paintings lead to the discovery of a religious mystery protected by a secret society for two thousand years -- which could shake the foundations of Christianity.', 149, 4, 125000000, 757536138, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (38, N'Harry Potter and the Sorcerer''s Stone', CAST(N'2001-11-16T00:00:00.000' AS DateTime), 41, 1, 240, 6, N'Rescued from the outrageous neglect of his aunt and uncle, a young boy with a great destiny proves his worth while attending Hogwarts School of Witchcraft and Wizardry.', 152, 2, 125000000, 976457891, 3, 0, 2, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (39, N'The Day After Tomorrow', CAST(N'2004-05-27T00:00:00.000' AS DateTime), 42, 1, 241, 4, N'A climatologist tries to figure out a way to save the world from abrupt global warming. He must get to his young son in New York, which is being taken over by a new ice age.', 124, 4, 125000000, 542740799, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (40, N'Pirates of the Caribbean: The Curse of The Black Pearl', CAST(N'2003-08-08T00:00:00.000' AS DateTime), 22, 1, 241, 3, N'Blacksmith Will Turner teams up with eccentric pirate "Captain" Jack Sparrow to save his love, the governor''s daughter, from Jack''s former pirate allies, who are now undead.', 143, 3, 125000000, 655011224, 5, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (41, N'The Last Samurai', CAST(N'2004-01-09T00:00:00.000' AS DateTime), 43, 1, 241, 6, N'An American military advisor embraces the Samurai culture he was hired to destroy after he is captured in battle.', 154, 5, 120000000, 456810575, 4, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (42, N'The Perfect Storm', CAST(N'2000-07-28T00:00:00.000' AS DateTime), 25, 1, 241, 6, N'An unusually intense storm pattern catches some commercial fishermen unaware and puts them in mortal danger.', 130, 3, 120000000, 328711434, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (43, N'Mission: Impossible III', CAST(N'2006-05-04T00:00:00.000' AS DateTime), 44, 1, 241, 2, N'Ethan Hunt comes face to face with a dangerous and sadistic arms dealer while trying to keep his identity secret in order to protect his girlfriend.', 126, 4, 150000000, 397501348, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (44, N'Mission: Impossible II', CAST(N'2000-07-07T00:00:00.000' AS DateTime), 45, 1, 241, 2, N'A secret agent is sent to Sydney, to find and destroy a genetically modified disease called "Chimera"', 123, 5, 120000000, 546209889, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (45, N'Windtalkers', CAST(N'2002-08-30T00:00:00.000' AS DateTime), 45, 1, 241, 11, N'Two U.S. Marines in WWII are assigned to protect Navajo Marines who use their native language as an unbreakable radio cypher.', 134, 5, 115000000, 77628265, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (46, N'Star Wars: Episode II - Attack of the Clones', CAST(N'2002-05-16T00:00:00.000' AS DateTime), 7, 1, 241, 13, N'Anakin Skywalker shares a forbidden romance with Padmé Amidala while his teacher, Obi-Wan Kenobi, makes an investigation of a separatist assassination attempt on Padmé which leads to the discovery of a secret Republican clone army.', 142, 2, 115000000, 656695615, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (47, N'Monsters, Inc.', CAST(N'2002-02-08T00:00:00.000' AS DateTime), 46, 1, 241, 10, N'Monsters generate their city''s power by scaring children, but they are terribly afraid themselves of being contaminated by children, so when one enters Monstropolis, top scarer Sulley find his world disrupted.', 92, 1, 115000000, 525370172, 3, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (48, N'Star Wars: Episode I - The Phantom Menace', CAST(N'1999-07-16T00:00:00.000' AS DateTime), 7, 1, 241, 13, N'The evil Trade Federation, led by Nute Gunray (Carson) is planning to take over the peaceful world of Naboo.', 133, 1, 115000000, 924288297, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (49, N'Star Wars: Episode III - Revenge of the Sith', CAST(N'2005-05-19T00:00:00.000' AS DateTime), 7, 1, 241, 13, N'After three years of fighting in the Clone Wars, Anakin Skywalker concludes his journey towards the Dark Side of the Force, putting his friendship with Obi Wan Kenobi and his marriage at risk.', 140, 4, 115000000, 848470577, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (50, N'The Matrix Revolutions', CAST(N'2003-11-05T00:00:00.000' AS DateTime), 39, 1, 241, 6, N'The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.', 129, 5, 110000000, 424259759, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (51, N'Tomorrow Never Dies', CAST(N'1997-12-12T00:00:00.000' AS DateTime), 47, 1, 240, 11, N'James Bond heads to stop a media mogul''s plan to induce war between China and the UK in order to obtain exclusive global media coverage.', 119, 3, 110000000, 339504276, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (52, N'Ocean''s Eleven', CAST(N'2002-02-15T00:00:00.000' AS DateTime), 48, 1, 241, 6, N'Danny Ocean and his ten accomplices plan to rob three Las Vegas casinos simultaneously.', 116, 3, 110000000, 450728529, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (53, N'Live Free or Die Hard', CAST(N'2007-07-04T00:00:00.000' AS DateTime), 49, 1, 241, 4, N'John McClane takes on an Internet-based terrorist organization who is systematically shutting down the United States.', 130, 5, 110000000, 383277179, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (54, N'Around the World in 80 Days', CAST(N'2004-07-09T00:00:00.000' AS DateTime), 50, 1, 241, 3, N'A bet pits a British inventor, a Chinese thief, and a French artist on a worldwide adventure that they can circle the globe in 80 days.', 120, 2, 110000000, 72004159, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (55, N'Kingdom of Heaven', CAST(N'2005-05-06T00:00:00.000' AS DateTime), 51, 1, 241, 4, N'Balian of Ibelin travels to Jerusalem during the crusades of the 12th century, and there he finds himself as the defender of the city and its people.', 145, 5, 110000000, 211398413, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (56, N'Mr. & Mrs. Smith', CAST(N'2005-06-10T00:00:00.000' AS DateTime), 52, 1, 241, 4, N'A bored married couple is surprised to learn that they are both assassins hired by competing agencies to kill each other.', 120, 5, 110000000, 468336279, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (57, N'The Aviator', CAST(N'2005-01-06T00:00:00.000' AS DateTime), 9, 1, 241, 6, N'A biopic depicting the early years of legendary director and aviator Howard Hughes'' career, from the late 1920s to the mid-1940s.', 170, 4, 110000000, 214608827, 11, 5, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (58, N'Ali', CAST(N'2002-02-22T00:00:00.000' AS DateTime), 34, 1, 241, 5, N'A biography of sports legend, Muhammad Ali, from his early days to his days in the ring', 157, 5, 109000000, 85300000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (59, N'The Lord of the Rings: The Fellowship of the Ring', CAST(N'2001-12-19T00:00:00.000' AS DateTime), 12, 1, 167, 14, N'In a small village in the Shire a young Hobbit named Frodo has been entrusted with an ancient Ring. Now he must embark on an Epic quest to the Cracks of Doom in order to destroy it.', 178, 2, 109000000, 868621686, 13, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (60, N'I, Robot', CAST(N'2004-08-06T00:00:00.000' AS DateTime), 53, 1, 241, 4, N'In the year 2035 a techno-phobic cop investigates a crime that may have been perpetrated by a robot, which leads to a larger threat to humanity.', 115, 4, 105000000, 348801023, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (61, N'Casino Royale', CAST(N'2006-11-16T00:00:00.000' AS DateTime), 54, 1, 240, 11, N'In his first mission, James Bond must stop Le Chiffre, a banker to the world''s terrorist organizations, from winning a high-stakes poker tournament at Casino Royale in Montenegro.', 144, 4, 102000000, 594165000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (62, N'Minority Report', CAST(N'2002-07-04T00:00:00.000' AS DateTime), 4, 1, 241, 8, N'In the future, criminals are caught before the crimes they commit, but one of the officers in the special unit is accused of one such crime and sets out to prove his innocence.', 145, 3, 102000000, 358814112, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (63, N'Terminator 2: Judgment Day', CAST(N'1991-08-16T00:00:00.000' AS DateTime), 15, 1, 241, 15, N'The cyborg who once tried to kill Sarah Connor must now protect her teenager son, John Connor, from an even more powerful and advanced cyborg.', 137, 5, 100000000, 516816151, 4, 6, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (64, N'Catwoman', CAST(N'2004-08-13T00:00:00.000' AS DateTime), 55, 1, 241, 6, N'A shy woman, endowed with the speed, reflexes, and senses of a cat, walks a thin line between criminal and hero, even as a detective doggedly pursues her, fascinated by both of her personas.', 104, 4, 100000000, 73887903, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (65, N'Harry Potter and the Chamber of Secrets', CAST(N'2002-11-15T00:00:00.000' AS DateTime), 41, 1, 240, 6, N'Harry ignores warnings not to return to Hogwarts, only to find the school plagued by a series of mysterious attacks and a strange voice haunting him.', 161, 2, 100000000, 878987880, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (66, N'American Gangster', CAST(N'2007-11-16T00:00:00.000' AS DateTime), 51, 1, 241, 1, N'In 1970s America, a detective works to bring down the drug empire of Frank Lucas, a heroin kingpin from Manhattan, who is smuggling the drug into the country from the Far East.', 157, 6, 100000000, 264132214, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (67, N'Blood Diamond', CAST(N'2007-01-26T00:00:00.000' AS DateTime), 43, 1, 241, 6, N'A fisherman, a smuggler, and a syndicate of businessmen match wits over the possession of a priceless diamond.', 143, 5, 100000000, 171377916, 5, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (68, N'Gladiator', CAST(N'2000-05-12T00:00:00.000' AS DateTime), 51, 1, 241, 8, N'When a Roman general is betrayed and his family murdered by a corrupt prince, he comes to Rome as a gladiator to seek revenge.', 155, 5, 103000000, 457683805, 12, 5, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (69, N'True Lies', CAST(N'1994-08-12T00:00:00.000' AS DateTime), 15, 1, 241, 4, N'When a secret agent learns of his wife''s extra-marital affair, he pursues her and uses his intelligence resources in a job he kept secret from her.', 141, 5, 100000000, 365300000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (70, N'Gangs of New York', CAST(N'2003-01-09T00:00:00.000' AS DateTime), 9, 1, 241, 16, N'In 1863, Amsterdam Vallon returns to the Five Points area of New York City seeking revenge against Bill the Butcher, his father''s killer.', 167, 6, 97000000, 190400000, 10, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (71, N'Black Hawk Down', CAST(N'2002-01-18T00:00:00.000' AS DateTime), 51, 1, 241, 17, N'123 elite U.S. soldiers drop into Somalia to capture two top lieutenants of a renegade warlord and find themselves in a desperate battle with a large force of heavily-armed Somalis.', 144, 5, 95000000, 173638745, 4, 2, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (72, N'The Fifth Element', CAST(N'1997-06-06T00:00:00.000' AS DateTime), 56, 1, 79, 18, N'In the colorful future, a cab driver unwittingly becomes the central figure in the search for a legendary cosmic weapon to keep Evil and Mr Zorg at bay.', 126, 2, 95000000, 263900000, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (73, N'The Lord of the Rings: The Return of the King', CAST(N'2003-12-17T00:00:00.000' AS DateTime), 12, 1, 167, 14, N'The former Fellowship of the Ring prepare for the final battle for Middle Earth, while Frodo & Sam approach Mount Doom to destroy the One Ring.', 201, 4, 94000000, 1133027325, 11, 11, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (74, N'The Lord of the Rings: The Two Towers', CAST(N'2002-12-18T00:00:00.000' AS DateTime), 12, 1, 167, 14, N'Frodo and Sam continue on to Mordor in their mission to destroy the One Ring. Whilst their former companions make new allies and launch an assault on Isengard.', 179, 4, 94000000, 926284377, 6, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (75, N'Rush Hour 3', CAST(N'2007-08-10T00:00:00.000' AS DateTime), 57, 1, 241, 14, N'After an attempted assassination on Ambassador Han, Lee and Carter head to Paris to protect a French woman with knowledge of the Triads'' secret leaders.', 91, 4, 180000000, 252980850, 0, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (76, N'Rush Hour 2', CAST(N'2001-08-03T00:00:00.000' AS DateTime), 57, 1, 241, 14, N'Carter and Lee head to Hong Kong for vacation, but become embroiled in a counterfeit money scam.', 90, 3, 90000000, 347425832, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (77, N'Men in Black', CAST(N'1997-08-01T00:00:00.000' AS DateTime), 31, 1, 241, 5, N'Two men who keep an eye on aliens in New York City must try to save the world after the aliens threaten to blow it up.', 98, 2, 90000000, 589390539, 3, 1, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (78, N'The Departed', CAST(N'2006-10-06T00:00:00.000' AS DateTime), 9, 1, 241, 6, N'Two men from opposite sides of the law are undercover within the Massachusetts State Police and the Irish mafia, but violence and bloodshed boil when discoveries are made, and the moles are dispatched to find out their enemy''s identities.', 151, 6, 90000000, 290539042, 5, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (79, N'Die Hard: With A Vengeance', CAST(N'1995-08-18T00:00:00.000' AS DateTime), 58, 1, 241, 4, N'John McClane and a store owner must play a bomber''s deadly game as they race around New York while trying to stop him.', 131, 5, 90000000, 365012499, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (80, N'Cinderella Man', CAST(N'2005-09-09T00:00:00.000' AS DateTime), 40, 1, 241, 1, N'The story of James Braddock, a supposedly washed up boxer who came back to become a champion and an inspiration in the 1930s.', 144, 4, 88000000, 108539911, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (81, N'The Bourne Supremacy', CAST(N'2004-08-13T00:00:00.000' AS DateTime), 37, 1, 241, 1, N'When Jason Bourne is framed for a botched CIA operation he is forced to take up his former life as a trained assassin to survive.', 108, 4, 85000000, 288587450, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (82, N'Last Action Hero', CAST(N'1993-07-30T00:00:00.000' AS DateTime), 58, 1, 241, 5, N'A young movie fan gets thrown into the movie world of his favourite action film character.', 130, 5, 85000000, 137298489, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (83, N'Cast Away', CAST(N'2001-01-12T00:00:00.000' AS DateTime), 20, 1, 241, 8, N'A FedEx executive must transform himself physically and emotionally to survive a crash landing on a deserted island.', 143, 3, 85000000, 427230516, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (84, N'Ocean''s Twelve', CAST(N'2005-02-04T00:00:00.000' AS DateTime), 48, 1, 241, 6, N'Daniel Ocean recruits one more team member so he can pull off three major European heists in this sequel to Ocean''s 11.', 125, 4, 85000000, 363531634, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (85, N'Click', CAST(N'2006-09-29T00:00:00.000' AS DateTime), 50, 1, 241, 5, N'A workaholic architect finds a universal remote that allows him to fast-forward and rewind to different parts of his life. Complications arise when the remote starts to overrule his choices.', 107, 4, 82500000, 237555633, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (86, N'Bruce Almighty', CAST(N'2003-06-27T00:00:00.000' AS DateTime), 16, 1, 241, 1, N'A guy who complains about God too often is given almighty powers to teach him how difficult it is to run the world.', 101, 4, 81000000, 485004995, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (87, N'Mission: Impossible', CAST(N'1996-07-05T00:00:00.000' AS DateTime), 59, 1, 241, 2, N'An American agent, under false suspicion of disloyalty, must discover and expose the real spy without the help of his organization.', 110, 2, 80000000, 456481886, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (88, N'Deep Impact', CAST(N'1998-05-15T00:00:00.000' AS DateTime), 60, 1, 241, 2, N'Unless a comet can be destroyed before colliding with Earth, only those allowed into shelters will survive. Which people will survive?', 120, 3, 80000000, 349464664, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (89, N'Road to Perdition', CAST(N'2002-09-27T00:00:00.000' AS DateTime), 61, 1, 241, 8, N'Bonds of loyalty are put to the test when a hitman''s son witnesses what his father does for a living.', 117, 5, 80000000, 181054514, 6, 1, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (90, N'A Beautiful Mind', CAST(N'2002-02-22T00:00:00.000' AS DateTime), 40, 1, 241, 1, N'After a brilliant but asocial mathematician accepts secret work in cryptography, his life takes a turn to the nightmarish.', 135, 3, 78000000, 316708996, 8, 4, 2, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (91, N'Children of Men', CAST(N'2006-09-22T00:00:00.000' AS DateTime), 38, 1, 241, 1, N'In 2027, in a chaotic world in which humans can no longer procreate, a former activist agrees to help transport a miraculously pregnant woman to a sanctuary at sea, where her child''s birth may help scientists save the future of humankind.', 109, 5, 76000000, 69450202, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (92, N'Munich', CAST(N'2006-01-27T00:00:00.000' AS DateTime), 4, 1, 241, 8, N'Based on the true story of the Black September aftermath, about the five men chosen to eliminate the ones responsible for that fateful day.', 164, 5, 75000000, 130279090, 5, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (93, N'Independence Day', CAST(N'1996-08-09T00:00:00.000' AS DateTime), 42, 1, 241, 4, N'The aliens are coming and their goal is to invade and destroy. Fighting superior technology, Man''s best weapon is the will to survive.', 145, 3, 75000000, 816969255, 2, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (94, N'X-Men', CAST(N'2000-08-18T00:00:00.000' AS DateTime), 14, 1, 241, 4, N'Two mutants come to a private academy for mutants whose resident superhero team must oppose a powerful mutant terrorist organization.', 104, 3, 75000000, 295999717, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (95, N'X2', CAST(N'2003-05-01T00:00:00.000' AS DateTime), 14, 1, 241, 4, N'The X-Men band together to find a mutant assassin who has made an attempt on the President''s life, while the Mutant Academy is attacked by military forces.', 133, 4, 125000000, 406400513, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (96, N'The Rock', CAST(N'1996-06-21T00:00:00.000' AS DateTime), 18, 1, 241, 17, N'A group of U.S. marines, under command of a renegade general, take over Alcatraz and threat San Francisco Bay with biological weapons. A chemical weapons specialist and the only man to have ever escaped from the Rock are the only ones who can prevent chaos.', 136, 5, 75000000, 336069511, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (97, N'Constantine', CAST(N'2005-03-18T00:00:00.000' AS DateTime), 23, 1, 241, 6, N'Based on the DC/Vertigo comic book Hellblazer and written by Kevin Brodbin, Mark Bomback and Frank Capello, Constantine tells the story of irreverent supernatural detective John Constantine (Keanu Reeves), who has literally been to hell and back.', 121, 5, 75000000, 229976178, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (98, N'Unbreakable', CAST(N'2000-12-29T00:00:00.000' AS DateTime), 62, 1, 241, 7, N'A suspense thriller with supernatural overtones that revolves around a man who learns something extraordinary about himself after a devastating accident.', 106, 3, 73243106, 248099143, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (99, N'Talladega Nights: The Ballad of Ricky Bobby', CAST(N'2006-09-15T00:00:00.000' AS DateTime), 63, 1, 241, 5, N'#1 NASCAR driver Ricky Bobby (Ferrell) stays atop the heap thanks to a pact with his best friend and teammate, Cal Naughton, Jr. (Reilly). But when a French Formula One driver (Cohen), makes his way up the ladder, Ricky Bobby''s talent and devotion are put to the test.', 108, 4, 73000000, 163213377, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (100, N'The Simpsons Movie', CAST(N'2007-07-25T00:00:00.000' AS DateTime), 64, 1, 241, 4, N'After Homer accidentally pollutes the town''s water supply, Springfield is encased in a gigantic dome by the EPA and the Simpsons family are declared fugitives.', 87, 2, 72500000, 526758418, 0, 0, 0, 0)
GO
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (101, N'Braveheart', CAST(N'1995-09-08T00:00:00.000' AS DateTime), 65, 1, 241, 2, N'William Wallace, a commoner, unites the 13th Century Scots in their battle to overthrow English rule.', 177, 5, 72000000, 209000000, 10, 5, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (102, N'Jarhead', CAST(N'2006-01-13T00:00:00.000' AS DateTime), 61, 1, 241, 1, N'Based on former Marine Anthony Swofford''s best-selling 2003 book about his pre-Desert Storm experiences in Saudi Arabia and about his experiences fighting in Kuwait.', 125, 5, 72000000, 96780312, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (103, N'The Village', CAST(N'2004-08-20T00:00:00.000' AS DateTime), 62, 1, 241, 7, N'The population of a small, isolated countryside village believe that their alliance with the mythical creatures that inhabit the forest around them is coming to an end.', 108, 4, 71682975, 260197520, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (104, N'Shrek the Third', CAST(N'2007-06-29T00:00:00.000' AS DateTime), 66, 1, 241, 8, N'When his new father-in-law, King Harold falls ill, Shrek is looked at as the heir to the land of Far, Far Away. Not one to give up his beloved swamp, Shrek recruits his friends Donkey and Puss in Boots to install the rebellious Artie as the new king. Princess Fiona, however, rallies a band of royal girlfriends to fend off a coup d''etat by the jilted Prince Charming.', 92, 1, 160000000, 798957081, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (105, N'Shrek 2', CAST(N'2004-07-02T00:00:00.000' AS DateTime), 67, 1, 241, 8, N'Princess Fiona''s parents invite her and Shrek to dinner to celebrate her marriage. If only they knew the newlyweds were both ogres.', 93, 1, 70000000, 915278586, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (106, N'The Abyss', CAST(N'1989-10-13T00:00:00.000' AS DateTime), 15, 1, 241, 4, N'A civilian diving team are enlisted to search for a lost nuclear submarine and face danger while encountering an alien aquatic species.', 138, 5, 70000000, 54243125, 4, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (107, N'Star Trek: Insurrection', CAST(N'1999-01-01T00:00:00.000' AS DateTime), 68, 1, 241, 2, N'When the crew of the Enterprise learn of a Federation plot against the inhabitants of a unique planet, Capt. Picard begins an open rebellion.', 103, 2, 70000000, 117800000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (108, N'Who Framed Roger Rabbit?', CAST(N'1988-12-02T00:00:00.000' AS DateTime), 20, 1, 241, 7, N'A toon hating detective is a cartoon rabbit''s only hope to prove his innocence when he is accused of murder.', 104, 2, 70000000, 351500000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (109, N'Sleepy Hollow', CAST(N'2000-01-07T00:00:00.000' AS DateTime), 28, 1, 241, 2, N'Ichabod Crane is sent to Sleepy Hollow to investigate the decapitations of 3 people with the culprit being the legendary apparition, the Headless Horseman.', 105, 5, 70000000, 207068340, 3, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (110, N'xXx', CAST(N'2002-10-17T00:00:00.000' AS DateTime), 32, 1, 241, 19, N'Xander Cage is an extreme sports athelete recruited by the government on a special mission.', 124, 5, 70000000, 267200000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (111, N'Die Hard 2', CAST(N'1990-08-17T00:00:00.000' AS DateTime), 69, 1, 241, 4, N'John McClane is forced to battle mercenaries who seize control of an airport''s communications and threaten to cause plane crashes if their demands are not met.', 124, 5, 70000000, 237523878, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (112, N'The Long Kiss Goodnight', CAST(N'1996-11-29T00:00:00.000' AS DateTime), 69, 1, 241, 14, N'A women suffering from amnesia begins to recover her memories after trouble from her past finds her again.', 120, 6, 65000000, NULL, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (113, N'Apollo 13', CAST(N'1995-09-22T00:00:00.000' AS DateTime), 40, 1, 241, 1, N'True story of the moon-bound mission that developed severe trouble and the men that rescued it with skill and dedication.', 140, 2, 65000000, 334100000, 9, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (114, N'Saving Private Ryan', CAST(N'1998-09-11T00:00:00.000' AS DateTime), 4, 1, 241, 8, N'Based on a World War II drama. US soldiers try to save their comrade, paratrooper Private Ryan, who''s stationed behind enemy lines.', 170, 5, 65000000, 481635085, 11, 5, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (115, N'Fight Club', CAST(N'1999-11-12T00:00:00.000' AS DateTime), 70, 1, 241, 4, N'An office employee and a soap salesman build a global organization to help vent male aggression.', 139, 6, 65000000, 100900000, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (116, N'The Matrix', CAST(N'1999-06-11T00:00:00.000' AS DateTime), 39, 1, 241, 6, N'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against the controllers of it.', 136, 5, 65000000, 456500000, 4, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (117, N'Total Recall', CAST(N'1990-07-27T00:00:00.000' AS DateTime), 72, 1, 241, 15, N'When a man goes for virtual vacation memories of the planet Mars, an unexpected and harrowing series of events forces him to go to the planet for real, or does he?', 113, 6, 65000000, 261400000, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (118, N'Cliffhanger', CAST(N'1993-06-25T00:00:00.000' AS DateTime), 69, 1, 241, 15, N'A botched mid-air heist results in suitcases full of cash being searched for by various groups throughout the Rocky Mountains.', 113, 5, 65000000, 255000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (119, N'Clear and Present Danger', CAST(N'1994-08-03T00:00:00.000' AS DateTime), 73, 1, 241, 2, N'CIA Analyst Jack Ryan is drawn into an illegal war fought by the US government against a Colombian drug cartel.', 141, 3, 62000000, 207500000, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (120, N'GoldenEye', CAST(N'1995-11-24T00:00:00.000' AS DateTime), 54, 1, 240, 11, N'James Bond teams up with the lone survivor of a destroyed Russian research center to stop the hijacking of a nuclear space weapon by a fellow agent believed to be dead.', 130, 3, 60000000, 356429941, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (121, N'The Black Dahlia', CAST(N'2006-09-15T00:00:00.000' AS DateTime), 59, 1, 241, 1, N'Two policemen see their personal and professional lives fall apart in the wake of the "Black Dahlia" murder investigation.', 121, 5, 60000000, 46672813, 1, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (122, N'The Truman Show', CAST(N'1998-10-09T00:00:00.000' AS DateTime), 36, 1, 241, 2, N'An insurance salesman/adjuster discovers his entire life is actually a TV show.', 103, 2, 60000000, 248400000, 3, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (123, N'Event Horizon', CAST(N'1997-08-22T00:00:00.000' AS DateTime), 74, 1, 241, 2, N'A rescue crew investigates a spaceship that disappeared into a black hole and has now returned...with someone or something new on-board.', 96, 6, 60000000, 26673242, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (124, N'The Bourne Identity', CAST(N'2002-09-06T00:00:00.000' AS DateTime), 52, 1, 241, 1, N'A man is picked up by a fishing boat, bullet-riddled and without memory, then races to elude assassins and recover from amnesia.', 119, 4, 60000000, 213300000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (125, N'Hellboy', CAST(N'2004-09-02T00:00:00.000' AS DateTime), 71, 1, 241, 19, N'A demon, raised from infancy after being conjured by and rescued from the Nazis, grows up to become a defender against the forces of darkness.', 122, 4, 60000000, 98703901, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (126, N'Starsky & Hutch', CAST(N'2004-03-19T00:00:00.000' AS DateTime), 75, 1, 241, 6, N'Two streetwise cops (Stiller and Wilson) bust criminals in their red-and-white Ford Torino with the help of police snitch called Huggy Bear (Snoop Dogg).', 101, 5, 60000000, 170200225, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (127, N'Intolerable Cruelty', CAST(N'2003-10-24T00:00:00.000' AS DateTime), 5, 1, 241, 20, N'A revenge-seeking gold digger marries a womanizing Beverly Hills lawyer with the intention of making a killing in the divorce.', 100, 4, 60000000, 121327628, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (128, N'300', CAST(N'2007-03-23T00:00:00.000' AS DateTime), 76, 1, 241, 6, N'King Leonidas and a force of 300 men fight the Persians at Thermopylae in 480 B.C.', 117, 5, 60000000, 456068181, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (129, N'Star Trek: Nemesis', CAST(N'2003-01-03T00:00:00.000' AS DateTime), 77, 1, 241, 2, N'After the Enterprise is diverted to the Romulan planet of Romulus, supposedly because they want to negotiate a truce, the Federation soon find out the Romulans are planning an attack on Earth.', 116, 4, 60000000, 67312826, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (130, N'Superman', CAST(N'1978-12-21T00:00:00.000' AS DateTime), 30, 1, 241, 6, N'An alien orphan is sent from his dying planet to Earth, where he grows up to become his adoptive home''s first and greatest super-hero.', 143, 2, 55000000, 300200000, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (131, N'Crimson Tide', CAST(N'1995-11-03T00:00:00.000' AS DateTime), 78, 1, 241, 17, N'On a US nuclear missile sub, a young first officer stages a mutiny to prevent his trigger happy captain from launching his missiles before confirming his orders to do so.', 116, 5, 55000000, 159387195, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (132, N'Deja Vu', CAST(N'2006-12-15T00:00:00.000' AS DateTime), 78, 1, 241, 7, N'An ATF agent travels back in time to save a woman from being murdered, falling in love with her during the process.', 126, 4, 80000000, 181038616, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (133, N'Man On Fire', CAST(N'2004-10-08T00:00:00.000' AS DateTime), 78, 1, 241, 4, N'In Mexico City, a former assassin swears vengeance on those who committed an unspeakable act against the family he was hired to protect.', 146, 6, 60000000, 118706816, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (134, N'Enemy of the State', CAST(N'1998-12-26T00:00:00.000' AS DateTime), 78, 1, 241, 7, N'A lawyer becomes a target by a corrupt politician and his NSA goons when he accidentally receives key evidence to a serious politically motivated crime.', 132, 5, 85000000, 250300000, 0, 0, 2, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (135, N'Kill Bill: Vol. 1', CAST(N'2003-10-17T00:00:00.000' AS DateTime), 79, 1, 241, 16, N'The Bride wakes up after a long coma. The baby that she carried before entering the coma is gone. The only thing on her mind is to have revenge on the assassination team that betrayed her - a team she was once part of.', 111, 6, 55000000, 180098138, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (136, N'Alien 3', CAST(N'1992-08-21T00:00:00.000' AS DateTime), 70, 1, 241, 4, N'Ripley continues to be stalked by a savage alien, after her escape pod crashes on a prison planet.', 114, 6, 55000000, 158500000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (137, N'Shanghai Noon', CAST(N'2000-08-25T00:00:00.000' AS DateTime), 80, 1, 241, 7, N'Jackie Chan plays a Chinese man who travels to the Wild West to rescue a kidnapped princess. After teaming up with a train robber, the unlikely duo takes on a Chinese traitor and his corrupt boss.', 110, 3, 55000000, 71189835, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (138, N'Kill Bill: Vol. 2', CAST(N'2004-04-23T00:00:00.000' AS DateTime), 79, 1, 241, 16, N'The murderous Bride continues her vengeance quest against her ex-boss, Bill, and his two remaining associates; his younger brother Budd, and Bill''s latest flame Elle.', 136, 6, 55000000, 150907920, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (139, N'Blade II', CAST(N'2002-03-29T00:00:00.000' AS DateTime), 71, 1, 241, 14, N'Blade forms an uneasy alliance with the vampire council in order to combat the Reaper vampires who feed on vampires.', 117, 6, 54000000, 154306865, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (140, N'Flags of our Fathers', CAST(N'2006-12-22T00:00:00.000' AS DateTime), 10, 1, 241, 8, N'The life stories of the six men who raised the flag at The Battle of Iwo Jima, a turning point in WWII.', 132, 5, 53000000, 61902376, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (141, N'Casino', CAST(N'1996-02-23T00:00:00.000' AS DateTime), 9, 1, 241, 1, N'Greed, deception, money, power, and murder occur between two mobster best friends and a trophy wife over a gambling empire.', 178, 6, 52000000, 110400000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (142, N'Robin Hood: Prince of Thieves', CAST(N'1991-07-19T00:00:00.000' AS DateTime), 17, 1, 241, 6, N'When Robin and his Moorish companion come to England and the tyranny of the Sheriff of Nottingham, he decides to fight back as an outlaw.', 143, 2, 50000000, 390500000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (143, N'Shrek', CAST(N'2001-06-29T00:00:00.000' AS DateTime), 67, 1, 241, 8, N'An ogre, in order to regain his swamp, travels along with an annoying donkey in order to bring a princess to a scheming lord, wishing himself King.', 90, 1, 50000000, 479467267, 2, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (144, N'Shanghai Knights', CAST(N'2003-04-04T00:00:00.000' AS DateTime), 81, 1, 241, 7, N'When a Chinese rebel murders Chon''s estranged father and escapes to England, Chon and Roy make their way to London with revenge on their minds.', 114, 4, 50000000, NULL, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (145, N'Indiana Jones and the Last Crusade', CAST(N'1989-06-30T00:00:00.000' AS DateTime), 4, 1, 241, 13, N'When Dr. Henry Jones Sr. suddenly goes missing while pursuing the Holy Grail, eminent archaeologist Indiana Jones must follow in his father''s footsteps and stop the Nazis.', 127, 2, 48000000, 474171806, 3, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (146, N'Star Trek: First Contact', CAST(N'1996-12-13T00:00:00.000' AS DateTime), 68, 1, 241, 2, N'Capt. Picard and his crew pursue the Borg back in time to stop them from preventing Earth from initiating first contact with alien life.', 111, 3, 46000000, 150000000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (147, N'Blade', CAST(N'1998-11-13T00:00:00.000' AS DateTime), 82, 1, 241, 14, N'A half-vampire, half-mortal man becomes a protector of the mortal race, while slaying evil vampires.', 120, 6, 45000000, 131237688, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (148, N'Patriot Games', CAST(N'1992-09-25T00:00:00.000' AS DateTime), 73, 1, 241, 2, N'When CIA Analyst Jack Ryan interferes with an IRA assassination, a renegade faction targets him and his family for revenge.', 117, 5, 45000000, 178100000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (149, N'The Fugitive', CAST(N'1993-09-24T00:00:00.000' AS DateTime), 83, 1, 241, 6, N'Dr. Richard Kimble, unjustly accused of killing his wife, must find the real one-armed killer while avoiding Marshal Sam Gerard.', 130, 3, 44000000, 368900000, 7, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (150, N'The Prestige', CAST(N'2006-11-10T00:00:00.000' AS DateTime), 27, 1, 241, 7, N'Robert and Alfred are rival magicians. When Alfred performs the ultimate magic trick, Robert tries desperately to find out the secret to the trick.', 130, 4, 40000000, 107896006, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (151, N'The Last of the Mohicans', CAST(N'1992-11-06T00:00:00.000' AS DateTime), 34, 1, 241, 21, N'Three trappers protect a British Colonel''s daughters in the midst of the French and Indian War.', 112, 3, 40000000, 75500000, 1, 1, 2, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (152, N'Apocalypto', CAST(N'2007-01-05T00:00:00.000' AS DateTime), 65, 8, 241, 7, N'As the Mayan kingdom faces its decline, the rulers insist the key to prosperity is to build more temples and offer human sacrifices. Jaguar Paw, a young man captured for sacrifice, flees to avoid his fate.', 139, 6, 40000000, 117784857, 3, 0, 2, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (153, N'Wedding Crashers', CAST(N'2005-07-14T00:00:00.000' AS DateTime), 81, 1, 241, 14, N'John Beckwith and Jeremy Grey, a pair of committed womanizers who sneak into weddings to take advantage of the romantic tinge in the air, find themselves at odds with one another when John meets and falls for Claire Cleary.', 119, 5, 40000000, 283218368, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (154, N'Back to the Future Part III', CAST(N'1990-07-11T00:00:00.000' AS DateTime), 20, 1, 241, 1, N'Doctor Emmet Brown was living in peace in 1885 until he was killed by Buford "Mad Dog" Tannen. Marty McFly travels back in time to save his friend.', 118, 2, 40000000, 243700000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (155, N'Back to the Future Part II', CAST(N'1989-11-24T00:00:00.000' AS DateTime), 20, 1, 241, 1, N'After visiting 2015, Marty must repeat his visit to 1955 to prevent disastrous changes to 1985... without interfering with his first trip.', 108, 2, 40000000, 332000000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (156, N'Licence to Kill', CAST(N'1989-07-14T00:00:00.000' AS DateTime), 84, 1, 240, 22, N'James Bond leaves Her Majesty''s Secret Service to stop an evil drug lord and avenge his best friend, Felix Leiter.', 133, NULL, 42000000, 156167015, 0, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (157, N'The Living Daylights', CAST(N'1987-06-30T00:00:00.000' AS DateTime), 84, 1, 240, 22, N'James Bond is living on the edge to stop an evil arms dealer from starting another world war. Bond crosses all seven continents in order to stop the evil Whitaker and General Koskov.', 130, NULL, 40000000, 191200000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (158, N'Sin City', CAST(N'2005-06-03T00:00:00.000' AS DateTime), 85, 1, 241, 23, N'A film that explores the dark and miserable town Basin City and tells the story of three different people, all caught up in the violent corruption of the city.', 124, NULL, 40000000, 159098862, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (159, N'Serenity', CAST(N'2005-10-07T00:00:00.000' AS DateTime), 86, 1, 241, 1, N'In the future, when a passenger with a deadly secret. Six rebels on the run. An assassin in pursuit.', 119, NULL, 39000000, 38514517, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (160, N'Star Trek: Generations', CAST(N'1994-11-18T00:00:00.000' AS DateTime), 87, 1, 241, 2, N'Capt. Picard, with the help of supposedly dead Capt. Kirk, must stop a madman willing to murder on a planetary scale in order to enter a space matrix.', 118, 2, 38000000, 120000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (161, N'Never Say Never Again', CAST(N'1983-12-15T00:00:00.000' AS DateTime), 88, 1, 241, 6, N'A SPECTRE agent has stolen two American nuclear warheads, and James Bond must find their targets before they are detonated.', 134, NULL, 36000000, 160000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (162, N'Star Trek: The Motion Picture', CAST(N'1979-12-20T00:00:00.000' AS DateTime), 89, 1, 241, 2, N'When a destructive space entity is spotted approaching Earth, Admiral Kirk resumes command of the Starship Enterprise in order to intercept, examine, and hopefully stop it.', 132, 1, 35000000, 139000000, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (163, N'Rush Hour', CAST(N'1998-12-04T00:00:00.000' AS DateTime), 57, 1, 241, 14, N'Two cops team up to get back a kidnapped daughter.', 97, NULL, 35000000, 245300000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (164, N'Lethal Weapon 3', CAST(N'1992-08-14T00:00:00.000' AS DateTime), 30, 1, 241, 6, N'Martin Riggs finally meets his match in the form of Lorna Cole, a beautiful but tough policewoman.', 118, NULL, 35000000, 319700000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (165, N'Star Wars: Episode VI - Return of the Jedi', CAST(N'1983-05-25T00:00:00.000' AS DateTime), 90, 1, 241, 13, N'After rescuing Han Solo from the palace of Jabba the Hutt, the Rebels attempt to destroy the Second Death Star, while Luke Skywalker tries to bring his father back to the Light Side of the Force.', 134, 1, 32500000, 572700000, 4, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (166, N'A History of Violence', CAST(N'2005-09-30T00:00:00.000' AS DateTime), 91, 1, 241, 14, N'A mild-mannered man becomes a local hero through an act of violence, which sets off repercussions that will shake his family to its very core.', 96, NULL, 32000000, 59993782, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (167, N'Moonraker', CAST(N'1979-06-29T00:00:00.000' AS DateTime), 92, 1, 240, 22, N'James Bond investigates the mid-air theft of a space shuttle and discovers a plot to commit global genocide.', 126, NULL, 31000000, 210300000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (168, N'Get Shorty', CAST(N'1996-03-15T00:00:00.000' AS DateTime), 31, 1, 241, 11, N'A mobster travels to Hollywood to collect a debt and discovers that the movie business is much the same as his current job.', 105, NULL, 30250000, 115021008, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (169, N'The Assassination of Jesse James by the Coward Robert Ford', CAST(N'2007-11-30T00:00:00.000' AS DateTime), 93, 1, 241, 6, N'Robert Ford, who''s idolized Jesse James since childhood, tries hard to join the reforming gang of the Missouri outlaw, but gradually becomes resentful of the bandit leader.', 160, NULL, 30000000, 11128555, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (170, N'Million Dollar Baby', CAST(N'2005-01-14T00:00:00.000' AS DateTime), 10, 1, 241, 6, N'A hardened trainer/manager works with a determined woman in her attempt to establish herself as a boxer.', 132, NULL, 30000000, 216763646, 7, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (171, N'Se7en', CAST(N'1996-01-05T00:00:00.000' AS DateTime), 70, 1, 241, 14, N'Police drama about two cops, one new and one about to retire, after a serial killer using the seven deadly sins as his MO.', 127, NULL, 30000000, 328125643, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (172, N'The Hunt For Red October', CAST(N'1990-04-20T00:00:00.000' AS DateTime), 58, 1, 241, 2, N'In 1984, the USSR''s best submarine captain in their newest sub violates orders and heads for the USA. Is he trying to defect, or to start a war?', 134, NULL, 30000000, 200500000, 3, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (173, N'Ghost Busters', CAST(N'1984-12-07T00:00:00.000' AS DateTime), 94, 1, 241, 5, N'Three unemployed parapsychology professors set up shop as a unique ghost removal service.', 105, NULL, 30000000, 291632124, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (174, N'Star Trek V: The Final Frontier', CAST(N'1989-10-20T00:00:00.000' AS DateTime), 95, 1, 241, 2, N'Capt. Kirk and his crew must deal with Mr. Spock''s half brother who hijacks the Enterprise for an obsessive search for God.', 107, NULL, 30000000, 70200000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (175, N'Indiana Jones and the Temple of Doom', CAST(N'1984-06-15T00:00:00.000' AS DateTime), 4, 1, 241, 13, N'After arriving in India, Indiana Jones is asked by a desperate village to find a mystical stone. He agrees, and stumbles upon a secret cult plotting a terrible plan in the catacombs of an ancient palace.', 118, NULL, 28000000, 333080271, 2, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (176, N'Blade Runner', CAST(N'1982-09-09T00:00:00.000' AS DateTime), 51, 1, 241, 6, N'Deckard, a blade runner, has to track down and terminate 4 replicants who hijacked a ship in space and have returned to earth seeking their maker.', 117, NULL, 28000000, 33139618, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (177, N'Die Hard', CAST(N'1989-02-03T00:00:00.000' AS DateTime), 58, 1, 241, 4, N'New York cop John McClane gives terrorists a dose of their own medicine as they hold hostages in an LA office building.', 131, NULL, 28000000, 137350242, 4, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (178, N'For Your Eyes Only', CAST(N'1981-06-26T00:00:00.000' AS DateTime), 84, 1, 240, 22, N'Agent 007 is assigned to hunt for a lost British encryption device and prevent it from falling into enemy hands.', 127, NULL, 28000000, 195300000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (179, N'Octopussy', CAST(N'1983-06-10T00:00:00.000' AS DateTime), 84, 1, 241, 11, N'A fake Fabergé egg and a fellow agent''s death leads James Bond to uncovering an international jewel smuggling operation, headed by the mysterious Octopussy, being used to disguise a nuclear attack on NATO forces.', 131, NULL, 27500000, 187500000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (180, N'Star Trek VI: The Undiscovered Country', CAST(N'1992-02-14T00:00:00.000' AS DateTime), 96, 1, 241, 2, N'The crews of the Enterprise and the Excelsior must stop a plot to prevent a peace treaty between the Klingon Empire and the Federation.', 113, 2, 27000000, 96900000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (181, N'The Running Man', CAST(N'1988-10-21T00:00:00.000' AS DateTime), 97, 1, 241, 24, N'A wrongly-convicted man must try to survive a public execution gauntlet staged as a TV game show.', 101, NULL, 27000000, 38122000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (182, N'Open Range', CAST(N'2004-03-19T00:00:00.000' AS DateTime), 98, 1, 241, 7, N'A former gunslinger is forced to take up arms again when he and his cattle crew are threatened by a corrupt lawman.', 139, NULL, 26000000, 68293719, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (183, N'Kindergarten Cop', CAST(N'1991-02-01T00:00:00.000' AS DateTime), 94, 1, 241, 1, N'A tough cop is given his most difficult assignment: masquerade as a a kindergarten teacher in order to find a drug dealer.', 111, NULL, 26000000, 202000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (184, N'O Brother, Where Art Thou?', CAST(N'2000-09-15T00:00:00.000' AS DateTime), 5, 1, 241, 7, N'Homer''s epic poem "The Odyssey", set in the deep south during the 1930''s. In it, three escaped convicts search for hidden treasure while a relentless lawman pursues them.', 107, NULL, 26000000, 74506619, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (185, N'Goodfellas', CAST(N'1990-09-19T00:00:00.000' AS DateTime), 9, 1, 241, 6, N'Henry Hill and his friends work their way up through the mob hierarchy.', 145, NULL, 25000000, 46743809, 6, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (186, N'The Passion of the Christ', CAST(N'2004-03-26T00:00:00.000' AS DateTime), 65, 7, 241, 25, N'A film detailing the final hours and crucifixion of Jesus Christ.', 127, NULL, 25000000, 611899420, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (187, N'The Untouchables', CAST(N'1987-09-18T00:00:00.000' AS DateTime), 59, 1, 241, 2, N'Federal Agent Elliot Ness sets out to take out Al Capone; because of rampant corruption, he assembles a small, hand-picked team.', 119, NULL, 25000000, 76270454, 4, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (188, N'Schindler''s List', CAST(N'1994-02-18T00:00:00.000' AS DateTime), 4, 1, 241, 1, N'Oskar Schindler uses Jews to start a factory in Poland during the war. He witnesses the horrors endured by the Jews, and starts to save them.', 195, NULL, 25000000, 321200000, 12, 7, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (189, N'Anchorman: The Legend of Ron Burgundy', CAST(N'2004-09-10T00:00:00.000' AS DateTime), 63, 1, 241, 8, N'Ron Burgundy is San Diego''s top rated newsman in the male dominated broadcasting of the 1970''s, but that''s all about to change when a new female employee with ambition to burn arrives in his office.', 94, NULL, 25000000, 89366354, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (190, N'Scarface', CAST(N'1983-12-09T00:00:00.000' AS DateTime), 59, 1, 241, 1, N'In 1980 Miami, a determined Cuban immigrant takes over a drug empire while succumbing to greed.', 170, NULL, 25000000, 44942821, 0, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (191, N'Star Trek IV: The Voyage Home', CAST(N'1987-04-10T00:00:00.000' AS DateTime), 99, 1, 241, 2, N'To save Earth from an alien probe, Kirk and his crew go back in time to retrieve the only beings who can communicate with it, humpback whales.', 119, 2, 24000000, 133000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (192, N'King Kong', CAST(N'1976-12-17T00:00:00.000' AS DateTime), 100, 1, 241, 2, N'A petroleum exploration expedition comes to an isolated island and encounters a colossal giant gorilla.', 134, NULL, 23000000, 80014445, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (193, N'Star Wars: Episode V - The Empire Strikes Back', CAST(N'1980-05-21T00:00:00.000' AS DateTime), 88, 1, 241, 13, N'While Luke takes advanced Jedi training from Yoda, his friends are relentlessly pursued by Darth Vader as part of his plan to capture Luke.', 124, NULL, 23000000, 534200000, 3, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (194, N'Gandhi', CAST(N'1982-12-08T00:00:00.000' AS DateTime), 101, 1, 240, 26, N'Biography of Mahatma Gandhi, the lawyer who became the famed leader of the Indian revolts against the British through his philosophy of non-violent protest.', 188, NULL, 22000000, 52767889, 11, 8, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (195, N'Equilibrium', CAST(N'2003-03-14T00:00:00.000' AS DateTime), 102, 1, 241, 23, N'In a Fascist future where all forms of feeling are illegal, a man in charge of enforcing the law rises to overthrow the system.', 107, NULL, 20000000, 5345869, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (196, N'From Dusk Till Dawn', CAST(N'1996-05-31T00:00:00.000' AS DateTime), 103, 1, 241, 23, N'Two criminals and their hostages unknowingly seek temporary refuge in an establishment populated by vampires, with chaotic results.', 108, NULL, 20000000, 25728961, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (197, N'Raiders of the Lost Ark', CAST(N'1981-07-30T00:00:00.000' AS DateTime), 4, 1, 241, 13, N'Archeologist and adventurer Indiana Jones is hired by the US government to find the Ark of the Covenant, before the Nazis.', 115, NULL, 20000000, 386800358, 8, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (199, N'Back to the Future', CAST(N'1985-12-04T00:00:00.000' AS DateTime), 20, 1, 241, 1, N'In 1985, Doc Brown invented time travel, in 1955, Marty McFly accidentally prevented his parents from meeting, putting his own existence at stake.', 117, NULL, 19000000, 381109762, 4, 1, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (200, N'Dances With Wolves', CAST(N'1991-02-08T00:00:00.000' AS DateTime), 98, 1, 241, 27, N'Lt. John Dunbar, exiled to a remote western Civil War outpost, befriends wolves and Indians, making him an intolerable aberration in the military.', 180, NULL, 19000000, 424200000, 12, 7, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (201, N'Star Trek III: The Search For Spock', CAST(N'1984-07-27T00:00:00.000' AS DateTime), 99, 1, 241, 2, N'Admiral Kirk and his bridge crew risk their careers stealing the decommissioned Enterprise to return to the restricted Genesis planet to recover Spock''s body.', 105, 2, 18000000, 87000000, 0, 0, 0, 0)
GO
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (202, N'Borat: Cultural Learnings of America for Make Benefit Glorious Nation of Kazakhstan', CAST(N'2006-11-02T00:00:00.000' AS DateTime), 104, 1, 241, 28, N'Kazakh TV talking head Borat is dispatched to the United States to report on the greatest country in the world. With a documentary crew in tow, Borat becomes more interested in locating and marrying Pamela Anderson.', 84, NULL, 18000000, 261509089, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (203, N'Raging Bull', CAST(N'1981-04-10T00:00:00.000' AS DateTime), 9, 1, 241, 22, N'An emotionally self-destructive boxer''s journey through life, as the violence and temper that leads him to the top in the ring, destroys his life outside it.', 129, NULL, 18000000, 23380203, 8, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (204, N'Aliens', CAST(N'1986-08-29T00:00:00.000' AS DateTime), 15, 1, 241, 4, N'The planet from Alien (1979) has been colonized, but contact is lost. This time, the rescue team has impressive firepower, enough?', 137, NULL, 17000000, 183316455, 7, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (205, N'Hero', CAST(N'2004-09-24T00:00:00.000' AS DateTime), 105, 5, 48, 29, N'A series of Rashomon-like flashback accounts shape the story of how one man defeated three assassins who sought to murder the most powerful warlord in pre-unified China.', 99, NULL, 17000000, 177352140, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (206, N'Hot Fuzz', CAST(N'2007-02-14T00:00:00.000' AS DateTime), 106, 1, 240, 30, N'Jealous colleagues conspire to get a top London cop transferred to a small town and paired with a witless new partner. On the beat, the pair stumble upon a series of suspicious accidents and events.', 121, NULL, 16000000, 79192988, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (207, N'Léon', CAST(N'1995-02-03T00:00:00.000' AS DateTime), 56, 1, 79, 18, N'Professional assassin Leon reluctantly takes care of 12-year-old Mathilda, a neighbor whose parents are killed, and teaches her his trade.', 110, NULL, 16000000, 45284974, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (208, N'High Plains Drifter', CAST(N'1973-08-22T00:00:00.000' AS DateTime), 10, 1, 241, 31, N'A gunfighting stranger comes to the small settlement of Lago and is hired to bring the townsfolk together in an attempt to hold off three outlaws who are on their way.', 105, NULL, 15700000, 15700000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (209, N'Collateral', CAST(N'2004-09-17T00:00:00.000' AS DateTime), 34, 1, 241, 2, N'A cab driver finds himself the hostage of an engaging contract killer as he makes his rounds from hit to hit during one night in LA. He must find a way to save both himself and one last victim.', 120, NULL, 60000000, 217670152, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (210, N'American Beauty', CAST(N'2000-02-04T00:00:00.000' AS DateTime), 61, 1, 241, 8, N'Lester Burnham, a depressed suburban father in a mid-life crisis, decides to turn his hectic life around after developing an infatuation for his daughter''s attractive friend.', 122, NULL, 15000000, 356258047, 8, 5, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (211, N'Lethal Weapon', CAST(N'1987-08-28T00:00:00.000' AS DateTime), 30, 1, 241, 6, N'A veteran cop, Murtough, is partnered with a young homicidal cop, Riggs. Both having one thing in common, hating working in pairs. Now they must learn to work with one and other to stop a gang of drug smugglers.', 110, NULL, 15000000, 120192350, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (212, N'Lethal Weapon 2', CAST(N'1989-09-15T00:00:00.000' AS DateTime), 30, 1, 241, 6, N'Riggs and Murtaugh are on the trail of South African diplomats who are using their immunity to engage in criminal activities.', 114, NULL, 25000000, 140292000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (213, N'Crouching Tiger, Hidden Dragon', CAST(N'2001-01-05T00:00:00.000' AS DateTime), 8, 5, 48, 5, N'Two warriors in pursuit of a stolen sword and a notorious fugitive are led to an impetuous, physically-skilled, teenage nobleman''s daughter, who is at a crossroads in her life.', 120, NULL, 15000000, 213200000, 10, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (214, N'Brokeback Mountain', CAST(N'2006-01-13T00:00:00.000' AS DateTime), 8, 1, 241, 2, N'Based on the ''E. Annie Proulx'' story about a forbidden and secretive relationship between two cowboys and their lives over the years.', 134, NULL, 13900000, 180343761, 8, 3, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (215, N'Hulk', CAST(N'2003-07-18T00:00:00.000' AS DateTime), 8, 1, 241, 1, N'A geneticist''s experimental accident curses him with the tendency to become a powerful giant green brute under emotional stress.', 138, NULL, 137000000, 245160047, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (216, N'Sense and Sensibility', CAST(N'1996-02-23T00:00:00.000' AS DateTime), 8, 1, 240, 5, N'Rich Mr. Dashwood dies, leaving his second wife and her daughters poor by the rules of inheritance. Two daughters are the titular opposites.', 136, NULL, 16500000, 134993774, 7, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (217, N'Ride with the Devil', CAST(N'1999-11-05T00:00:00.000' AS DateTime), 8, 1, 241, 1, N'Jake Roedel and Jack Bull Chiles are friends in Missouri when the Civil War starts.', 138, NULL, 35000000, 630779, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (218, N'Twins', CAST(N'1989-03-17T00:00:00.000' AS DateTime), 94, 1, 241, 1, N'A physically perfect, but innocent, man goes in search of his twin brother, who is a short small-time crook.', 105, NULL, 15000000, 216600000, 0, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (219, N'28 Days Later…', CAST(N'2002-11-01T00:00:00.000' AS DateTime), 108, 1, 240, 32, N'Four weeks after a mysterious, incurable virus spreads throughout the UK, a handful of survivors try to find sanctuary.', 113, 1, 15000000, 82719885, 0, 0, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (220, N'The Beach', CAST(N'2000-02-11T00:00:00.000' AS DateTime), 108, 1, 240, 4, N'Twenty-something Richard travels to Thailand and finds himself in possession of a strange map. Rumours state that it leads to a solitary beach paradise, a tropical bliss - excited and intrigued, he sets out to find it.', 119, NULL, 50000000, 39778599, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (221, N'Trainspotting', CAST(N'1996-02-23T00:00:00.000' AS DateTime), 108, 1, 240, 33, N'Renton, deeply immersed in the Edinburgh drug scene, tries to clean up and get out, despite the allure of the drugs and influence of friends.', 94, NULL, 3100000, 24000785, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (222, N'The Spy Who Loved Me', CAST(N'1977-08-03T00:00:00.000' AS DateTime), 92, 1, 240, 22, N'James Bond investigates the hijacking of British and Russian submarines carrying nuclear warheads with the help of a KGB agent whose lover he killed.', 125, NULL, 14000000, 185400000, 3, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (223, N'Downfall', CAST(N'2005-04-01T00:00:00.000' AS DateTime), 109, 4, 257, 34, N'Traudl Junge (Lara), the final secretary for Adolf Hitler (Ganz), tells of the Nazi dictator''s final days in his Berlin bunker at the end of WWII.', 156, NULL, 13500000, 93501940, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (224, N'Letters from Iwo Jima', CAST(N'2007-02-23T00:00:00.000' AS DateTime), 10, 6, 241, 8, N'The story of the battle of Iwo Jima between the United States and Imperial Japan during World War II, as told from the perspective of the Japanese who fought it.', 141, NULL, 13000000, 68356082, 4, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (225, N'Star Trek II: The Wrath of Khan', CAST(N'1982-07-16T00:00:00.000' AS DateTime), 96, 1, 241, 2, N'Admiral Kirk''s midlife crisis is interrupted by the return of an old enemy looking for revenge and a potentially destructive device.', 113, 3, 12000000, 96800000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (226, N'House of Flying Daggers', CAST(N'2005-01-14T00:00:00.000' AS DateTime), 105, 5, 48, 29, N'A romantic warrior breaks a beautiful member of a rebel army out of prison to help her rejoin her fellows, but things are not what they seem.', 119, NULL, 12000000, 93041228, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (227, N'Das Boot', CAST(N'1982-02-10T00:00:00.000' AS DateTime), 25, 4, 257, 41, N'The claustrophobic world of a WWII German U-boat; boredom, filth, and sheer terror.', 149, NULL, 12000000, 84970337, 6, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (228, N'Casino Royale', CAST(N'1967-04-28T00:00:00.000' AS DateTime), 110, 1, 240, 5, N'In an early spy spoof, aging Sir James Bond (David Niven) comes out of retirement to take on SMERSH.', 131, NULL, 12000000, 41744718, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (229, N'Star Wars: Episode IV - A New Hope', CAST(N'1977-12-27T00:00:00.000' AS DateTime), 7, 1, 241, 13, N'Luke Skywalker leaves his home planet, teams up with other rebels, and tries to save Princess Leia from the evil clutches of Darth Vader.', 121, NULL, 11000000, 797900000, 10, 6, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (230, N'E.T.: The Extra-Terrestrial', CAST(N'1982-12-09T00:00:00.000' AS DateTime), 4, 1, 241, 1, N'A group of Earth children help a stranded alien botanist return home.', 115, NULL, 10500000, 792910554, 9, 4, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (231, N'Amélie', CAST(N'2001-10-05T00:00:00.000' AS DateTime), 111, 3, 79, 16, N'Amelie, an innocent and naive girl in Paris, with her own sense of justice, decides to help those around her and along the way, discovers love.', 122, NULL, 10350000, 152637129, 5, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (232, N'You Only Live Twice', CAST(N'1967-06-13T00:00:00.000' AS DateTime), 92, 1, 241, 22, N'Agent 007 and the Japanese secret service ninja force must find and stop the true culprit of a series of spacejackings before nuclear war is provoked.', 117, NULL, 9500000, 111600000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (233, N'Thunderball', CAST(N'1965-12-29T00:00:00.000' AS DateTime), 112, 1, 240, 22, N'James Bond heads to The Bahamas to recover two nuclear warheads stolen by SPECTRE agent Emilio Largo in an international extortion scheme.', 130, NULL, 9000000, 141200000, 1, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (234, N'Alien', CAST(N'1979-09-06T00:00:00.000' AS DateTime), 51, 1, 241, 4, N'A mining ship, investigating a suspected SOS, lands on a distant planet. The crew discovers some strange creatures and investigates.', 117, NULL, 9000000, 203630630, 2, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (236, N'On Her Majesty''s Secret Service', CAST(N'1969-12-18T00:00:00.000' AS DateTime), 113, 1, 240, 22, N'James Bond woos a mob boss''s daughter and goes undercover to uncover the true reason for Blofeld''s allergy research in the Swiss Alps that involves beautiful women from around the world.', 140, NULL, 8000000, 82000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (237, N'Pulp Fiction', CAST(N'1994-10-21T00:00:00.000' AS DateTime), 79, 1, 241, 16, N'The lives of two mob hit men, a boxer, a gangster''s wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', 154, NULL, 8000000, 212900000, 7, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (238, N'Rumble in the Bronx', CAST(N'1997-07-04T00:00:00.000' AS DateTime), 114, 2, 48, 14, N'A young man visiting and helping his uncle in New York City finds himself forced to fight a street gang and the mob with his martial art skills.', 104, NULL, 7500000, 36238752, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (239, N'Diamonds are Forever', CAST(N'1971-12-30T00:00:00.000' AS DateTime), 115, 1, 240, 22, N'A diamond smuggling investigation leads James Bond to Las Vegas, where he uncovers an extortion plot headed by his nemesis, Ernst Stavro Blofeld.', 120, NULL, 7200000, 116000000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (240, N'Fargo', CAST(N'1996-05-31T00:00:00.000' AS DateTime), 5, 1, 241, 4, N'Jerry Lundegaard''s inept crime falls apart due to his and his henchmen''s bungling and the persistent police work of pregnant Marge Gunderson.', 98, NULL, 7000000, 51567751, 7, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (241, N'Live and Let Die', CAST(N'1973-07-06T00:00:00.000' AS DateTime), 115, 1, 240, 22, N'007 is sent to stop a diabolically brilliant heroin magnate armed with a complex organization and a reliable psychic tarot card reader.', 121, NULL, 7000000, 161800000, 1, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (242, N'The Man with the Golden Gun', CAST(N'1974-12-20T00:00:00.000' AS DateTime), 115, 1, 240, 22, N'Bond is led to believe that he is targeted by the world''s most expensive assassin and must hunt him down to stop him.', 125, NULL, 7000000, 97600000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (243, N'Good Night, and Good Luck', CAST(N'2006-02-17T00:00:00.000' AS DateTime), 116, 1, 241, 6, N'Broadcast journalist Edward R. Murrow looks to bring down Senator Joseph McCarthy.', 93, NULL, 7000000, 54601218, 6, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (244, N'Pale Rider', CAST(N'1985-06-28T00:00:00.000' AS DateTime), 10, 1, 241, 31, N'A mysterious preacher protects a humble prospector village from a greedy mining company trying to encroach on their land.', 116, NULL, 6900000, 41410568, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (245, N'The Terminator', CAST(N'1985-01-11T00:00:00.000' AS DateTime), 15, 1, 241, 11, N'A human-looking, apparently unstoppable cyborg is sent from the future to kill Sarah Connor; Kyle Reese is sent to stop it.', 108, NULL, 6400000, 78019031, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (246, N'Around the World in 80 Days', CAST(N'1956-10-17T00:00:00.000' AS DateTime), 117, 1, 241, 22, N'Adaptation of Jules Verne''s novel about a Victorian Englishman who bets that with the new steamships and railways he can do what the title says.', 167, NULL, NULL, NULL, 8, 5, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (249, N'The Usual Suspects', CAST(N'1995-08-25T00:00:00.000' AS DateTime), 14, 1, 241, 11, N'A boat has been destroyed, criminals are dead, and the key to this mystery lies with the only survivor and his twisted, convoluted story beginning with five career crooks in a seemingly random police lineup.', 106, NULL, 6000000, 23341568, 2, 2, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (250, N'Memento', CAST(N'2000-10-20T00:00:00.000' AS DateTime), 27, 1, 241, 5, N'A man, suffering from short-term memory loss, uses notes and tattoos to hunt for the man he thinks killed his wife.', 113, NULL, 5000000, 39665950, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (251, N'Shaun of the Dead', CAST(N'2004-04-09T00:00:00.000' AS DateTime), 106, 1, 240, 33, N'A man decides to turn his moribund life around by winning back his ex-girlfriend, reconciling his relationship with his mother, and dealing with an entire community that has returned from the dead to eat the living.', 99, NULL, 5000000, 30039392, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (252, N'Four Weddings and a Funeral', CAST(N'1994-05-13T00:00:00.000' AS DateTime), 26, 1, 240, 33, N'Comedy-drama about a group of British friends... the title says the rest.', 117, NULL, 4500000, 257700832, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (253, N'Night Watch', CAST(N'2005-10-07T00:00:00.000' AS DateTime), 119, 9, 258, 4, N'A fantasy-thriller set in present-day Moscow where the respective forces that control daytime and nighttime do battle.', 114, NULL, 4200000, 33923550, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (254, N'Goldfinger', CAST(N'1965-01-09T00:00:00.000' AS DateTime), 115, 1, 241, 22, N'Investigating a gold magnate''s gold smuggling, James Bond uncovers a plot to contaminate the Fort Knox gold reserve.', 110, NULL, 3000000, 124900000, 1, 1, 0, 1)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (255, N'The Lives of Others', CAST(N'2007-04-13T00:00:00.000' AS DateTime), 120, 4, 257, 36, N'In 1984 East Berlin, an agent of the secret police, conducting surveillance on a writer and his lover, finds himself becoming increasingly absorbed by their lives.', 137, NULL, 2000000, 70053813, 1, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (256, N'From Russia with Love', CAST(N'1964-05-27T00:00:00.000' AS DateTime), 112, 1, 240, 22, N'James Bond willingly falls into an assassination ploy involving a naive Russian beauty in order to retrieve a Soviet encryption device that was stolen by SPECTRE.', 110, NULL, 2000000, 78900000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (257, N'Reservoir Dogs', CAST(N'1993-01-15T00:00:00.000' AS DateTime), 79, 1, 241, 16, N'After a simple jewelery heist goes terribly wrong, the surviving criminals begin to suspect that one of them is a police informant.', 99, NULL, 1200000, 2832029, 0, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (258, N'Dr. No', CAST(N'1963-05-08T00:00:00.000' AS DateTime), 112, 1, 240, 22, N'James Bond''s investigation of a missing colleague in Jamaica leads him to the island of the mysterious Dr. No and a scheme to end the US space program.', 110, NULL, 1000000, 59567035, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (259, N'King Kong', CAST(N'1933-04-07T00:00:00.000' AS DateTime), 121, 1, 241, 37, N'A film crew goes to a tropical island for an exotic location shoot and discovers a colossal giant gorilla who takes a shine to their female blonde star.', 100, NULL, 670000, 10000000, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (260, N'Seven Samurai', CAST(N'1956-11-19T00:00:00.000' AS DateTime), 122, 6, 118, 38, N'A poor village under attack by bandits recruits seven unemployed samurai to help them defend themselves.', 190, NULL, 500000, 271736, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (261, N'Super Size Me', CAST(N'2004-09-10T00:00:00.000' AS DateTime), 123, 1, 241, 39, N'An irreverent look at obesity in America and one of its sources - fast food corporations.', 100, NULL, 65000, 29529368, 1, 0, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (262, N'Kagemusha', CAST(N'1980-10-06T00:00:00.000' AS DateTime), 122, 6, 118, 38, N'When a powerful warlord in medieval Japan dies, a poor thief recruited to impersonate him finds difficulty', 179, NULL, NULL, NULL, 2, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (263, N'Ran', CAST(N'1985-06-01T00:00:00.000' AS DateTime), 122, 6, 118, 38, N'An elderly lord abdicates to his three sons, and the two corrupt ones turn against him.', 160, NULL, 12000000, NULL, 4, 1, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (264, N'Sunshine', CAST(N'2007-04-05T00:00:00.000' AS DateTime), 108, 1, 240, 4, N'A team of astronauts are sent to re-ignite the dying sun 50 years into the future.', 107, 5, 40000000, 31959646, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (265, N'Once Were Warriors', CAST(N'1995-04-14T00:00:00.000' AS DateTime), 29, 1, 167, 40, N'A family descended from Maori warriors is bedeviled by a violent father and the societal problems of being treated as outcasts.', 99, 6, 1000000, NULL, 0, 0, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (269, N'Life of PI', CAST(N'2012-11-21T00:00:00.000' AS DateTime), 8, 1, 241, 4, N'A young man who survives a disaster at sea is hurtled into an epic journey of adventure and discovery. While cast away, he forms an unexpected connection with another survivor: a fearsome Bengal tiger.', 127, NULL, 120000000, 609000000, 11, 4, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (272, N'Bridge of Spies', CAST(N'2015-11-26T00:00:00.000' AS DateTime), 4, 1, 241, 4, N'During the Cold War, an American lawyer is recruited to defend an arrested Soviet spy in court, and then help the CIA facilitate an exchange of the spy for the Soviet captured American U2 spy plane pilot, Francis Gary Powers.', 144, 2, 40000000, 165500000, 0, 0, 2, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (273, N'Forrest Gump', CAST(N'1994-07-06T00:00:00.000' AS DateTime), 20, 1, 241, 2, N'The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate, and other history unfold through the perspective of an Alabama man with an IQ of 75.', 144, 2, 55000000, 678200000, 13, 6, 1, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (281, N'Dunkirk', CAST(N'2017-07-19T00:00:00.000' AS DateTime), 27, 1, 240, 6, N'Allied soldiers from Belgium, the British Empire, and France are surrounded by the German Army, and evacuated during a fierce battle in World War II.', 106, 1, 100000000, 527300000, 8, 3, 0, 0)
INSERT [dbo].[tblFilm] ([FilmID], [FilmName], [FilmReleaseDate], [FilmDirectorID], [FilmLanguageID], [FilmCountryID], [FilmStudioID], [FilmSynopsis], [FilmRunTimeMinutes], [FilmCertificateID], [FilmBudgetDollars], [FilmBoxOfficeDollars], [FilmOscarNominations], [FilmOscarWins], [FilmLikes], [FilmDislikes]) VALUES (282, N'The Dark Knight', CAST(N'2008-07-24T00:00:00.000' AS DateTime), 27, 1, 241, 6, N'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.', 152, NULL, 185000000, 1005000000, 6, 2, 1, 0)
SET IDENTITY_INSERT [dbo].[tblFilm] OFF
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (1, N'Action')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (2, N'Adventure')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (3, N'Animation')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (4, N'Biography')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (5, N'Comedy')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (6, N'Crime')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (7, N'Documentary')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (8, N'Drama')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (9, N'Family')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (10, N'Fantasy')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (11, N'Film Noir')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (12, N'History')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (13, N'Horror')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (14, N'Music')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (15, N'Musical')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (16, N'Mystery')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (17, N'Romance')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (18, N'Sci-Fi')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (19, N'Short Film')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (20, N'Sport')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (21, N'Superhero')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (22, N'Thriller')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (23, N'War')
INSERT [dbo].[tblGenre] ([GenreId], [GenreName]) VALUES (24, N'Western')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (1, N'English')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (2, N'Cantonese')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (3, N'French')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (4, N'German')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (5, N'Mandarin')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (6, N'Japanese')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (7, N'Aramaic')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (8, N'Mayan')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (9, N'Russian')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (10, N'Spanish')
INSERT [dbo].[tblLanguage] ([LanguageID], [Language]) VALUES (11, N'Owl Hoot')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (1, N'Universal Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (2, N'Paramount Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (3, N'Walt Disney Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (4, N'20th Century Fox')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (5, N'Columbia Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (6, N'Warner Bros. Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (7, N'Touchstone Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (8, N'Dreamworks')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (9, N'ImageMovers')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (10, N'Disney Pixar')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (11, N'MGM')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (12, N'Chris Lee Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (13, N'Lucasfilm')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (14, N'New Line Cinema')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (15, N'Carolco Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (16, N'Miramax Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (17, N'Jerry Bruckheimer Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (18, N'Gaumont')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (19, N'Revolution Studios')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (20, N'Imagine Entertainment')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (21, N'Morgan Creek Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (22, N'United Artists')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (23, N'Dimension Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (24, N'Braveworld Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (25, N'Icon Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (26, N'Carolina Bank')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (27, N'Tig Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (28, N'Dune Entertainment')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (29, N'Beijing New Picture Film Co.')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (30, N'Big Talk Productions')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (31, N'Malpaso Company')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (32, N'British Film Council')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (33, N'Channel Four Films')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (34, N'Constantin Film')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (35, N'Bavaria Film')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (36, N'Bayerischer Rundfunk')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (37, N'RKO Radio Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (38, N'Toho Company')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (39, N'Kathbur Pictures')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (40, N'Avalon Studios')
INSERT [dbo].[tblStudio] ([StudioID], [StudioName]) VALUES (41, N'Bavaria Film')
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 62)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 70)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 76)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 91)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 92)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 94)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 95)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 137)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 141)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 144)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 163)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 168)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 187)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 188)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 190)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 213)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 227)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 240)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'4c0737c0-2268-4c95-a1f2-c44eb7310915', 262)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', 183)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', 187)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', 190)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', 240)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', 249)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'bcedb949-422d-4779-b199-ec26c125e28f', 255)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 66)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 101)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 142)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 210)
INSERT [dbo].[WatchList] ([UserID], [FilmID]) VALUES (N'c5a9bd0a-48e6-462a-bb31-98efe7563ef5', 222)
ALTER TABLE [dbo].[FilmLikesAndDislikes] ADD  CONSTRAINT [DF_FilmLikesAndDislikes_IsLiked]  DEFAULT ((0)) FOR [IsLiked]
GO
ALTER TABLE [dbo].[FilmLikesAndDislikes] ADD  CONSTRAINT [DF_FilmLikesAndDislikes_IsDisliked]  DEFAULT ((0)) FOR [IsDisliked]
GO
ALTER TABLE [dbo].[tblFilm] ADD  CONSTRAINT [DF_tblFilm_FilmLikes]  DEFAULT ((0)) FOR [FilmLikes]
GO
ALTER TABLE [dbo].[tblFilm] ADD  CONSTRAINT [DF_tblFilm_FilmDislikes]  DEFAULT ((0)) FOR [FilmDislikes]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_AspNetUsers] FOREIGN KEY([CommentUserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_AspNetUsers]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_tblFilm] FOREIGN KEY([CommentFilmID])
REFERENCES [dbo].[tblFilm] ([FilmID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_tblFilm]
GO
ALTER TABLE [dbo].[FilmGenres]  WITH CHECK ADD  CONSTRAINT [FK_FilmGenres_tblFilm] FOREIGN KEY([FilmId])
REFERENCES [dbo].[tblFilm] ([FilmID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FilmGenres] CHECK CONSTRAINT [FK_FilmGenres_tblFilm]
GO
ALTER TABLE [dbo].[FilmGenres]  WITH CHECK ADD  CONSTRAINT [FK_FilmGenres_tblGenre] FOREIGN KEY([GenreId])
REFERENCES [dbo].[tblGenre] ([GenreId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FilmGenres] CHECK CONSTRAINT [FK_FilmGenres_tblGenre]
GO
ALTER TABLE [dbo].[FilmLikesAndDislikes]  WITH CHECK ADD  CONSTRAINT [FK_FilmLikesAndDislikes_AspNetUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FilmLikesAndDislikes] CHECK CONSTRAINT [FK_FilmLikesAndDislikes_AspNetUsers]
GO
ALTER TABLE [dbo].[FilmLikesAndDislikes]  WITH CHECK ADD  CONSTRAINT [FK_FilmLikesAndDislikes_tblFilm] FOREIGN KEY([FilmID])
REFERENCES [dbo].[tblFilm] ([FilmID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FilmLikesAndDislikes] CHECK CONSTRAINT [FK_FilmLikesAndDislikes_tblFilm]
GO
ALTER TABLE [dbo].[tblCast]  WITH CHECK ADD  CONSTRAINT [FK_tblCast_tblActor] FOREIGN KEY([CastActorID])
REFERENCES [dbo].[tblActor] ([ActorID])
ON UPDATE SET DEFAULT
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblCast] CHECK CONSTRAINT [FK_tblCast_tblActor]
GO
ALTER TABLE [dbo].[tblCast]  WITH CHECK ADD  CONSTRAINT [FK_tblCast_tblFilm] FOREIGN KEY([CastFilmID])
REFERENCES [dbo].[tblFilm] ([FilmID])
ON UPDATE SET DEFAULT
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblCast] CHECK CONSTRAINT [FK_tblCast_tblFilm]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblCertificate] FOREIGN KEY([FilmCertificateID])
REFERENCES [dbo].[tblCertificate] ([CertificateID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblCertificate]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblCountry] FOREIGN KEY([FilmCountryID])
REFERENCES [dbo].[tblCountry] ([CountryID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblCountry]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblDirector] FOREIGN KEY([FilmDirectorID])
REFERENCES [dbo].[tblDirector] ([DirectorID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblDirector]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblLanguage] FOREIGN KEY([FilmLanguageID])
REFERENCES [dbo].[tblLanguage] ([LanguageID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblLanguage]
GO
ALTER TABLE [dbo].[tblFilm]  WITH CHECK ADD  CONSTRAINT [FK_tblFilm_tblStudio1] FOREIGN KEY([FilmStudioID])
REFERENCES [dbo].[tblStudio] ([StudioID])
GO
ALTER TABLE [dbo].[tblFilm] CHECK CONSTRAINT [FK_tblFilm_tblStudio1]
GO
ALTER TABLE [dbo].[WatchList]  WITH CHECK ADD  CONSTRAINT [FK_WatchList_AspNetUsers] FOREIGN KEY([UserID])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WatchList] CHECK CONSTRAINT [FK_WatchList_AspNetUsers]
GO
ALTER TABLE [dbo].[WatchList]  WITH CHECK ADD  CONSTRAINT [FK_WatchList_tblFilm] FOREIGN KEY([FilmID])
REFERENCES [dbo].[tblFilm] ([FilmID])
GO
ALTER TABLE [dbo].[WatchList] CHECK CONSTRAINT [FK_WatchList_tblFilm]
GO
/****** Object:  StoredProcedure [dbo].[spExample]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spExample]

AS
BEGIN
	select * from tblFilm
END
GO
/****** Object:  StoredProcedure [dbo].[spFilms]    Script Date: 30.1.2020. 21:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spFilms] (

	@CertName varchar(2),	-- certificate looking for
	@MinOscars int=0		-- films with this many Oscars

) AS
SELECT 
	f.FilmName,
	c.certificate,
	f.FilmOscarWins
FROM
	tblFilm AS f
	INNER JOIN tblCertificate as c ON 
		f.FilmCertificateId=c.CertificateId
WHERE
	c.certificate=@CertName AND
	FilmOscarWins>=@MinOscars
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCertificate"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[9] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[37] 4[17] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblCertificate"
            Begin Extent = 
               Top = 131
               Left = 212
               Bottom = 209
               Right = 363
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblFilm"
            Begin Extent = 
               Top = 84
               Left = 442
               Bottom = 192
               Right = 626
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "tblCountry"
            Begin Extent = 
               Top = 6
               Left = 631
               Bottom = 84
               Right = 782
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblDirector"
            Begin Extent = 
               Top = 6
               Left = 820
               Bottom = 114
               Right = 973
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblLanguage"
            Begin Extent = 
               Top = 84
               Left = 664
               Bottom = 162
               Right = 815
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblStudio"
            Begin Extent = 
               Top = 27
               Left = 168
               Bottom = 105
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 1500
         Width = 1500
         Width = 1500
         Width = 1065
         Width = 1035
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblFilm"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmSimple'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwFilmSimple'
GO
USE [master]
GO
ALTER DATABASE [Movies] SET  READ_WRITE 
GO
