inputs:
	AlertLength( 14 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;

if BarType >= 2 and BarType < 5 then                              
	var0 = Volume 
else                                                                              
                                                                                 
	var0 = Ticks ;

var1 = AccumDist( var0 ) ;

Plot1( var1, "AccDst-PrVol" ) ; 

condition1 = LowestBar( C, AlertLength ) = 0 and LowestBar( var1, AlertLength ) > 0 ;
if condition1 then 
	Alert( "Bullish divergence - new low not confirmed" ) 
else 
begin 
condition1 = HighestBar( C, AlertLength ) = 0 and HighestBar( var1, AlertLength ) > 0 ;
if condition1 then
	Alert( "Bearish divergence - new high not confirmed" ) ;
end;
