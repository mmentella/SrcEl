inputs:
	DataNum( 1 ),                                                   
	UseLog( true ) ;                                                              
	                                                    
	 	
variables:
	var0( 0 ),
	intrabarpersist var1( 0 ),
	intrabarpersist var2( 0 ),
	intrabarpersist var3( 0 ),
	intrabarpersist var4( 0 ),
	intrabarpersist var5( 0 ) ;

condition1 = LastBarOnChart and BarStatus( DataNum ) <> 2 ;
if condition1 then                         
                                                                                  
                                                                            
                                
 	begin

   	var0 = Iff( BarType <= 1 or BarType >= 5, Ticks, Volume ) ;
	
	if CurrentBar > var1 then
		begin
		var2 = 0 ;
		var3 = 0 ;
		var4 = 0 ;
		var5 = 0 ;
		var1 = CurrentBar ;
		end ;
	
	if InsideBid < InsideAsk then
		begin
		if Close <= InsideBid then
			var2 = var2 + var0 - var5
		else if Close >= InsideAsk then
			var3 = var3 + var0 - var5 ; 
		end ;

	condition1 = var2 > 0 and var3 > 0 ;	
	if condition1 then
		var4 = Iff( UseLog, Log( var3 / var2 ), var3 /
		 var2 ) ;
	var5 = var0 ;

	Plot1( var4, "BAVolRatio" ) ;

	end ;

Plot2( 0, "ZeroLine" ) ;
