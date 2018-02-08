input: Length( 14 ) ;

condition1 = High > Highest( High, Length )[1] ;
if condition1 then 
	begin
	Plot1( High, "BrkoutHi" ) ;
	Alert ;
	end ;
