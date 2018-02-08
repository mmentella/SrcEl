[IntrabarOrderGeneration = false]
inputs: Strength( 4 ) ;
variables: var0( false ), var1( 0 ) ;

condition1 = SwingHigh( 1, High, Strength, Strength + 1 ) <> -1 ;
if condition1 then                               
begin
	var0 = true ;
	var1 = High[Strength] ;
end
else 
begin 
	condition1 = var0 and High >= var1 + 1 point ;
	if condition1 then
		var0 = false ;
end;	                  

if var0 then 
	Buy ( "PivRevLE" ) next bar at var1 + 1 point stop ;
