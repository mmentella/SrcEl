inputs: 
	AdvIssues( Close of data1 ), 
	AdvVol( Close of data2 ), 
	DecIssues( Close of data3 ), 
	DecVol( Close of data4 ), 
	SmoothingLength( 14 ) ;

variables:
	var0( 0 ),
	var1( 0 ) ;

var0 = AdvIssues * AdvVol - DecIssues * DecVol ;
var1 = Average( var0, SmoothingLength ) ;

Plot1( var0, "RawMktThr" ) ;
Plot2( var1, "MktThr" ) ;
Plot3( 0, "ZeroLine" ) ;

condition1 = var1 crosses over 0 ;
if condition1 then 
	Alert( "Indicator turning positive" ) 
else 
begin 
condition1 = var1 crosses under 0 ;
if condition1 then
	Alert( "Indicator turning negative" ) ;
end;
