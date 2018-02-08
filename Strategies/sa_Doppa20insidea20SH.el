[LegacyColorValue = TRUE];


{***************************************

Written by: Emi 27gen05

 Description: after a double inside check, generates an entry in the mkt breakout direction

****************************************}
Condition1 = H[1] < H[2];

Condition2 = H[2] < H[3];

Condition3 = L[1] > L[2];

Condition4 = L[2] > L[3];

{******* UP move breakout *******}
Condition5 = C < L[1];

If Condition1 AND COndition2 AND Condition3 AND Condition4 AND Condition5 Then
	Sell ("SH-inside") this bar at C;
