[LegacyColorValue = TRUE];

{***************************************

 Written by: Emi gen05

 Description: Hikkake pattern (false day break) after an Inside Bar

****************************************}


{ To Do Step 1 of 3: Replace <condition> with the criteria that will cause a sell order.}

{***find the inside bar***}
Condition1 = High[1] < High[2] AND Low[1] > Low[2];

{***check if the inside bar has been enc. into an outside bar***}
Condition2 = High > High[1] AND Low < Low[1] AND C>Open;


{ To Do Step 2 of 3: Replace "Signal Name" with a short description of the signal.}

If Condition1 AND COndition2 Then
	Sell ("Hikkake Bearish") Next Bar at Market;





