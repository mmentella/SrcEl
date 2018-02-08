[LegacyColorValue = true]; 

{*******************************************************************
Description	: Parabolic Long Entry 
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Input: AccelFactor(.02);
Variables: ParabolicValue(0);

ParabolicValue = Parabolic(AccelFactor);

If High <= ParabolicValue Then
	Buy ("Pblc") Next Bar at Parabolic(AccelFactor) Stop;
