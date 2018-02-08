Input: Nos(2), Length(28),Tim1(830),Tim2(2200), StopLossL(800), StopLossS(1200), BRK(1000), Soglia(4000);

vars: loop(0),loop1(0),canplot(true),hh(0),ll(0),canshort(false),canlong(false), n(0), level(0);

array: ahigh[50](0),alow[50](0);

if date <> date[1] then begin canplot = true; end;

canshort = false;
canlong = false;


if time > 800 and time < 2300 then begin
 setstopshare;
 if marketposition = 1 then setstoploss(stoplossL);
 if marketposition = -1 then setstoploss(stoplossS);
 
 if marketposition = 0 then begin
  if marketposition(1) = 0 then begin canshort = true; canlong = true; end;
  if marketposition(1) = 1 then canshort = true;
  if marketposition(1) = -1 then canlong = true;
 end;
 if marketposition = 1 then canshort = true;
 if marketposition = -1 then canlong = true;
end;

if time >= tim1 and time < 2230 then begin
 
 if canplot then begin
  canplot = false;
  for loop = 0 to length - 1 begin
   ahigh[loop] = h[loop];
   alow[loop] = l[loop];
  end;
  SortArray(ahigh,length,1);
  SortArray(alow,length,-1);
 end;//canplot
 
 hh = ahigh [2];
 ll = alow[2];
 
 if TradesToday(d) < 1 then begin
  if canlong then buy("long") nos shares next bar at hh stop;
  if canshort then sellshort("short") nos shares next bar at ll stop;
 end;
 
 //Breakeven
 if marketposition = 1 then begin
 if maxcontractprofit > BRK then sell("brkl") next bar at entryprice + .01 stop;
 end;
 if marketposition = -1 then begin
  if maxcontractprofit > BRK then buytocover("brks") next bar at entryprice - .01 stop;
 end;
 
   
 if currentcontracts = nos and maxcontractprofit >= (Soglia) then begin 
  if marketposition = 1 then sell("trgL1") nos/2 shares next bar at entryprice + (maxcontractprofit-2000)/bigpointvalue stop;
  if marketposition = -1 then buytocover("trgS") nos/2 shares next bar at entryprice - (maxcontractprofit-2000)/bigpointvalue stop;
 end;

 
end;

//setexitonclose;
