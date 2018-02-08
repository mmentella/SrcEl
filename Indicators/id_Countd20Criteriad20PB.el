inputs: Criteria( Close > High[1] ), Length( 14 ), Occur( 7 ) ;

condition1 = CountIf( Criteria, Length ) >= Occur  ;
if condition1 then 
	begin
	PlotPaintBar( High, Low, "CntCrtPB" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
