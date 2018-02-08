[IntrabarOrderGeneration = false]
inputs: Strength( 4 ) ;
variables: var0( false ), var1( 0 ) ;

condition1 = SwingLow( 1, Low, Strength, Strength + 1 ) <> -1 ;
if condition1 then                               
begin
	var0 = true ;
	var1 = Low[Strength] ;
end
else 
begin 
	condition1 = var0 and Low <= var1 - 1 point ;
	if condition1 then
		var0 = false ;
end;
if var0 then 
	Sell Short ( "PivRevSE" ) next bar at var1 - 1 point stop ;
