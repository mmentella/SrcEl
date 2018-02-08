[LegacyColorValue = TRUE];


{***************************************

Written by: Emi 31gen05

 Description: doppio controllo di vola al RIALZO

****************************************}

Inputs: ADXlimit(34),lgavg(200);
variable: ADXlength(13);

condition1 = MirkoFvola cross above Xaverage(MirkoFvola,lgavg);
condition2 = ADX(ADXlength) > ADXlimit;


If (Condition1 AND Condition2) Then
	{Alert("Volatility going UP (Increasing");}
Buy ("vola-INCR") at C;
