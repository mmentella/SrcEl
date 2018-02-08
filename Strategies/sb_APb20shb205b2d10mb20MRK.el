[LegacyColorValue = TRUE];


{***************************************

Written by: Emi 28gen05

 Description: secondo regole di Mirko
                                     _____
****************************************}
Inputs: Trlun(34),Envlung(9);
Variables: Mom.d1(00,Data1), Mom.d2(00,Data2), Tr(0),En(0),FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9);



Mom.d1 = MACD(Close, FastMovAvg, SlowMovAvg) of Data1;
Mom.d2 = MACD(Close, FastMovAvg, SlowMovAvg) of Data2;

	Condition1 = (CurrentBar > 2) AND (Mom.d1 <= XAverage(Mom.d1, MACDMovAvg)[1]) AND (Mom.d1 crosses below 0);
		
	Condition2 = (Mom.d2 < XAverage(Mom.d2, MACDMovAvg)[1]);
	
	Condition3 = (Mom.d2 < 0);

If Condition1 AND Condition2 AND Condition3 Then
Sell ("AP-MRK-Sh 5/10") next Bar on Open;
