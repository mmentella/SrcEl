inputs: Length( 14 ), Percent( 5 ) ;
variables: var0( 0 ), var1( 0 ) ;

Value1 = C_3WhSolds_3BlkCrows( Length, Percent, var0, var1 ) ;

if var0 = 1 then
	begin
	Plot1( High, "3WhSolds" ) ;
	Alert( "3WhiteSoldiers" ) ;
	end
else if var1 = 1 then 
	begin
	Plot2( Low, "3BlkCrows" ) ;
	Alert( "3BlackCrows" ) ;
	end ;
