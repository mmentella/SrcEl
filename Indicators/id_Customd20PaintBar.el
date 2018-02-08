inputs:
	Criteria( High < High[1] and Low > Low[1] ) ;               

if Criteria then 
	begin
 	PlotPaintBar( High, Low, "CustomPB" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
