[LegacyColorValue = TRUE];

Input: lenL(4), LenS(4), Nos(1);

{nos = (300000 + netprofit) / (C * Bigpointvalue)};

Condition1 = (percentr(lenl) < 20);
Condition2 = (percentr(lenl) > 80);
Condition3 = (C > Average(C, 200));

condition4 = (percentrs(lens) > 80);
condition5 = (percentrs(lens) < 20);
condition6 = (C < Average(C, 200));

If Condition1 and Condition3 Then Buy ("%rl") nos shares next bar at market;
If Condition4 and Condition6 Then sellshort ("%rs") nos shares next bar at market;
If Condition2 Then sell ("Exl") from entry ("%rl") this bar on C;
If Condition5 Then buytocover ("Exs") from entry ("%rs") this bar on C;
