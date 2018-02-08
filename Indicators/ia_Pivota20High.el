inputs: Price( High ), LeftStrength( 3 ), RightStrength( 3 ) ;

condition1 = PivotHighVSBar( 1, Price, LeftStrength, RightStrength, RightStrength + 1 ) <> -1 ;
if condition1 
 then 
	begin
	Plot1[RightStrength]( High[RightStrength], "PivotHi" ) ;
	Alert ;
	end
else
	NoPlot( 1 ) ;
