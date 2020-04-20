USE [Betterave]
GO

/****** Object:  Trigger [AnnulerToutPrelevementsEtudeTerminee]    Script Date: 20/04/2020 10:27:56 ******/
DROP TRIGGER [dbo].[AnnulerToutPrelevementsEtudeTerminee]
GO

/****** Object:  Trigger [dbo].[AnnulerToutPrelevementsEtudeTerminee]    Script Date: 20/04/2020 10:27:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[AnnulerToutPrelevementsEtudeTerminee]
   ON  [dbo].[Etudes]
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
			WHERE idEtude = @idEtudeInseree

        end
    end

END
GO

ALTER TABLE [dbo].[Etudes] ENABLE TRIGGER [AnnulerToutPrelevementsEtudeTerminee]
GO


