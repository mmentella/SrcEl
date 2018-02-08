variables: var0( 0 ) ; 
	
if CurrentBar = 1 then
	var0 = High 
else if High > var0 then 
	begin
	Plot1( High, "NewHi-Ch" ) ;
	Alert ;
	var0 = High ;
	end ;
