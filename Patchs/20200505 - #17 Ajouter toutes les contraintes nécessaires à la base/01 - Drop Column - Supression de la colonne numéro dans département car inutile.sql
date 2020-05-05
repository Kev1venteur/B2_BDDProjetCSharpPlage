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
ALTER TABLE dbo.Communes
	DROP CONSTRAINT FK_Communes_Departements
GO
ALTER TABLE dbo.Departements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Departements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Departements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Departements', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Communes ADD CONSTRAINT
	FK_Communes_Departements FOREIGN KEY
	(
	idDepartement
	) REFERENCES dbo.Departements
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Communes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Communes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Communes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Communes', 'Object', 'CONTROL') as Contr_Per 