USE [Betterave]
GO

/****** Object:  Trigger [PasDuplicationComptage]    Script Date: 20/04/2020 14:39:32 ******/
DROP TRIGGER [dbo].[PasDuplicationComptage]
GO

/****** Object:  Trigger [dbo].[PasDuplicationComptage]    Script Date: 20/04/2020 14:39:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[PasDuplicationComptage]
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

				declare cur cursor static local for
					select idEspece, idZone, dateRencontre, nbIndividus from inserted

				open cur

				fetch next from cur into @idEspece, @idZone, @date, @nbIndividus

				while @@FETCH_STATUS=0

				begin
					insert into Especes_Has_ZonePrelevements 
					(idEspece, idZone, dateRencontre, nbIndividus)
					VALUES (@idEspece,@idZone,@date,@nbIndividus)

					fetch next from cur into @idEspece, @idZone, @date, @nbIndividus
				end

				close cur
				deallocate cur
			end
		end
END
GO

ALTER TABLE [dbo].[Especes_Has_ZonePrelevements] ENABLE TRIGGER [PasDuplicationComptage]
GO


