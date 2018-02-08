inputs: Length( 14 ) ;
variables: var0( 0 ), var1( 0 ) ;

Value1 = C_BullEng_BearEng( Length, var0, var1 ) ;

if var0 = 1 then
	begin
	Plot1( High, "BullEng" ) ;
	Alert( "BullishEngulfing" ) ;
	end
else if var1 = 1 then 
	begin
	Plot2( Low, "BearEng" ) ;
	Alert( "BearishEngulfing" ) ;
	end ;
