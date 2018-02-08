inputs:
	Price( Close ),
	BaseLength( 10 ),
	ArithOrGeom_1or2( 1 ),
	IncrementOrMultiplier( 10 ),                                                     
	                                            
	FastColor( Yellow ),
	SlowColor( Red ) ;

variables:
	var0( 0 ) ;

arrays:
	arr0[8]( 0 ),
	arr1[8]( 0 ),
	arr2[8]( 0 ),
	arr3[8]( 0 ) ;

                                                                                     
                
if CurrentBar = 1 then
	begin
 	arr0[1] = BaseLength ;
	arr1[1] = 2 / ( arr0[1] + 1 ) ;
	arr2[1] = Price ;
	arr3[1] = GradientColor( 1, 1, 8, FastColor, SlowColor ) ;
	for var0 = 1 to 7
		begin
		if ArithOrGeom_1or2 = 1 then
			arr0[ var0 + 1 ] = arr0[var0] + IncrementOrMultiplier
		else
			arr0[ var0 + 1 ] = arr0[var0] * IncrementOrMultiplier ;
		arr1[ var0 + 1 ] = 2 / ( arr0[ var0 + 1 ] + 1 ) ;
		arr2[ var0 + 1 ] = Price ;
		arr3[ var0 + 1 ] = GradientColor( var0 + 1, 1, 8, FastColor,
		 SlowColor ) ;
		end ;
	end
else
	                                                   
	for var0 = 1 to 8
		begin
		arr2[var0] = arr2[var0][1] + arr1[var0] * ( Price -
		 arr2[var0][1] ) ;
		end ;

                       
Plot1( arr2[1], "XMA1", arr3[1] ) ;
Plot2( arr2[2], "XMA2", arr3[2] ) ;
Plot3( arr2[3], "XMA3", arr3[3] ) ;
Plot4( arr2[4], "XMA4", arr3[4] ) ;
Plot5( arr2[5], "XMA5", arr3[5] ) ;
Plot6( arr2[6], "XMA6", arr3[6] ) ;
Plot7( arr2[7], "XMA7", arr3[7] ) ;
Plot8( arr2[8], "XMA8", arr3[8] ) ;
