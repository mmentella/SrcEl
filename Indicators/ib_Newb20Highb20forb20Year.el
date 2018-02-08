variables: var0( 0 ) ; 

if BarType <> 5 then                                                     
	begin
	condition1 = Year( Date ) <> Year( Date[1] ) ;
	if condition1 then
		var0 = High 
	else if High > var0 then 
		begin
		Plot1( High, "NewHi-Y" ) ;
		Alert ;
		var0 = High ;
		end ;
	end ;
