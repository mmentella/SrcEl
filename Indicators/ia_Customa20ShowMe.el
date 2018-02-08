inputs: 
	Criteria( High < High[1] and Low > Low[1] ),                 
	PlotPrice( Close ) ;

if Criteria then 
	begin
	Plot1( PlotPrice, "CustomSM" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
