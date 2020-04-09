SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		Author,,Name
-- Create date Create Date,,
-- Description	Description,,
-- =============================================
CREATE FUNCTION [dbo].[GetBornage]
(	
	@idEtude int,
	@idPlage int
)
RETURNS TABLE 
AS
RETURN 
(
	select lat1, long1, lat2, long2, lat3, long3, lat4, long4 from ZonesPrelevements zp
	join Prelevements p on p.idZone=zp.id where p.idEtude=@idEtude and p.idPlage=@idPlage
)
GO