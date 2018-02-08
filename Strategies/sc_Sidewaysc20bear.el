[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 20gen05

 Description: if ADX is weak, uses RSI overbought

****************************************}

Inputs: RSILength(5), OverBought(79), ADXlength(13), ADXlimit(32);

Condition1 = ADX(ADXlength)<ADXlimit;

Condition2 = RSI(Close, RSILength) Cross Below OverBought ;

If (Condition1 AND Condition2) Then
	Sell ("SD-down") next Bar at Open;
