[LegacyColorValue = true]; 

{*******************************************************************
Description	: Darak Cloud Pattern
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), NBars(3);

If CountIF(DarkCloud(Length), NBars) > 0 Then 
	Sell Short ("DC") Next Bar at Low Stop;
