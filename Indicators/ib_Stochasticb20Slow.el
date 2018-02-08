inputs: 
	PriceH( High ),  
	PriceL( Low ), 
	PriceC( Close ), 
	StochLength( 14 ), 
	SmoothingLength1( 3 ),                                        
	SmoothingLength2( 3 ),                                
	SmoothingType( 1 ),                                         
	OverSold( 20 ), 
	OverBought( 80 ) ; 

variables:
	var0( 0 ), 
	var1( 0 ), 
	var2( 0 ), 
	var3( 0 ) ;

Value1 = Stochastic( PriceH, PriceL, PriceC, StochLength, SmoothingLength1, 
 SmoothingLength2, SmoothingType, var0, var1, var2, var3 ) ;

Plot1( var2, "SlowK" ) ;
Plot2( var3, "SlowD") ;
Plot3( OverBought, "OverBot" ) ;
Plot4( OverSold, "OverSld" ) ;

                  
if CurrentBar > 2 then
	begin
	condition1 = var2 crosses over var3 and var2 < OverSold ;
	if condition1 then                       	               
		Alert( "SlowK crossing over SlowD" )
	else 
		begin 
		condition1 = var2 crosses under var3 and var2 > OverBought ;
		if condition1 then
			Alert( "SlowK crossing under SlowD" ) ;
		end;
	end ;
