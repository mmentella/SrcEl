[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 19gen05

 Description: EMA <P + MACD neg.

****************************************}
Inputs: FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9), length(34);
Variables: XMACD(0);

{ To Do Step 1 of 2: Replace <condition> with the criteria that will cause a buy order.}


Condition1 = MACD(Close, FastMovAvg, SlowMovAvg) Crosses Below 0;
Condition2 = Close < XAverage(Close, length);


If (Condition1 AND Condition2) Then
	Sell ("M neg.") Next Bar at Open;
