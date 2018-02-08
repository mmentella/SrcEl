[LegacyColorValue = TRUE];

{***************************************

 Written by:Mirko

 Description:we suppose to enter on the candle number 5 of the setup (in the direction of the trend

****************************************}

{ To Do Step 1 of 3: Replace <condition> with the criteria that will cause a buy order.}

Condition1 = C >= C[4] and C[1] >= C[5] and C[2] > C[6] and C[3] > C[7];


{ To Do Step 2 of 3: Replace "Signal Name" with a short description of the signal.}

{ To Do Step 3 of 3: Replace <price> with the value of your limit order.}

If Condition1 Then
	Buy ("buy") Next Bar at open;
