[LegacyColorValue = true]; 

{*******************************************************************
Description	: Morning Star Pattern
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), NBars(3);

If CountIF(MorningStar(Length), NBars) > 0 Then 
	Buy ("MS") Next Bar at High Stop;
