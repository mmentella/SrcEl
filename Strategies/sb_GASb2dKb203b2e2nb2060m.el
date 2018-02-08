Inputs: NoS(2),LenL(25),KL(1.5),LenS(35),KS(1.5),SOD(900),EOD(2300);
Inputs: TL(280),TS(360),TRS(800),STEPL(900),STEPS(1400),StopLoss(1800);

Vars: lowerk(0),upperk(0),adxval(0),ADXLen(21),ADXLimit(30);
Vars: bounce(false),el(false),es(false);


lowerk = KeltnerChannel(l,lens,-ks);
upperk = KeltnerChannel(h,lenl,kl);
adxval = adx(adxlen);

bounce = false;
el = marketposition < 1;
es = marketposition > -1;

if time > sod and time < eod then begin
 
 if marketposition <> 0 then begin
  setstopshare;
  setstoploss(stoploss);
 end;
 
 if maxcontractprofit > trs then begin
  if marketposition = 1 then begin
   sell("trsl") next bar at entryprice + (maxcontractprofit -stepl)/bigpointvalue stop;
   bounce = lowerk < entryprice + (maxcontractprofit -stepl)/bigpointvalue;
  end;
  if marketposition = -1 then begin
   buytocover("trss") next bar at entryprice - (maxcontractprofit -steps)/bigpointvalue stop;
   bounce = upperk > entryprice - (maxcontractprofit -steps)/bigpointvalue;
  end;
 end;
 
 if currentcontracts = nos and nos >= 2 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl point limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts point limit;
 end;
 
 if marketposition = 1 then
  if bounce = false then bounce = lowerk < entryprice - (1/bigpointvalue)*stoploss;
 if marketposition = -1 then
  if bounce = false then bounce = upperk > entryprice + (1/bigpointvalue)*stoploss;
 
 if adxval < adxlimit then begin
  if el and bounce = false then buy nos shares next bar at upperk stop;
  if es and bounce = false then sellshort nos shares next bar at lowerk stop;
 end;
  
end;
