inputs: 
	PriceH( High ), 
	PriceL( Low ), 
	PriceC( Close ), 
	Length( 14 ), 
	OverSold( 20 ), 
	OverBought( 80 ), 
	OverSColor( Cyan ), 
	OverBColor( Blue ) ;

variables: 
	var0( 0 ) ;

var0 = SlowKCustom( PriceH, PriceL, PriceC, Length ) ;

if var0 < OverSold then 
	begin
	PlotPaintBar( High, Low, "SlowK", OverSColor ) ;
	Alert( "SlowK in oversold zone" ) ;
	end
else if var0 > OverBought then 
	begin
	PlotPaintBar( High, Low, "SlowK", OverBColor ) ;
	Alert( "SlowK in overbought zone" ) ;
	end
else
	NoPlot( 1 ) ;
