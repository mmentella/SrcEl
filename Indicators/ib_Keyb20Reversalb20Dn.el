inputs: Length( 1 ) ;

condition1 = High > Highest( High, Length )[1] and Close < Close[1] ;
if condition1 then 
	begin
	Plot1( High, "KeyRevDn" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
