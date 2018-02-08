if High < Low[1] then 
	begin
	Plot1( Low, "GapDn" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
