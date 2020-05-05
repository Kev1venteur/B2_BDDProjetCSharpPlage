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
ALTER TABLE dbo.ZonesPrelevements ADD CONSTRAINT
	CK_ZonesPrelevements CHECK (lat1 <= 90 and lat1 >= -90 and lat2 <= 90 and lat2 >= -90 and lat3 <= 90 and lat3 >= -90 and lat4 <= 90 and lat4 >= -90 and long1 <= 180 and long1 >= -180 and long2 <= 180 and long2 >= -180 and long3 <= 180 and long3 >= -180 and long4 <= 180 and long4 >= -180)
GO
ALTER TABLE dbo.ZonesPrelevements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'CONTROL') as Contr_Per 