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
ALTER TABLE dbo.Prelevements ADD CONSTRAINT
	CK_Prelevements CHECK (estTermine = 1 and estAbandonne = 0 and estEncours = 0 OR estTermine = 0 and estAbandonne = 1 and estEncours = 0 OR estTermine = 0 and estAbandonne = 0 and estEncours = 1)
GO
COMMIT