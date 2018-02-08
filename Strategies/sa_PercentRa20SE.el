inputs: Length( 14 ), OverSold( 20 ), OverBought( 80 ), Trigger( 38 ) ;
                                    
variables: var0( 0 ), var1( 0 ), var2( false ) ;

var0 = PercentR( Length ) ;
var1 = Average( Close, Length ) ;

if var0 > OverBought then
	var2 = true 
else if var0 < Oversold then
	var2 = false ;

condition1 = var2 and var1 < var1[1] and var0 crosses under Trigger ; 
if condition1 then                                  
begin
	Sell Short ( "PctRSE" ) next bar at market ;
	var2 = false ;
end ;
