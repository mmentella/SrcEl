[LegacyColorValue = true]; 

{*******************************************************************
Description	: Hammer Pattern 
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: Length(5), Tail(2), NBars(3);

If CountIF(Hammer(Length, Tail), NBars) > 0 Then 
	Buy ("Hmr") Next Bar at High Stop;
