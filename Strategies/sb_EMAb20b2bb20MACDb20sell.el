[LegacyColorValue = TRUE];

{***************************************

Written by: Emi 19gen05

 Description: EMA crossing over buy signal + MACD sotto bias

****************************************}
Inputs: FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9), length(34);
Variables: XMACD(0);

{ To Do Step 1 of 2: Replace <condition> with the criteria that will cause a buy order.}

Condition1 = CurrentBar > 2 AND  Close Crosses Below XAverage(Close, length);
Condition2 = MACD(Close, FastMovAvg, SlowMovAvg) < XAverage(MACD(Close, FastMovAvg, SlowMovAvg), MACDMovAvg)[1];


If Condition1 AND Condition2 Then
	Sell ("T+M sh") Next Bar at Open;
