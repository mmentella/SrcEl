[LegacyColorValue = true]; 

{*******************************************************************
Description	: Moving Average Crossover (2 Line) Long Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Price(Close), FastLen(9), SlowLen(18);

If CurrentBar > 1 AND AverageFC(Price, FastLen) Crosses Above AverageFC(Price, SlowLen) Then
	Buy ("MAC") This Bar on Close;
