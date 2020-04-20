USE [Betterave]
GO
/****** Object:  Trigger [dbo].[PasDuplicationComptage]    Script Date: 20/04/2020 14:15:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[PasDuplicationComptage]
   ON  [dbo].[Especes_Has_ZonePrelevements]
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
				declare @idEspece int, @idZone int, @date date, @nbIndividus int

				SET @idEspece = (select idEspece from inserted)
				SET @idZone = (select idZone from inserted)
				SET @date = (select dateRencontre from inserted)
				SET @nbIndividus = (select nbIndividus from inserted)

				insert into Especes_Has_ZonePrelevements 
				(idEspece, idZone, dateRencontre, nbIndividus)
				VALUES (@idEspece,@idZone,@date,@nbIndividus);

			end
		end
END