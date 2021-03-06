Inputs: NoS(2),LenL(19),KL(2.07),LenS(6),KS(4.85),ADXLen(24),ADXLimit(24);
Inputs: StopL(490),StopS(1700),BRKL(700),BRKS(700),TL(3100),TS(1900),TRSL(2100),TRSS(2900);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0),yc(0);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;

if d <> d[1] then yc = c[1];

if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
end;

if d = entrydate then yc = entryprice;

if time > 800 and time < 2200 then begin
 
 if marketposition <> 0 then begin
  
  //STOPLOSS
  setstopshare;
  if marketposition = 1 then begin
   setstoploss(stopl);
  end;
  if marketposition = -1 then begin
   setstoploss(stops);
  end;  
  
  //BREAKEVEN
  if mpp > brkl/bigpointvalue then
   if marketposition = 1 then sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  //if mpp > brks/bigpointvalue then
   //if marketposition = -1 then buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
  
  //TRAILING STOP
  if mpp > brkl/bigpointvalue then
   if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
  //if mpp > brks/bigpointvalue then
   //if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
  
 end;

 //ENGINE
 if adxval < adxlimit and TradesToday(d) < 1 then begin
  if marketposition < 1 and c data2 < upperk and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c data2 > lowerk and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;

end;
