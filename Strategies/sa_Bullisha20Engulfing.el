[LegacyColorValue = true]; 

{*******************************************************************
Description	: Bullish Engulfing Pattern
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), NBars(3);

If CountIF(BullishEngulfing(Length), NBars) > 0 Then 
	Buy ("BE") Next Bar at High Stop; 
