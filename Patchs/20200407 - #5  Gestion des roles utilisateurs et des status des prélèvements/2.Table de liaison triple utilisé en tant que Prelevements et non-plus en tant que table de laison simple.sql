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
ALTER TABLE dbo.Etudes_Has_Plages_Has_Zones
	DROP CONSTRAINT FK_Etudes_Has_Plages_Has_Zones_ZonesPrelevements
GO
ALTER TABLE dbo.ZonesPrelevements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Etudes_Has_Plages_Has_Zones
	DROP CONSTRAINT FK_Etudes_Has_Plages_Has_Zones_Plages
GO
ALTER TABLE dbo.Plages SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Plages', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Plages', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Plages', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Etudes_Has_Plages_Has_Zones
	DROP CONSTRAINT FK_Etudes_Has_Plages_Has_Zones_Etudes
GO
ALTER TABLE dbo.Etudes SET (LOCK_ESCALATION = TABLE)
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
	estAbandonnee bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Prelevements SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Prelevements ON
GO
IF EXISTS(SELECT * FROM dbo.Etudes_Has_Plages_Has_Zones)
	 EXEC('INSERT INTO dbo.Tmp_Prelevements (id, idEtude, idPlage, idZone, surfacePlage, estTermine, estAbandonnee)
		SELECT CONVERT(int, nomConcatenation), idEtude, idPlage, idZone, surfacePlage, estTermine, estAbandonnee FROM dbo.Etudes_Has_Plages_Has_Zones WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Prelevements OFF
GO
DROP TABLE dbo.Etudes_Has_Plages_Has_Zones
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