[LegacyColorValue = TRUE];

{***************************************

 Written by: Emi 19gen05

 Description: EMA crssing over buy signal

****************************************}



Inputs: length(34);
Variables: XMACD(0);



{ To Do Step 1 of 2: Replace <condition> with the criteria that will cause a buy order.}

Condition1 = CurrentBar > 2 AND  Close Crosses Above XAverage(Close, length);


{ To Do Step 1 of 2: Replace "Signal Name" with a short description of the signal.}

If Condition1 Then
	Buy ("T BUY") Next Bar at Open;





