[LegacyColorValue = TRUE];

{***************************************

 Written by:Emilio jan05

 Description: identifies tops based on DMIs extreme 

****************************************}

Input: 	fast(5), slow(13), extrsl(25), extrfs(50);
Variables: emiplussl(0), emiminussl(0),emiplusfa(0), emiminusfa(0);

emiplussl=DMIPLUS(slow);
emiminussl=DMIMINUS(slow);
emiplusfa=DMIPLUS(fast);
emiminusfa=DMIMINUS(fast);

condition1 = ((emiplussl-emiminussl) >extrsl) AND (((emiplusfa-emiminusfa)) >extrfs);



{ To Do Step 2 of 3: Replace "Signal Name" with a short description of the signal.}

If Condition1 Then
	Sell ("Stress-SH") Next Bar at Open;





