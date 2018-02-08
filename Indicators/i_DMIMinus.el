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

Plot1( var1, "DMI-" ) ;
plot2(ADXTrend,"Ref");
