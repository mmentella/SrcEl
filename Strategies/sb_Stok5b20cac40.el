[LegacyColorValue = TRUE];

{*************************************************
EM_Stock 1.1.
Copyright Enrico Malverti 2008
www.enricomalverti.com
*****************************************************}

{[intrabarordergeneration = true]}

Input: Len(8), Mov(100), Nos(2), MaxstopL(0.99), MaxstopS(1.01);
Var: MXL(0), MXS(0), flag(false), 
 tgl(0), tgs(0);

{nos = (75000 {+ netprofit}) / (C * Bigpointvalue)};
if d <> d[2] then flag = true else
if D = D[1] then if barssinceexit(0) > 1 then flag = true else flag = false;
MXL = entryprice*MaxstopL;
MXS = entryprice*MaxstopS;
tgl = entryprice + 2.7*avgtruerange(5) data2;  
tgs = entryprice - 3*avgtruerange(5) data2; 
Condition1 = (FastK(Len) data2 < 20);
Condition2 = (FastK(Len) data2 > 80);
Condition3 = (C data2 > Average(C, Mov) data2);
condition4 = (FastK(Len) data2 > 80);
condition5 = (FastK(Len) data2 < 20);
condition6 = (C data2 < Average(C data2, Mov));

If marketposition(0) <> 1 and flag = true and T >= sess1starttime  then if Condition1 
and Condition3 Then Buy ("Buy1") nos shares next bar at market;
if marketposition(0) <> -1 and flag = true and T >= sess1starttime then If Condition4 
and Condition6 and O < closed(1) Then sellshort ("Sell1") nos shares next bar at market;

If Condition2 Then sell ("ExL") from entry ("Buy1") next bar at open;
If Condition5 Then buytocover("ExS") from entry ("Sell1") next bar at open;

if marketposition = 1 and d >= d[1] then sell ("tgl") currentcontracts/2 shares next bar at tgl Limit;
if marketposition = -1 and d >= d[1] then buytocover ("tgs") currentcontracts/2 shares next bar at tgs Limit;

if T > sess1firstbartime and T <= 2050 then begin
if marketposition = 1 and d >= d[1] then sell ("MXL") next bar at MXL stop;
if marketposition = -1 and d >= d[1] then buytocover ("MXS") next bar at MXS stop;
end;
