/* Pour éviter les problèmes éventuels de perte de données, passez attentivement ce script en revue avant de l'exécuter en dehors du contexte du Concepteur de bases de données.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ZonesPrelevements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Plages SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Plages', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Plages', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Plages', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Equipes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Equipes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Equipes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Equipes', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Etudes
	(
	id int NOT NULL IDENTITY (1, 1),
	date date NOT NULL,
	titre nvarchar(45) NOT NULL,
	idEquipe int NOT NULL,
	estTerminee bit NOT NULL,
	estClose bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Etudes SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Etudes ON
GO
IF EXISTS(SELECT * FROM dbo.Etudes)
	 EXEC('INSERT INTO dbo.Tmp_Etudes (id, date, titre, idEquipe, estTerminee)
		SELECT id, date, titre, idEquipe, estTerminee FROM dbo.Etudes WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Etudes OFF
GO
ALTER TABLE dbo.Prelevements
	DROP CONSTRAINT FK_Etudes_Has_Plages_Has_Zones_Etudes
GO
DROP TABLE dbo.Etudes
GO
EXECUTE sp_rename N'dbo.Tmp_Etudes', N'Etudes', 'OBJECT' 
GO
ALTER TABLE dbo.Etudes ADD CONSTRAINT
	PK_Etudes PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Etudes ADD CONSTRAINT
	FK_Etudes_Equipes FOREIGN KEY
	(
	idEquipe
	) REFERENCES dbo.Equipes
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[AnnulerToutPrelevementsEtudeTerminee]
   ON  dbo.Etudes
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    begin

        if exists(select * from inserted i 
					join deleted d on i.id = d.id 
					where d.estTerminee = 0 and i.estTerminee = 1)
        begin

			declare @idEtudeInseree int
			SET @idEtudeInseree = (select id from inserted i)

            UPDATE Prelevements 
			SET estAbandonnee = 1
			WHERE idEtude = @idEtudeInseree and estTermine = 0

        end
    end

END
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Etudes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Etudes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Etudes', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Prelevements
	(
	id int NOT NULL IDENTITY (1, 1),
	idEtude int NOT NULL,
	idPlage int NOT NULL,
	idZone int NOT NULL,
	surfacePlage float(53) NOT NULL,
	estTermine bit NOT NULL,
	estAbandonne bit NOT NULL,
	estEnCours bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Prelevements SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Prelevements ON
GO
IF EXISTS(SELECT * FROM dbo.Prelevements)
	 EXEC('INSERT INTO dbo.Tmp_Prelevements (id, idEtude, idPlage, idZone, surfacePlage, estTermine, estAbandonne)
		SELECT id, idEtude, idPlage, idZone, surfacePlage, estTermine, estAbandonnee FROM dbo.Prelevements WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Prelevements OFF
GO
DROP TABLE dbo.Prelevements
GO
EXECUTE sp_rename N'dbo.Tmp_Prelevements', N'Prelevements', 'OBJECT' 
GO
ALTER TABLE dbo.Prelevements ADD CONSTRAINT
	PK_Etudes_Has_Plages_Has_Zones PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Prelevements ADD CONSTRAINT
	FK_Etudes_Has_Plages_Has_Zones_Etudes FOREIGN KEY
	(
	idEtude
	) REFERENCES dbo.Etudes
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Prelevements ADD CONSTRAINT
	FK_Etudes_Has_Plages_Has_Zones_Plages FOREIGN KEY
	(
	idPlage
	) REFERENCES dbo.Plages
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Prelevements ADD CONSTRAINT
	FK_Etudes_Has_Plages_Has_Zones_ZonesPrelevements FOREIGN KEY
	(
	idZone
	) REFERENCES dbo.ZonesPrelevements
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Prelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Prelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Prelevements', 'Object', 'CONTROL') as Contr_Per 