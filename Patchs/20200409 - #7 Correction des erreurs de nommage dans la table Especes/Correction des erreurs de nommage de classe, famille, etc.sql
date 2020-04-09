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
EXECUTE sp_rename N'dbo.Especes.Classe', N'Tmp_classe', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Ordre', N'Tmp_ordre_1', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Famille', N'Tmp_famille_2', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Genre', N'Tmp_genre_3', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Tmp_classe', N'classe', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Tmp_ordre_1', N'ordre', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Tmp_famille_2', N'famille', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.Especes.Tmp_genre_3', N'genre', 'COLUMN' 
GO
ALTER TABLE dbo.Especes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Especes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Especes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Especes', 'Object', 'CONTROL') as Contr_Per 