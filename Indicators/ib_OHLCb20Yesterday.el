variables:
	var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ),
	var4( 0 ),
	var5( 0 ),
	var6( 0 ),
	var7( 0 ),
	var8( 0 ) ;
	
if Date <> Date[1] then
	begin
	                                                                             
	var0 = var0 + 1 ;
	var1 = var2 ;
	var3 = var4 ;
	var5 = var6 ;
	var7 = Close[1] ;
	var2 = Open ;
	var4 = High ;
   	var6 = Low ;
	end
else
	begin
	if High > var4 then
		var4 = High ;
	if Low < var6 then
		var6 = Low ;
	end ;
condition1 = var0 >= 2 and BarType < 3 ;
if condition1 then                                           
                                                                               
	begin
	Plot1( var1, "YestOpen" ) ;
	Plot2( var3, "YestHigh" ) ;
	Plot3( var5, "YestLow" ) ;
	Plot4( var7, "YestClose" ) ;
	end ;
