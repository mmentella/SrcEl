inputs:
	BlockSize( 5000 ),                                      
	DataNum( 1 ) ;                                                   

variables:
	intrabarpersist var0( 0 ),
	intrabarpersist var1( 0 ) ;

condition1 = LastBarOnChart and BarStatus( DataNum ) <> 2 ;
if condition1 then                         
                                                                                  
                                                                            
                                
	begin

	if var1 <> CurrentBar then
		begin
		var0 = 0 ;
		var1 = CurrentBar ;
		end ;
	
	if TradeVolume >= BlockSize then
		var0 = var0 + 1 ;
	
	Plot1( var0, "BlockTrds" ) ;
	
	end ;
