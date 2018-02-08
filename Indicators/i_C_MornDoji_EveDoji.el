inputs: Length( 14 ), Percent( 5 ) ;
variables: var0( 0 ), var1( 0 ) ;

Value1 = C_MornDoji_EveDoji( Length, Percent, var0, var1 ) ;

if var0 = 1 then
	begin
	Plot1( High, "MornDoji" ) ;
	Alert( "MorningDojiStar" ) ;
	end
else if var1 = 1 then 
	begin
	Plot2( Low, "EveDoji" ) ;
	Alert( "EveningDojiStar" ) ;
	end ;
