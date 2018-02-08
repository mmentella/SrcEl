inputs:
	Plot_5or7( 5 ) ;                                                    

variables:
    var0( 0 ),
	var1( 0 ),
	var2( 0 ),
	var3( 0 ),
	var4( 0 ),
	var5( 0 ),
	var6( 0 ),
	var7( 0 ),
	var8( 0 ),
	var9( 0 ),
	var10( 0 ),
	var11( 0 ),
	var12( 0 ),
	var13( 0 ) ;
	
if Date <> Date[1] then
	begin
	                                                                             
	var13 = var13 + 1 ;
	var8 = var7 ;
	var10 = var9 ;
	var12 = Close[1] ;
	var7 = High ;
   	var9 = Low ;
	var6 = ( var8 + var10 + var12 ) / 3 ;
	var3 = var6 * 2 - var10 ;
	var4 = var6 + var8 - var10 ;
	var5 = var4 + var8 - var10 ;
	var0 = var6 * 2 - var8 ;
	var1 = var6 - var8 + var10 ;
	var2 = var1 - var8 + var10 ;
	end
else
	begin
	if High > var7 then
		var7 = High ;
	if Low < var9 then
		var9 = Low ;
	end ;

condition1 = var13 >= 2 and BarType < 3 ;
if condition1 then                                           
                                                                              
	begin
	if Plot_5or7 = 7 then
		Plot1( var5, "R3" ) ;
	Plot2( var4, "R2" ) ;
	Plot3( var3, "R1" ) ;
	Plot4( var6, "PP" ) ;
	Plot5( var0, "S1" ) ;
	Plot6( var1, "S2" ) ;
	if Plot_5or7 = 7 then
 		Plot7( var2, "S3" ) ;
	end ;
