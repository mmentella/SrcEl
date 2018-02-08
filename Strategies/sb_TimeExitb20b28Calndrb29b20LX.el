[IntrabarOrderGeneration = false]
inputs: 
	NumDays( 3 ), 
	NumHours( 0 ), 
	NumMinutes( 0 ) ;

variables: 
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( NumHours * 60 + NumMinutes ) ;

if MarketPosition = 1 then
	begin
	var0 = DateToJulian( Date ) - DateToJulian( EntryDate ) ;
	var1 = TimeToMinutes( Time ) - TimeToMinutes( EntryTime ) ;
	var2 = var0 - NumDays ;
	condition1 = var2 >= 0 and var1 + var2 * 1440 >= var3 ;
	if condition1 then
		Sell ( "TimeCalLX" ) next bar at market ;
	end ;
