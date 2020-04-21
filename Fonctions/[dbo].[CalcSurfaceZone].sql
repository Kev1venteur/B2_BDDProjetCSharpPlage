USE [Betterave]
GO

/****** Object:  UserDefinedFunction [dbo].[CalcSurfaceZone]    Script Date: 21/04/2020 12:18:42 ******/
DROP FUNCTION [dbo].[CalcSurfaceZone]
GO

/****** Object:  UserDefinedFunction [dbo].[CalcSurfaceZone]    Script Date: 21/04/2020 12:18:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[CalcSurfaceZone]
(
	@idZoneConcernee int
)
RETURNS float
AS
BEGIN

	DECLARE @A1 decimal(9,6)
	DECLARE @B1 decimal(9,6)
	DECLARE @C1 decimal(9,6)
	DECLARE @D1 decimal(9,6)
	DECLARE @A2 decimal(9,6)
	DECLARE @B2 decimal(9,6)
	DECLARE @C2 decimal(9,6)
	DECLARE @D2 decimal(9,6)
	DECLARE @v_polygon_string varchar(1000)
	DECLARE @geoArea GEOGRAPHY
	DECLARE @return float

    declare cur cursor static local for
        select zp.lat1, zp.lat2, zp.lat3, zp.lat4, zp.long1, zp.long2, zp.long3, zp.long4 from ZonesPrelevements zp where id = @idZoneConcernee
    open cur

    fetch next from cur into @A1, @B1, @C1, @D1, @A2, @B2, @C2, @D2 

    SET @v_polygon_string = 'POLYGON(('+ convert(varchar(30),@A2) +' '+ convert(varchar(30),@A1) +', '+ convert(varchar(30),@B2) +' '+ convert(varchar(30),@B1) +', '+ convert(varchar(30),@D2) +' '+ convert(varchar(30),@D1) +', '+ convert(varchar(30),@C2) +' '+ convert(varchar(30),@C1) +', '+ convert(varchar(30),@A2) +' '+ convert(varchar(30),@A1) +'))';
    SET @geoArea = Geography::STGeomFromText(@v_polygon_string,4326);
    SET @geoArea = @geoArea.MakeValid();  
    SET @return = (SELECT @geoArea.STArea());

    close cur
    deallocate cur

	RETURN @return

END
GO


