USE [Betterave]
GO
/****** Object:  UserDefinedFunction [dbo].[GetIndividu]    Script Date: 21/04/2020 12:24:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[GetIndividu]
(    
    @idEtude int,
    @idPlage int
)
RETURNS TABLE 
AS
RETURN 
(
    select esp.nom as especes, esp.classe, esp.ordre, esp.famille, esp.genre, COUNT(esp.nom) as "nombre d'individu", COUNT(esp.nom)/dbo.CalcSurfaceZone(zp.id) as 'Densité individu/m²' from Especes esp
    JOIN Especes_Has_ZonePrelevements ehp on ehp.idEspece=esp.id
    JOIN ZonesPrelevements zp on ehp.idZone=zp.id
    JOIN Prelevements pr on pr.idZone=zp.id
    WHERE pr.estTermine = 1 AND pr.idEtude=@idEtude and pr.idPlage=@idPlage
    GROUP BY esp.nom, esp.classe, esp.ordre, esp.famille, esp.genre, zp.id
)