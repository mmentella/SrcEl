inputs: Price( Low ), LeftStrength( 3 ), RightStrength( 3 ) ;

condition1 = PivotLowVSBar( 1, Price, LeftStrength, RightStrength, RightStrength + 1 ) <> -1 ;
if condition1 
 then 
	begin
	Plot1[RightStrength]( Low[RightStrength], "PivotLo" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
