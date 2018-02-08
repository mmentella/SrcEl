Inputs: NoS(4),LenL(18),KL(.71),LenS(5),KS(1.83),ADXLen(14),ADXLimit(30),SOD(800);
Inputs: StopLoss(1000),BRK(800),TL(1500),TS(1100),TRSL(1200),TRSS(200);

Vars: upperk(0),lowerk(0),adxval(0),mpp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

adxval = adx(adxlen);

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

if t > 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  //STOPLOSS
  //setstopshare;
  //setstoploss(stoploss);
  {
  if mpp > brk/bigpointvalue then begin
   if marketposition = 1 then sell("brkl") next bar at entryprice + 50/bigpointvalue stop;
   if marketposition = -1 then buytocover("brks") next bar at entryprice - 50/bigpointvalue stop;
  end;
  }
 end;
 
 //ENGINE
 if adxval < adxlimit and time > sod then begin
  if marketposition < 1 and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;

end;

//LenL(5),KL(2.1),LenS(7),KS(2),ADXLen(14),ADXLimit(30),SOD(800) 731 --- 85
//LenL(18),KL(.71),LenS(5),KS(1.83),ADXLen(14),ADXLimit(30),SOD(800) 800 --- 100
