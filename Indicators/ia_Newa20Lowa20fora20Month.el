variables: var0( 0 ) ; 

if BarType < 4 then                                            
	begin
	condition1 = Month( Date ) <> Month( Date[1] ) ;
	if condition1 then
		var0 = Low 
	else if Low < var0 then 
		begin
		Plot1( Low, "NewLo-M" ) ;
		Alert ;
		var0 = Low ;
		end ;
	end ;
