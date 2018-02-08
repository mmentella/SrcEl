[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 29gen05

 Description:  AP solo sul M5 (cross e bias) e M10 (solo bias) e bucatura del SAR
****************************************}
Inputs: AccelFactor(.02);
Variables: ParabolicValue(0),Mom.d1(00,Data1), Mom.d2(00,Data2),Bias.d1(0),Bias.d2(0),FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9);

ParabolicValue = Parabolic(AccelFactor);


Mom.d1 = MACD(Close, FastMovAvg, SlowMovAvg) of Data1;
Mom.d2 = MACD(Close, FastMovAvg, SlowMovAvg) of Data2;

Bias.d1 = XAverage(Mom.d1, MACDMovAvg)[1];
Bias.d2 = XAverage(Mom.d2, MACDMovAvg)[1];

Condition1 =  High <= ParabolicValue; 
	
Condition2 = (CurrentBar > 2) AND (Mom.d1 >= Bias.d1) AND (Mom.d1 cross above 0);
		
Condition3 = (Mom.d2 > Bias.d2);
	
If (Condition1 AND Condition2 AND Condition3) Then
	
	Buy ("AP-sar LO") Next Bar at ParabolicValue Stop;
