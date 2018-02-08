inputs: Length( 1 ) ;

condition1 = Low < Lowest( Low, Length )[1] and Close > Close[1] ;
if condition1 then 
	begin
	Plot1( Low, "KeyRevUp" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
