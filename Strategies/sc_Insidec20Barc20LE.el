[IntrabarOrderGeneration = false]
condition1 = High < High[1] and Low > Low[1] and Close > Open ;
if condition1 then
		Buy ( "InsBarLE" ) next bar at market ;
