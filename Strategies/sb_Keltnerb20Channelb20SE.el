[IntrabarOrderGeneration = false]
inputs:  Price( Close ), Length( 20 ), NumATRs( 1.5 ) ;
variables:  var0( 0 ), var1( 0 ), var2( 0 ), var3( false ), var4( 0 ) ;

var0 = AverageFC( Price, Length ) ;
var1 = NumATRs * AvgTrueRange( Length ) ;
var2 = var0 - var1 ;

condition1 = CurrentBar > 1 and Price crosses under var2 ;
if condition1 then                                                                    
	begin
	var3 = true ;
	var4 = Low ;
	end 
else
begin 
	condition1 = var3 and ( Price > var0 or Low <= var4 - 1 point ) ;
	if condition1 then
		var3 = false ;
end;
if var3 then 
	Sell Short ( "KltChSE" ) next bar at var4 - 1 point stop ;
