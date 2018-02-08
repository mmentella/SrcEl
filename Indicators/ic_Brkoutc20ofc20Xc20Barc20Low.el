input: Length( 14 ) ;

condition1 = Low < Lowest( Low, Length )[1] ;
if condition1 then 
	begin
	Plot1( Low, "BrkoutLo" ) ;
	Alert ;
	end ;
