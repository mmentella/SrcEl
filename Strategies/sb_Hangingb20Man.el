[LegacyColorValue = true]; 

{*******************************************************************
Description	: Hanging Man Pattern
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), Tail(2), NBars(3);

If CountIF(HangingMan(Length, Tail), NBars) > 0 Then 
	Sell Short ("HM") Next Bar at Low Stop;
