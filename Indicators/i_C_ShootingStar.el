inputs:	Length( 14 ), Factor( 2 ) ;

condition1 = C_ShootingStar( Length, Factor ) = 1 ;
if condition1 then
	begin
	Plot1( Close, "ShStar" ) ;
	Alert( "ShootingStar" ) ;
	end ;
