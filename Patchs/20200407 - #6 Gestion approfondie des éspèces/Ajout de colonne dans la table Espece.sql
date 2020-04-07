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
CREATE TABLE dbo.Tmp_Especes
	(
	id int NOT NULL IDENTITY (1, 1),
	nom nvarchar(50) NOT NULL,
	Classe nvarchar(30) NOT NULL,
	Ordre nvarchar(30) NOT NULL,
	Famille nvarchar(30) NOT NULL,
	Genre nvarchar(30) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Especes SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Especes ON
GO
IF EXISTS(SELECT * FROM dbo.Especes)
	 EXEC('INSERT INTO dbo.Tmp_Especes (id, nom)
		SELECT id, nom FROM dbo.Especes WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Especes OFF
GO
ALTER TABLE dbo.Echantillons
	DROP CONSTRAINT FK_Echantillons_Especes
GO
ALTER TABLE dbo.Echantillons
	DROP CONSTRAINT FK_Echantillons_Especes1
GO
ALTER TABLE dbo.Especes_Has_ZonePrelevements
	DROP CONSTRAINT FK_Especes_Has_ZonePrelevements_Especes
GO
DROP TABLE dbo.Especes
GO
EXECUTE sp_rename N'dbo.Tmp_Especes', N'Especes', 'OBJECT' 
GO
ALTER TABLE dbo.Especes ADD CONSTRAINT
	PK_Especes PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.Especes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Especes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Especes', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Especes_Has_ZonePrelevements ADD CONSTRAINT
	FK_Especes_Has_ZonePrelevements_Especes FOREIGN KEY
	(
	idEspece
	) REFERENCES dbo.Especes
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Especes_Has_ZonePrelevements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Especes_Has_ZonePrelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Especes_Has_ZonePrelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Especes_Has_ZonePrelevements', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Echantillons ADD CONSTRAINT
	FK_Echantillons_Especes FOREIGN KEY
	(
	idEspecePresumee
	) REFERENCES dbo.Especes
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Echantillons ADD CONSTRAINT
	FK_Echantillons_Especes1 FOREIGN KEY
	(
	idEspeceFinale
	) REFERENCES dbo.Especes
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Echantillons SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Echantillons', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Echantillons', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Echantillons', 'Object', 'CONTROL') as Contr_Per 