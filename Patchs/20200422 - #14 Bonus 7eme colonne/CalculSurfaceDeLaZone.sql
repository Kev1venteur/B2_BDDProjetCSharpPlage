DECLARE @A1 decimal(9,6)
DECLARE @B1 decimal(9,6)
DECLARE @C1 decimal(9,6)
DECLARE @D1 decimal(9,6)
DECLARE @A2 decimal(9,6)
DECLARE @B2 decimal(9,6)
DECLARE @C2 decimal(9,6)
DECLARE @D2 decimal(9,6)
DECLARE @v_polygon_string varchar(1000);
DECLARE @geoArea GEOGRAPHY



    declare cur cursor static local for
        select zp.lat1, zp.lat2, zp.lat3, zp.lat4, zp.long1, zp.long2, zp.long3, zp.long4 from ZonesPrelevements zp
    open cur

    fetch next from cur into @A1, @B1, @C1, @D1, @A2, @B2, @C2, @D2 

    while @@FETCH_STATUS=0
    begin
            SET @v_polygon_string = 'POLYGON(('+ convert(varchar(16),@A2) +' '+ convert(varchar(16),@A1) +', '+ convert(varchar(10),@B2) +' '+ convert(varchar(16),@B1) +', '+ convert(varchar(16),@D2) +' '+ convert(varchar(16),@D1) +', '+ convert(varchar(16),@C2) +' '+ convert(varchar(16),@C1) +', '+ convert(varchar(16),@A2) +' '+ convert(varchar(16),@A1) +'))';
            SET @geoArea = Geography::STGeomFromText(@v_polygon_string,4326);
            SET @geoArea = @geoArea.MakeValid();  
            SELECT @geoArea.STArea() AS "surface en m²";
        fetch next from cur into @A1, @B1, @C1, @D1, @A2, @B2, @C2, @D2 
    end

    close cur
    deallocate cur
