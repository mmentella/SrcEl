Inputs: NoS(2),Length(24),OffLen(6),BRK(1400),TRS(2500),TRSX(3000);

Vars: level(0,data2),offset(0,data2),up(0),down(0),trade(true);

if d > d[1] then begin trade = true; end;

level = XAverage(c,length) data2;
offset = XAverage(TrueRange,offlen) data2;

up = level + offset/2;
down = level - offset/2;

if mod(dayofweek(d),2) = 1 and time > 901 and trade then begin 
 if c cross above up then buy nos shares next bar at market;
 if c cross below down then sellshort nos shares next bar at market; 
end;

if marketposition = 1 then sell("xl") next bar at level stop;
if marketposition = -1 then buytocover("xs") next bar at level stop;

if maxcontractprofit > brk then begin
 if marketposition = 1 then begin
  sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  if currentcontracts = nos and nos > 1 then
   sell("trsl") nos/2 shares next bar at entryprice + (maxcontractprofit-trs)/bigpointvalue stop;
 end;
 if marketposition = -1 then begin
  buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  if currentcontracts = nos and nos > 1 then
   buytocover("trss") nos/2 shares next bar at entryprice - (maxcontractprofit-trs)/bigpointvalue stop;
 end; 
end;

setstopshare;
setprofittarget(5000);
setstoploss(2000);

if marketposition <> 0 and barssinceentry = 0 then 
 trade = false;
