[LegacyColorValue = TRUE];

{***************************************

 Written by: Emi 26gen05

 Description: EMAs crossing each other for LONG signal

****************************************}



Inputs: length1(8),length2(13);
Variables: EMA1(0),EMA2(0);



{ To Do Step 1 of 2: Replace <condition> with the criteria that will cause a buy order.}

EMA1 = XAverage(Close, length1);
EMA2 = XAverage(Close, length2);

Condition1 = CurrentBar > 2 AND  EMA1 Crosses Above EMA2;


{ To Do Step 1 of 2: Replace "Signal Name" with a short description of the signal.}

If Condition1 Then
	Buy ("EMAsLO") Next Bar at Open;





