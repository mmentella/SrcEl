inputs:
	AlertLength( 14 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;

if BarType >= 2 and BarType < 5 then                              
	var1 = Volume 
else                                                                              
                                                                                 
	var1 = Ticks ;

var0 = MFI( var1 ) ;

Plot1( var0, "MktFacilX" ) ;

condition1 = HighestBar( var0, AlertLength ) = 0 ;
if condition1 then
	Alert( "Indicator at high" ) 
else 
begin 
condition1 = LowestBar( var0, AlertLength ) = 0 ;
if condition1 then
	Alert( "Indicator at low" ) ;
end;
