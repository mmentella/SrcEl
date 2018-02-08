if Low > High[1] then 
	begin
	Plot1( High, "GapUp" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
