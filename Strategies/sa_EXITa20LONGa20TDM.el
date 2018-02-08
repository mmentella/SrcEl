[LegacyColorValue = TRUE];

{***************************************

 Written by:Mirko

 Description:After entering on the 5th candle, I'll exit if setup isn't confirmed
****************************************}


{ To Do Step 1 of 3: Replace <condition> with the criteria that will cause a exit order.}

Condition1 = c < c[4] or barssinceentry = 4;

If Condition1 Then
	ExitLong ("closeL") Next Bar at open;





