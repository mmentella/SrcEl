inputs:
	Formula1( Close ),
	Formula2( Average( Close, 9 ) ),
	DataNum( 1 ) ;                                                        

variables:
	intrabarpersist var0( 0 ),
	intrabarpersist var1( 0 ),
	intrabarpersist var2( false ) ;

condition1 = LastBarOnChart and BarStatus( DataNum ) <> 2 ;
if condition1 then
	begin
		
	if CurrentBar > var0 then
		begin
		var1 = 0 ;
		var0 = CurrentBar ;
		end ;
	
	condition1 = Formula1 < Formula2 and var2 ;
	if condition1 then
		begin
		var1 = var1 + 1 ;
		var2 = false ;
		end
    else if Formula1 > Formula2 then
		var2 = true ;

	Plot1( var1, "Crossunders" ) ;
	
	end ;
