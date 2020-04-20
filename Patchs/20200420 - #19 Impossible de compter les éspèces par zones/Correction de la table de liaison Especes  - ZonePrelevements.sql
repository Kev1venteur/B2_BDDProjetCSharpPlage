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
ALTER TABLE dbo.Especes_Has_ZonePrelevements
	DROP CONSTRAINT FK_Especes_Has_ZonePrelevements_Especes
GO
ALTER TABLE dbo.Especes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Especes', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Especes', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Especes', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.Especes_Has_ZonePrelevements
	DROP CONSTRAINT FK_Especes_Has_ZonePrelevements_ZonesPrelevements
GO
ALTER TABLE dbo.ZonesPrelevements SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.ZonesPrelevements', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Especes_Has_ZonePrelevements
	(
	dateRencontre date NOT NULL,
	idEspece int NOT NULL,
	idZone int NOT NULL,
	nbIndividus int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Especes_Has_ZonePrelevements SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Especes_Has_ZonePrelevements)
	 EXEC('INSERT INTO dbo.Tmp_Especes_Has_ZonePrelevements (dateRencontre, idEspece, idZone)
		SELECT dateRencontre, idEspece, idZone FROM dbo.Especes_Has_ZonePrelevements WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Especes_Has_ZonePrelevements
GO
EXECUTE sp_rename N'dbo.Tmp_Especes_Has_ZonePrelevements', N'Especes_Has_ZonePrelevements', 'OBJECT' 
GO
ALTER TABLE dbo.Especes_Has_ZonePrelevements ADD CONSTRAINT
	FK_Especes_Has_ZonePrelevements_ZonesPrelevements FOREIGN KEY
	(
	idZone
	) REFERENCES dbo.ZonesPrelevements
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[PasDuplicationComptage]
   ON  dbo.Especes_Has_ZonePrelevements
   INSTEAD OF INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

        begin

        if exists(select * from Especes_Has_ZonePrelevements ezp 
					join inserted i
					on i.idEspece = ezp.idEspece and i.idZone=ezp.idZone
					where i.idEspece = ezp.idEspece and i.idZone = ezp.idZone)
			begin

				rollback
				print 'Cette espece existe déjà dans cette zone.'

			end
		if not exists(select * from Especes_Has_ZonePrelevements ezp 
					join inserted i
					on i.idEspece = ezp.idEspece and i.idZone=ezp.idZone
					where i.idEspece = ezp.idEspece and i.idZone = ezp.idZone)
			begin
				declare @idEspece int, @idZone int, @date date

				SET @idEspece = (select idEspece from inserted)
				SET @idZone = (select idZone from inserted)
				SET @date = (select dateRencontre from inserted)

				insert into Especes_Has_ZonePrelevements 
				(idEspece, idZone, dateRencontre)
				VALUES (@idEspece,@idZone,@date);

			end
		end
END
GO
COMMIT
select Has_Perms_By_Name(N'dbo.Especes_Has_ZonePrelevements', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.Especes_Has_ZonePrelevements', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.Especes_Has_ZonePrelevements', 'Object', 'CONTROL') as Contr_Per 