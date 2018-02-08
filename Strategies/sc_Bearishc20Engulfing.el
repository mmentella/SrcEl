[LegacyColorValue = true]; 

{*******************************************************************
Description	: Bearish Engulfing Pattern
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), NBars(3);

If CountIF(BearishEngulfing(Length), NBars) > 0 Then 
	Sell Short ("BE") Next Bar at Low Stop;
