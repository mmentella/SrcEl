inputs: Percent( 5 ) ;

if C_Doji( Percent ) = 1 then
	begin
	Plot1( Close, "Doji" ) ;
	Alert( "Doji" ) ;
	end ;
