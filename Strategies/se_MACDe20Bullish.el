[LegacyColorValue = true]; 

{*******************************************************************
Description	: MACD Long Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9);
Variables: XMACD(0);

If CurrentBar > 2 AND MACD(Close, FastMovAvg, SlowMovAvg) Crosses Above XAverage(MACD(Close, FastMovAvg, SlowMovAvg), MACDMovAvg)[1] Then
	Buy ("MACD") This Bar on Close;
