[LegacyColorValue = TRUE];


{***************************************

Written by: Emi 31gen05

 Description: doppio controllo di vola al ribasso

****************************************}

Inputs: ADXlimit(20),lgavg(200);
variable: ADXlength(13);

condition1 = MirkoFvola cross below Xaverage(MirkoFvola,lgavg);
condition2 = ADX(ADXlength) < ADXlimit;


If (Condition1 AND Condition2) Then
	{Alert("Volatility going DOWN (decreasing");}
Sell ("vola-decr") at C;
