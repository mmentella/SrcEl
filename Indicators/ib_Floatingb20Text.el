inputs:
	TextToPlot( "MyText" ),                                  
 	TextBarsBack( 10 ),                                                           
	              
   	TextPricePercent( 50 ) ;                                                    
	                                                                             
  	                                                                                
	                                                

variables:
	var0( -1 ) ;

if LastBarOnChart then
	begin
	if var0 < 0 then 
		var0 = Text_New( Date, Time, Close, TextToPlot ) ;
	if var0 >= 0 then
		Value1 = Text_Float( var0, TextBarsBack, TextPricePercent ) ;
	end ;
