variables: var0( 0 ) ; 
	
if CurrentBar = 1 then
	var0 = Low 
else if Low < var0 then 
	begin
	Plot1( Low, "NewLo-Ch" ) ;
	Alert ;
	var0 = Low ;
	end ;
