inputs:
	SmoothingLength( 9 ),
	SummationLength( 25 ),
	Setup( 27 ),
	Trigger( 26.5 ) ;

variables:
	var0( 0 ),
	var1( false ) ;

var0 = MassIndex( SmoothingLength, SummationLength ) ;

Plot1( var0, "MassX" ) ;
Plot2( Setup, "Setup" ) ;
Plot3( Trigger, "Trigger" ) ;

condition1 = var0 crosses over Setup ;            
if condition1 then
	var1 = true 
else 
begin
condition1 = var1 = true and var0 crosses below Trigger ; 
if condition1 then
	begin
	Alert( "Reversal alert" ) ;
	var1 = false ;
	end ;
end;
