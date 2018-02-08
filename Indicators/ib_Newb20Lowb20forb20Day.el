variables: var0( 0 ) ; 

if BarType <= 1 or BarType >= 5 then                             
	begin
	if Date <> Date[1] then
		var0 = Low 
	else if Low < var0 then 
		begin
		Plot1( Low, "NewLo-D" ) ;
		Alert ;
		var0 = Low ;
		end ;
	end ;
