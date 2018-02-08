Inputs: NoS(2),LenL(5),KL(2),LenS(17),KS(2),ADXLen(16),ADXLimit(25);
Inputs: StopLoss(900),BRKL(1600),BRKS(600),TL(2200),TS(2000),TRSL(3400),TRSS(3100),XL(500),XS(700);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0),mp(0),trade(true);

if barstatus(2) <> 1 and barstatus(2) <> 0 then begin

mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;
if barstatus(2) = 2 then trade = true;

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;

if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
 
 //BREAKEVEN
 if mpp > brkl/bigpointvalue and marketposition = 1 then
  sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
 if mpp > brks/bigpointvalue and marketposition = -1 then
  buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
 
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
 end;
 
 //TRAILING STOP
 if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
 if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
 
 //STOPLOSS
 setstopshare;
 setstoploss(stoploss);
 if marketposition = 1 then sell("xl") next bar at entryprice - xl/bigpointvalue stop;
 if marketposition = -1 then buytocover("xs") next bar at entryprice + xs/bigpointvalue stop;
 
end;

//ENGINE
if adxval < adxlimit and trade then begin
 if marketposition < 1 and c data2 < upperk and c < upperk then 
  buy nos shares next bar at upperk stop;
 if marketposition > -1 and c data2 > lowerk and c > lowerk then
  sellshort nos shares next bar at lowerk stop;
end;

end;
