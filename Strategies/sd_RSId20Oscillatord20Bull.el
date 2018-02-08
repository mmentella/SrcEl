[LegacyColorValue = true]; 

{*******************************************************************
Description	: RSI Oscillator Long Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: RSILength(10), OverSold(30);

If Currentbar > 1 AND RSI(Close, RSILength) Cross Over OverSold Then
	Buy ("RSI") This Bar on Close;
