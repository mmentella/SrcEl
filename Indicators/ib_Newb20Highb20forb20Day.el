variables: var0( 0 ) ; 

if BarType <= 1 or BarType >= 5 then                             
	begin
	if Date <> Date[1] then
		var0 = High 
	else if High > var0 then 
		begin
		Plot1( High, "NewHi-D" ) ;
		Alert ;
		var0 = High ;
		end ;
	end ;
