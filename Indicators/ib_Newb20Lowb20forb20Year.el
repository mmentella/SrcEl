variables: var0( 0 ) ; 

if BarType <> 5 then                                                     
	begin
	condition1 = Year( Date ) <> Year( Date[1] ) ;
	if condition1 then
		var0 = Low 
	else if Low < var0 then 
		begin
		Plot1( Low, "NewLo-Y" ) ;
		Alert ;
		var0 = Low ;
		end ;
	end ;
