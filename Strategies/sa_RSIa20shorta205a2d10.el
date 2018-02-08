[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 24gen05

 Description: uses two timeframes RSI overbought positions to generate the signal

****************************************}
Variables: RSI.d1(00,Data1), RSI.d2(00,Data2);
Inputs: RSILength(5), Overb1(90),Overb2(80);

RSI.d1 = RSI(C,RSILength) of Data1;
RSI.d2 = RSI(C,RSILength) of Data2;

Condition1 = RSI.d1 Cross below Overb1;
Condition2 = RSI.d2 Cross below Overb2;

If (Condition1 AND Condition2) Then
	Sell ("RSI S(5/10)") this Bar at C;
