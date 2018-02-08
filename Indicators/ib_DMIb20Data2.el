inputs: 
	Length( 14 ), 
	ADXTrend( 25 ) ; 

variables: 
	var0( 0 , data2), 
	var1( 0 , data2), 
	var2( 0 , data2), 
	var3( 0 , data2), 
	var4( 0 , data2), 
	var5( 0 , data2) ;

DirMovement( H, L, C, Length, var0, var1, var2, var3, var4, var5 )data2 ;

Plot1( var0, "DMI+" ) ;
Plot2( var1, "DMI-" ) ;
Plot3( var3, "ADX" ) ;
plot4(ADXTrend,"TREND");
