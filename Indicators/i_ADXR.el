inputs: 
	Length( 14 ) ;

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ), 
	var4( 0 ), 
	var5( 0 ) ;

Value1 = DirMovement( H, L, C, Length, var0, var1, var2, var3, var4, 
 var5 ) ;

Plot1( var3, "ADX" ) ;
Plot2( var4, "ADXR" ) ;

condition1 = var4 > var4[1] and var4[1] <= var4[2] ;
if condition1 then
	Alert( "ADXR turning up" ) 
else 
begin 
condition1 = var4 < var4[1] and var4[1] >= var4[2] ;
if condition1 then
	Alert( "ADXR turning down" ) ;
end;
