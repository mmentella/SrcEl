condition1 = High > High[1] and Low < Low[1] ;
if condition1 then 
	begin
	Plot1( Close, "Outside" ) ;
	Alert ;
	end ;
