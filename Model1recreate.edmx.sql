
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 10/13/2019 09:25:15
-- Generated from EDMX file: E:\Program Files\Programs\Programs\C#\SampleMovieMVCWebApp\MBDBapp\Model1.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [Movies];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserClaims] DROP CONSTRAINT [FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId];
GO
IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserLogins] DROP CONSTRAINT [FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId];
GO
IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserRoles_dbo_AspNetRoles_RoleId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserRoles] DROP CONSTRAINT [FK_dbo_AspNetUserRoles_dbo_AspNetRoles_RoleId];
GO
IF OBJECT_ID(N'[dbo].[FK_dbo_AspNetUserRoles_dbo_AspNetUsers_UserId]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[AspNetUserRoles] DROP CONSTRAINT [FK_dbo_AspNetUserRoles_dbo_AspNetUsers_UserId];
GO
IF OBJECT_ID(N'[dbo].[FK_tblCast_tblActor]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblCast] DROP CONSTRAINT [FK_tblCast_tblActor];
GO
IF OBJECT_ID(N'[dbo].[FK_tblCast_tblFilm]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblCast] DROP CONSTRAINT [FK_tblCast_tblFilm];
GO
IF OBJECT_ID(N'[dbo].[FK_tblFilm_tblCertificate]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblFilm] DROP CONSTRAINT [FK_tblFilm_tblCertificate];
GO
IF OBJECT_ID(N'[dbo].[FK_tblFilm_tblCountry]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblFilm] DROP CONSTRAINT [FK_tblFilm_tblCountry];
GO
IF OBJECT_ID(N'[dbo].[FK_tblFilm_tblDirector]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblFilm] DROP CONSTRAINT [FK_tblFilm_tblDirector];
GO
IF OBJECT_ID(N'[dbo].[FK_tblFilm_tblLanguage]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblFilm] DROP CONSTRAINT [FK_tblFilm_tblLanguage];
GO
IF OBJECT_ID(N'[dbo].[FK_tblFilm_tblStudio1]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[tblFilm] DROP CONSTRAINT [FK_tblFilm_tblStudio1];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[__MigrationHistory]', 'U') IS NOT NULL
    DROP TABLE [dbo].[__MigrationHistory];
GO
IF OBJECT_ID(N'[dbo].[AspNetRoles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetRoles];
GO
IF OBJECT_ID(N'[dbo].[AspNetUserClaims]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUserClaims];
GO
IF OBJECT_ID(N'[dbo].[AspNetUserLogins]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUserLogins];
GO
IF OBJECT_ID(N'[dbo].[AspNetUserRoles]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUserRoles];
GO
IF OBJECT_ID(N'[dbo].[AspNetUsers]', 'U') IS NOT NULL
    DROP TABLE [dbo].[AspNetUsers];
GO
IF OBJECT_ID(N'[dbo].[tblActor]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblActor];
GO
IF OBJECT_ID(N'[dbo].[tblCast]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblCast];
GO
IF OBJECT_ID(N'[dbo].[tblCertificate]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblCertificate];
GO
IF OBJECT_ID(N'[dbo].[tblCountry]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblCountry];
GO
IF OBJECT_ID(N'[dbo].[tblDirector]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblDirector];
GO
IF OBJECT_ID(N'[dbo].[tblFilm]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblFilm];
GO
IF OBJECT_ID(N'[dbo].[tblGenre]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblGenre];
GO
IF OBJECT_ID(N'[dbo].[tblLanguage]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblLanguage];
GO
IF OBJECT_ID(N'[dbo].[tblStudio]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblStudio];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Actors'
CREATE TABLE [dbo].[Actors] (
    [ActorID] int  NOT NULL,
    [ActorName] nvarchar(255)  NULL,
    [ActorDOB] datetime  NULL,
    [ActorGender] nvarchar(255)  NULL
);
GO

-- Creating table 'Casts'
CREATE TABLE [dbo].[Casts] (
    [CastID] int  NOT NULL,
    [CastFilmID] int  NULL,
    [CastActorID] int  NULL,
    [CastCharacterName] nvarchar(255)  NULL
);
GO

-- Creating table 'tblCertificates'
CREATE TABLE [dbo].[tblCertificates] (
    [CertificateID] bigint  NOT NULL,
    [Certificate] nvarchar(255)  NULL
);
GO

-- Creating table 'Countries'
CREATE TABLE [dbo].[Countries] (
    [CountryID] int  NOT NULL,
    [CountryName] nvarchar(255)  NULL
);
GO

-- Creating table 'Directors'
CREATE TABLE [dbo].[Directors] (
    [DirectorID] int  NOT NULL,
    [DirectorName] nvarchar(255)  NULL,
    [DirectorDOB] datetime  NULL,
    [DirectorGender] nvarchar(255)  NULL
);
GO

-- Creating table 'Films'
CREATE TABLE [dbo].[Films] (
    [FilmID] int  NOT NULL,
    [FilmName] nvarchar(255)  NOT NULL,
    [FilmReleaseDate] datetime  NOT NULL,
    [FilmDirectorID] int  NOT NULL,
    [FilmLanguageID] int  NOT NULL,
    [FilmCountryID] int  NOT NULL,
    [FilmStudioID] int  NULL,
    [FilmSynopsis] nvarchar(max)  NOT NULL,
    [FilmRunTimeMinutes] int  NOT NULL,
    [FilmCertificateID] bigint  NULL,
    [FilmBudgetDollars] int  NULL,
    [FilmBoxOfficeDollars] int  NULL,
    [FilmOscarNominations] int  NOT NULL,
    [FilmOscarWins] int  NOT NULL
);
GO

-- Creating table 'Genres'
CREATE TABLE [dbo].[Genres] (
    [GenreId] bigint  NOT NULL,
    [GenreName] varchar(50)  NULL
);
GO

-- Creating table 'tblLanguages'
CREATE TABLE [dbo].[tblLanguages] (
    [LanguageID] int  NOT NULL,
    [Language] nvarchar(255)  NULL
);
GO

-- Creating table 'Studios'
CREATE TABLE [dbo].[Studios] (
    [StudioID] int  NOT NULL,
    [StudioName] nvarchar(255)  NULL
);
GO

-- Creating table 'C__MigrationHistory'
CREATE TABLE [dbo].[C__MigrationHistory] (
    [MigrationId] nvarchar(150)  NOT NULL,
    [ContextKey] nvarchar(300)  NOT NULL,
    [Model] varbinary(max)  NOT NULL,
    [ProductVersion] nvarchar(32)  NOT NULL
);
GO

-- Creating table 'AspNetRoles'
CREATE TABLE [dbo].[AspNetRoles] (
    [Id] nvarchar(128)  NOT NULL,
    [Name] nvarchar(256)  NOT NULL
);
GO

-- Creating table 'AspNetUserClaims'
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [UserId] nvarchar(128)  NOT NULL,
    [ClaimType] nvarchar(max)  NULL,
    [ClaimValue] nvarchar(max)  NULL
);
GO

-- Creating table 'AspNetUserLogins'
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider] nvarchar(128)  NOT NULL,
    [ProviderKey] nvarchar(128)  NOT NULL,
    [UserId] nvarchar(128)  NOT NULL
);
GO

-- Creating table 'AspNetUsers'
CREATE TABLE [dbo].[AspNetUsers] (
    [Id] nvarchar(128)  NOT NULL,
    [Email] nvarchar(256)  NULL,
    [EmailConfirmed] bit  NOT NULL,
    [PasswordHash] nvarchar(max)  NULL,
    [SecurityStamp] nvarchar(max)  NULL,
    [PhoneNumber] nvarchar(max)  NULL,
    [PhoneNumberConfirmed] bit  NOT NULL,
    [TwoFactorEnabled] bit  NOT NULL,
    [LockoutEndDateUtc] datetime  NULL,
    [LockoutEnabled] bit  NOT NULL,
    [AccessFailedCount] int  NOT NULL,
    [UserName] nvarchar(256)  NOT NULL
);
GO

-- Creating table 'AspNetUserRoles'
CREATE TABLE [dbo].[AspNetUserRoles] (
    [AspNetRoles_Id] nvarchar(128)  NOT NULL,
    [AspNetUsers_Id] nvarchar(128)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [ActorID] in table 'Actors'
ALTER TABLE [dbo].[Actors]
ADD CONSTRAINT [PK_Actors]
    PRIMARY KEY CLUSTERED ([ActorID] ASC);
GO

-- Creating primary key on [CastID] in table 'Casts'
ALTER TABLE [dbo].[Casts]
ADD CONSTRAINT [PK_Casts]
    PRIMARY KEY CLUSTERED ([CastID] ASC);
GO

-- Creating primary key on [CertificateID] in table 'tblCertificates'
ALTER TABLE [dbo].[tblCertificates]
ADD CONSTRAINT [PK_tblCertificates]
    PRIMARY KEY CLUSTERED ([CertificateID] ASC);
GO

-- Creating primary key on [CountryID] in table 'Countries'
ALTER TABLE [dbo].[Countries]
ADD CONSTRAINT [PK_Countries]
    PRIMARY KEY CLUSTERED ([CountryID] ASC);
GO

-- Creating primary key on [DirectorID] in table 'Directors'
ALTER TABLE [dbo].[Directors]
ADD CONSTRAINT [PK_Directors]
    PRIMARY KEY CLUSTERED ([DirectorID] ASC);
GO

-- Creating primary key on [FilmID] in table 'Films'
ALTER TABLE [dbo].[Films]
ADD CONSTRAINT [PK_Films]
    PRIMARY KEY CLUSTERED ([FilmID] ASC);
GO

-- Creating primary key on [GenreId] in table 'Genres'
ALTER TABLE [dbo].[Genres]
ADD CONSTRAINT [PK_Genres]
    PRIMARY KEY CLUSTERED ([GenreId] ASC);
GO

-- Creating primary key on [LanguageID] in table 'tblLanguages'
ALTER TABLE [dbo].[tblLanguages]
ADD CONSTRAINT [PK_tblLanguages]
    PRIMARY KEY CLUSTERED ([LanguageID] ASC);
GO

-- Creating primary key on [StudioID] in table 'Studios'
ALTER TABLE [dbo].[Studios]
ADD CONSTRAINT [PK_Studios]
    PRIMARY KEY CLUSTERED ([StudioID] ASC);
GO

-- Creating primary key on [MigrationId], [ContextKey] in table 'C__MigrationHistory'
ALTER TABLE [dbo].[C__MigrationHistory]
ADD CONSTRAINT [PK_C__MigrationHistory]
    PRIMARY KEY CLUSTERED ([MigrationId], [ContextKey] ASC);
GO

-- Creating primary key on [Id] in table 'AspNetRoles'
ALTER TABLE [dbo].[AspNetRoles]
ADD CONSTRAINT [PK_AspNetRoles]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'AspNetUserClaims'
ALTER TABLE [dbo].[AspNetUserClaims]
ADD CONSTRAINT [PK_AspNetUserClaims]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [LoginProvider], [ProviderKey], [UserId] in table 'AspNetUserLogins'
ALTER TABLE [dbo].[AspNetUserLogins]
ADD CONSTRAINT [PK_AspNetUserLogins]
    PRIMARY KEY CLUSTERED ([LoginProvider], [ProviderKey], [UserId] ASC);
GO

-- Creating primary key on [Id] in table 'AspNetUsers'
ALTER TABLE [dbo].[AspNetUsers]
ADD CONSTRAINT [PK_AspNetUsers]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [AspNetRoles_Id], [AspNetUsers_Id] in table 'AspNetUserRoles'
ALTER TABLE [dbo].[AspNetUserRoles]
ADD CONSTRAINT [PK_AspNetUserRoles]
    PRIMARY KEY CLUSTERED ([AspNetRoles_Id], [AspNetUsers_Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [FilmCertificateID] in table 'Films'
ALTER TABLE [dbo].[Films]
ADD CONSTRAINT [FK_tblFilm_tblCertificate]
    FOREIGN KEY ([FilmCertificateID])
    REFERENCES [dbo].[tblCertificates]
        ([CertificateID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblFilm_tblCertificate'
CREATE INDEX [IX_FK_tblFilm_tblCertificate]
ON [dbo].[Films]
    ([FilmCertificateID]);
GO

-- Creating foreign key on [FilmCountryID] in table 'Films'
ALTER TABLE [dbo].[Films]
ADD CONSTRAINT [FK_tblFilm_tblCountry]
    FOREIGN KEY ([FilmCountryID])
    REFERENCES [dbo].[Countries]
        ([CountryID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblFilm_tblCountry'
CREATE INDEX [IX_FK_tblFilm_tblCountry]
ON [dbo].[Films]
    ([FilmCountryID]);
GO

-- Creating foreign key on [FilmDirectorID] in table 'Films'
ALTER TABLE [dbo].[Films]
ADD CONSTRAINT [FK_tblFilm_tblDirector]
    FOREIGN KEY ([FilmDirectorID])
    REFERENCES [dbo].[Directors]
        ([DirectorID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblFilm_tblDirector'
CREATE INDEX [IX_FK_tblFilm_tblDirector]
ON [dbo].[Films]
    ([FilmDirectorID]);
GO

-- Creating foreign key on [FilmLanguageID] in table 'Films'
ALTER TABLE [dbo].[Films]
ADD CONSTRAINT [FK_tblFilm_tblLanguage]
    FOREIGN KEY ([FilmLanguageID])
    REFERENCES [dbo].[tblLanguages]
        ([LanguageID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblFilm_tblLanguage'
CREATE INDEX [IX_FK_tblFilm_tblLanguage]
ON [dbo].[Films]
    ([FilmLanguageID]);
GO

-- Creating foreign key on [FilmStudioID] in table 'Films'
ALTER TABLE [dbo].[Films]
ADD CONSTRAINT [FK_tblFilm_tblStudio1]
    FOREIGN KEY ([FilmStudioID])
    REFERENCES [dbo].[Studios]
        ([StudioID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblFilm_tblStudio1'
CREATE INDEX [IX_FK_tblFilm_tblStudio1]
ON [dbo].[Films]
    ([FilmStudioID]);
GO

-- Creating foreign key on [CastActorID] in table 'Casts'
ALTER TABLE [dbo].[Casts]
ADD CONSTRAINT [FK_tblCast_tblActor]
    FOREIGN KEY ([CastActorID])
    REFERENCES [dbo].[Actors]
        ([ActorID])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblCast_tblActor'
CREATE INDEX [IX_FK_tblCast_tblActor]
ON [dbo].[Casts]
    ([CastActorID]);
GO

-- Creating foreign key on [CastFilmID] in table 'Casts'
ALTER TABLE [dbo].[Casts]
ADD CONSTRAINT [FK_tblCast_tblFilm]
    FOREIGN KEY ([CastFilmID])
    REFERENCES [dbo].[Films]
        ([FilmID])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_tblCast_tblFilm'
CREATE INDEX [IX_FK_tblCast_tblFilm]
ON [dbo].[Casts]
    ([CastFilmID]);
GO

-- Creating foreign key on [UserId] in table 'AspNetUserClaims'
ALTER TABLE [dbo].[AspNetUserClaims]
ADD CONSTRAINT [FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [dbo].[AspNetUsers]
        ([Id])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId'
CREATE INDEX [IX_FK_dbo_AspNetUserClaims_dbo_AspNetUsers_UserId]
ON [dbo].[AspNetUserClaims]
    ([UserId]);
GO

-- Creating foreign key on [UserId] in table 'AspNetUserLogins'
ALTER TABLE [dbo].[AspNetUserLogins]
ADD CONSTRAINT [FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId]
    FOREIGN KEY ([UserId])
    REFERENCES [dbo].[AspNetUsers]
        ([Id])
    ON DELETE CASCADE ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId'
CREATE INDEX [IX_FK_dbo_AspNetUserLogins_dbo_AspNetUsers_UserId]
ON [dbo].[AspNetUserLogins]
    ([UserId]);
GO

-- Creating foreign key on [AspNetRoles_Id] in table 'AspNetUserRoles'
ALTER TABLE [dbo].[AspNetUserRoles]
ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRole]
    FOREIGN KEY ([AspNetRoles_Id])
    REFERENCES [dbo].[AspNetRoles]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [AspNetUsers_Id] in table 'AspNetUserRoles'
ALTER TABLE [dbo].[AspNetUserRoles]
ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUser]
    FOREIGN KEY ([AspNetUsers_Id])
    REFERENCES [dbo].[AspNetUsers]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_AspNetUserRoles_AspNetUser'
CREATE INDEX [IX_FK_AspNetUserRoles_AspNetUser]
ON [dbo].[AspNetUserRoles]
    ([AspNetUsers_Id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------