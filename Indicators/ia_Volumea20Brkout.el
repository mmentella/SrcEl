inputs: AvgLength( 50 ), BrkOutPct( 50 ) ;
variables: var0( 1 + BrkOutPct * .01 ) ;

if BarType >= 2 and BarType < 5 then                             
	Condition1 = Volume >= Average( Volume, AvgLength ) * var0
else                                                                              
                                                                                 
	Condition1 = Ticks >= Average( Ticks, AvgLength ) * var0 ;

if Condition1 then 
	begin
	Plot1( High, "VolBrkOut" ) ;
	Alert ;
	end ;
