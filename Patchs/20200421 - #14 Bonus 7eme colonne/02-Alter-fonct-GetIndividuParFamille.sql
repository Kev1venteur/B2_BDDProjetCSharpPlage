USE [Betterave]
GO

/****** Object:  UserDefinedFunction [dbo].[GetIndividuParFamille]    Script Date: 20/04/2020 09:28:20 ******/
DROP FUNCTION [dbo].[GetIndividuParFamille]
GO

/****** Object:  UserDefinedFunction [dbo].[GetIndividuParFamille]    Script Date: 20/04/2020 09:28:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[GetIndividuParFamille]
(    
    @idEtude int,
    @idPlage int
)
RETURNS TABLE 
AS
RETURN 
(
    select esp.classe, esp.ordre, COUNT(esp.famille) as "nombre de famille", COUNT(esp.nom)/dbo.CalcSurfaceZone(zp.id) as 'Densité individu/m²' from Especes esp
    JOIN Especes_Has_ZonePrelevements ehp on ehp.idEspece=esp.id
    JOIN ZonesPrelevements zp on ehp.idZone=zp.id
    JOIN Prelevements pr on pr.idZone=zp.id
    WHERE pr.estTermine = 1 AND pr.idEtude=@idEtude and pr.idPlage=@idPlage
    GROUP BY esp.classe, esp.ordre, esp.famille, zp.id
)
GO