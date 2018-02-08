inputs: 
	Length( 4 ), 
	PctRange( 30 ) ;                                  

variables: 
	var0( PctRange * .01 ) ;

condition1 = High < Lowest( Low, Length )[1] and Close > High - Range * var0 ;
if condition1 then 
	begin
	Plot1( Low, "IslandUp" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
