SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SubstitutionEspeces
    @idEspece INT,
    @idEspeceARemplacer INT,
    @idZone INT,
    @nombreInserer INT

AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT * FROM Especes_Has_ZonePrelevements
        WHERE idEspece=@idEspeceARemplacer AND idZone=@idZone)
    BEGIN
        DELETE FROM Especes_Has_ZonePrelevements 
        WHERE idEspece = @idEspeceARemplacer
        INSERT INTO Especes_Has_ZonePrelevements (idEspece, idZone, nbIndividus) VALUES (@idEspece, @idZone, @nombreInserer)
    END
    ELSE
    BEGIN
        UPDATE Especes_Has_ZonePrelevements SET nbIndividus = nbIndividus + @nombreInserer FROM Especes_Has_ZonePrelevements
        WHERE idEspece=@idEspece AND idZone=@idZone
    END
END
GO


