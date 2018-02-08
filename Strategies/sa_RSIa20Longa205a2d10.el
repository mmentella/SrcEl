[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 24gen05

 Description: uses two timeframes RSI oversold positions to generate the signal

****************************************}
Variables: RSI.d1(00,Data1), RSI.d2(00,Data2);
Inputs: RSILength(5), OverS1(20),OverS2(30);

RSI.d1 = RSI(C,RSILength) of Data1;
RSI.d2 = RSI(C,RSILength) of Data2;

Condition1 = RSI.d1 Cross Over OverS1;
Condition2 = RSI.d2 Cross Over OverS2;

If (Condition1 AND Condition2) Then
	Buy ("RSI L(5/10)") this Bar at C;
