variables: var0( 0 ) ; 

if BarType < 3 then                                    
	begin
	condition1 = DayOfWeek( Date ) < DayOfWeek( Date[1] ) ;
	if condition1 then
		var0 = High 
	else if High > var0 then 
		begin
		Plot1( High, "NewHi-W" ) ;
		Alert ;
		var0 = High ;
		end ;
	end ;
