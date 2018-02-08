[LegacyColorValue = true]; 

{****************************************************DAX-***********************************************}
Vars: congestion(true), Len(30), len2(14), len3(15), value(21), xvalue(.301), stops(1.004), stopl(.996);

if (MidStr(UpperStr(GetSymbolName), 1, 3) = UpperStr("DAX") 
or MidStr(UpperStr(GetSymbolName), 1, 2) = UpperStr("AX"))then begin
   congestion = (C = C[1] + squareroot(h)) or (C = C[1] - squareroot(l));
   condition1 = T < T[1];
   IF condition1 Then value1 = 1;
   if T > T[1] Then value1 = value1+1;
   if T < T[1] Then value2 = Lowest(L, Len);
   if T < T[1] Then value3 = Highest(H, Len);

condition2 = H[1] <> Highest(H, VALUE1);
condition3 = L[1] <> Lowest(L, VALUE1);
condition4 = Highest(H, 3) = Highest(H, VALUE1);
condition5 = Lowest(L, 3) = Lowest(L, VALUE1);

if (T >= 1100 and T <=1200) OR  (T >= 1400 and T < 1900) 
and adx(len2) < value Then Begin
    if O = C or absvalue(O - C) <= range * (xvalue) 
    and congestion = false Then Begin
        if Marketposition = 0 Then Begin
           if condition2 = true 
           and condition4 = false Then Buy next bar at Highest(H, len3) + squareroot(avgtruerange(5)) points Stop;
           if condition3 = true 
           and condition5 = false Then Sell Short next bar at Lowest(L, len3) - squareroot(avgtruerange(5)) points Stop;
           if condition2 
           and condition4 Then Buy next bar at Highest(H, VALUE1) + squareroot(avgtrueRANGE(5)[1]*2) points Stop;
           if condition2 
           and condition5 Then Sell Short next bar at Lowest(L, VALUE1) - squareroot(avgtrueRANGE(5)[1]*2) points Stop;
       end;
       end;
end;

if Marketposition = +1 
and BARSSINCEENTRY >=1 Then Sell Next Bar  at maxlist(Lowest(L, 4), lowest(l, 4)[1], lowest(l, 3)[2]) - MAXLIST(squareroot(range), SQUAREROOT(range[1])) Points Stop;
if Marketposition = -1 
and BARSSINCEENTRY >=1 Then Buy to Cover Next Bar  at minlist(Highest(H, 4), highest(h, 4)[1], highest(h, 3)[2]) + MINLIST(squareroot(range), SQUAREROOT(range[1])) Points Stop;

if Marketposition = +1 Then Begin
	IF BARSSINCEENTRY > 2 then Sell Next Bar  at maxlist((lowest(L, 3)-(range[1]/2)),(lowest(L, 3)-(range[1]/2)[1]),(lowest(L,3)-(range[1]/2)[2])) STOP;
	{IF BARSSINCEENTRY >= 1 AND maxpositionprofit>=((range[1]/2)+ABSVALUE(RANGE-RANGE[1])) and OPENPOSITIONPROFIT>=50 THEN EXITLONG AT ENTRYPRICE+20 STOP;}
	IF BARSSINCEENTRY > 2 then Sell Next Bar  at entryprice*stops STOP;
end;

if Marketposition = -1 Then Begin
	IF BARSSINCEENTRY > 2 Then Buy to Cover Next Bar  at minlist((Highest(H, 3)+(range[1]/2)),(Highest(H, 3)+(range[1]/2))[1],(Highest(H, 3)+(range[1]/2)[2]))STOP;
	{IF BARSSINCEENTRY>=1 AND maxpositionprofit >=((range[1]/2)-ABSVALUE(RANGE-RANGE[1])) and OPENPOSITIONPROFIT>=50 THEN EXITSHORT AT ENTRYPRICE-20 STOP;}
	IF BARSSINCEENTRY > 2 Then Buy to Cover Next Bar  at entryprice*stopl STOP;
end;

If T = 2100 Then Begin
	if marketposition = 1 Then Sell Next Bar  at market;
	if marketposition = -1 then Buy to Cover Next Bar  at market;
end;
end;
