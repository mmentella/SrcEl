[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 29gen05

 Description: solo AP solo sul M5 (cross e bias) e M10 (solo bias)
****************************************}

Variables: Mom.d1(00,Data1), Mom.d2(00,Data2), Bias.d1(0),Bias.d2(0),FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9);

{Inputs: RSILength(5), Oversold(24), ADXlength(13), ADXlimit(32);

Condition1 = (ADX(ADXlength)of Data1 <ADXlimit) AND RSI(Close, RSILength) of Data1 Cross above Oversold;}

Mom.d1 = MACD(Close, FastMovAvg, SlowMovAvg) of Data1;
Mom.d2 = MACD(Close, FastMovAvg, SlowMovAvg) of Data2;

Bias.d1 = XAverage(Mom.d1, MACDMovAvg)[1];
Bias.d2 = XAverage(Mom.d2, MACDMovAvg)[1];

	Condition2 = (CurrentBar > 2) AND (Mom.d1 >= Bias.d1) AND (Mom.d1 cross Above 0);
		
	Condition3 = (Mom.d2 > Bias.d2);
	

If (Condition2 AND Condition3) Then
	Buy ("APemi-lo")  this Bar at Close;
