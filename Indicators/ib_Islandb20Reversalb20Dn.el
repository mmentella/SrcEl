inputs: 
	Length( 4 ), 
	PctRange( 30 ) ;                                     

variables: 
	var0( PctRange * .01 ) ;

condition1 = Low > Highest( High, Length )[1] and Close < Low + Range * var0 ;
if condition1 then 
	begin
	Plot1( High, "IslandDn" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
