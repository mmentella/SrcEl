variables: var0( 0 ) ; 

if BarType < 3 then                                    
	begin
	condition1 = DayOfWeek( Date ) < DayOfWeek( Date[1] ) ;
	if condition1 then
		var0 = Low 
	else if Low < var0 then 
		begin
		Plot1( Low, "NewLo-W" ) ;
		Alert ;
		var0 = Low ;
		end ;
	end ;
