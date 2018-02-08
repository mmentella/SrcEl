[LegacyColorValue = TRUE];

{*******************************************************************
Description	: Evening Star Pattern
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), NBars(3);

If CountIF(EveningStar(Length), NBars) > 0 Then 
	Sell ("ES") Next Bar at Low Stop;

