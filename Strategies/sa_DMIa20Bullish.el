[LegacyColorValue = true]; 

{*******************************************************************
Description	: DMI Long Entry
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: DMILen(14), Consec(3), MinDiff(0);
Variables: DMIDiff(0);

DMIDiff = DMIPlus(DMILen) - DMIMinus(DMILen);

If DMIDiff[Consec] > 0 Then Begin
	If DMIDiff >= MinDiff AND CountIF(DMIDiff > DMIDiff[1], Consec) = Consec Then
		Buy ("DMI+") This Bar on Close;
End;
