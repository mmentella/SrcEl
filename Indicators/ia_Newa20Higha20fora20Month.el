variables: var0( 0 ) ; 

if BarType < 4 then                                            
	begin
	condition1 = Month( Date ) <> Month( Date[1] ) ;
	if condition1 then
		var0 = High 
	else if High > var0 then 
		begin
		Plot1( High, "NewHi-M" ) ;
		Alert ;
		var0 = High ;
		end ;
	end ;
