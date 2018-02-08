inputs: 
	Length( 14 ), 
	ADXTrend( 25 ) ; 

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( 0 ) ;

Value1 = DirMovement( H, L, C, Length, var0, var1, var2, var3, var4, 
 var5 ) ;

Plot1( var0, "DMI+" ) ;
Plot2( var1, "DMI-" ) ;
Plot3( var3, "ADX" ) ;

                  
if var3 > ADXTrend then 
	begin
	condition1 = var0 crosses over var1;
	if condition1 then
		Alert( "Bullish alert" ) 
	else 
	begin 
	condition1 = var0 crosses under var1 ;
	if condition1 then
		Alert( "Bearish alert" ) ;
	end ;
	end;
