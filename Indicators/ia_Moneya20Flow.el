inputs:
	Length( 14 ),
	AlertLength( 14 ),
	OverSold( 20 ),
	OverBought( 80 ),
	OverSColor( Cyan ), 
	OverBColor( Red ) ;

variables:
	var0( 0 ) ;

var0 = MoneyFlow( Length ) ;

Plot1( var0, "MoneyFlow" ) ; 
Plot2( OverBought, "OverBot" ) ;
Plot3( OverSold, "OverSld" ) ;

                  
if var0 > OverBought then 
	SetPlotColor( 1, OverBColor ) 
else if var0 < OverSold then 
	SetPlotColor( 1, OverSColor ) ;

condition1 = LowestBar( C, AlertLength ) = 0 and LowestBar( var0, AlertLength ) > 0 ;    
if condition1 then 
	Alert( "Bullish divergence - new low not confirmed" ) 
else 
begin
condition1 = HighestBar( C, AlertLength ) = 0 and HighestBar( var0, AlertLength ) > 0 ; 
if condition1 then
	Alert( "Bearish divergence - new high not confirmed" ) ;
end;
