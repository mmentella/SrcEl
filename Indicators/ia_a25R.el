inputs: 
	Length( 14 ), 
	OverSold( 20 ), 
	OverBought( 80 ), 
	OverSColor( Cyan ), 
	OverBColor( Red ) ;

variables:
	var0( 0 ) ;

var0 = PercentR( Length ) ;

Plot1( var0, "%R" ) ;
Plot2( OverBought, "OverBot" ) ;
Plot3( OverSold, "OverSld" ) ;

                  
if var0 > OverBought then 
	SetPlotColor( 1, OverBColor ) 
else if var0 < OverSold then 
	SetPlotColor( 1, OverSColor ) ;

condition1 = var0 crosses over OverSold ;
if condition1 then
	Alert( "Indicator exiting oversold zone" )
else 
begin
condition1 = var0 crosses under OverBought ; 
if condition1 then
	Alert( "Indicator exiting overbought zone" ) ;
end;
