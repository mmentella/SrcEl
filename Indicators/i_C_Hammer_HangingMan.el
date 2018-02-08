inputs: Length( 14 ), Factor( 2 ) ;
variables: var0( 0 ), var1( 0 ) ;

Value1 = C_Hammer_HangingMan( Length, Factor, var0, var1 ) ;

if var0 = 1 then
	begin
	Plot1( High, "Hammer" ) ;
	Alert( "Hammer" ) ;
	end
else if var1 = 1 then 
	begin
	Plot2( Low, "HangMan" ) ;
	Alert( "HangingMan" ) ;
	end ;
