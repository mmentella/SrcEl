inputs:	Length( 14 ) ;
variables: var0( 0 ), var1( 0 ) ;

Value1 = C_MornStar_EveStar( Length, var0, var1 ) ;

if var0 = 1 then
	begin
	Plot1( High, "MornStar" ) ;
	Alert( "MorningStar" ) ;
	end
else if var1 = 1 then 
	begin
	Plot2( Low, "EveStar" ) ;
	Alert( "EveningStar" ) ;
	end ;
