[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 20gen05

 Description: if ADX is weak, uses RSI oversold

****************************************}


Vars:BarNum(0);
                      

Inputs: RSILength(5), OverSold(24), ADXlength(13), ADXlimit(31);

Condition1 = ADX(ADXlength)<ADXlimit;

Condition2 = RSI(Close, RSILength) Cross Over OverSold;


						   	
						   
If (Condition1 AND Condition2) Then
	Buy ("SD-up") next Bar at Open;
