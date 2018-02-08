Inputs: NoS(2),LenL(25),KL(1.5),LenS(35),KS(1.5);
Inputs: TL(280),TS(360),TRS(800),STEPL(900),STEPS(1400),StopL(1900),StopS(1900);

Vars: lowerk(0,data2),upperk(0,data2),adxval(0,data2),ADXLen(21),ADXLimit(30),bounce(false),el(true),es(true);

lowerk = KeltnerChannel(l,lens,-ks)data2;
upperk = KeltnerChannel(h,lenl,kl)data2;
adxval = adx(adxlen)data2;

bounce = false;
es = false;
el = false;

if marketposition = 0 then begin
 if marketposition(1) = 0 then begin el = true; es = true; end;
 if marketposition(1) <> 0 then begin
  el = marketposition(1) = -1;
  es = marketposition(1) = 1;
 end;
end;
if marketposition = 1 then es = true;
if marketposition = -1 then el = true;

if time > 800 and time < 2230 then begin
 
 if marketposition <> 0 then begin
  setstopshare;
  if marketposition = 1 then setstoploss(stopl);
  if marketposition = -1 then setstoploss(stops);
 end;
 
 if maxcontractprofit > trs then begin
  if marketposition = 1 then begin
   sell("trsl") next bar at entryprice + (maxcontractprofit-stepl)/bigpointvalue stop;
   bounce = lowerk < entryprice + (maxcontractprofit-stepl)/bigpointvalue;
  end;
  if marketposition = -1 then begin
   buytocover("trss") next bar at entryprice - (maxcontractprofit-steps)/bigpointvalue stop;
   bounce = upperk > entryprice - (maxcontractprofit-steps)/bigpointvalue;
  end;
 end;
 
 if currentcontracts = nos and nos >= 2 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl point limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts point limit;
 end;
 
 if adxval < adxlimit then begin
  if el then
   if c > upperk then
    buy nos shares next bar at market;
  if es then
   if c < lowerk then
    sellshort nos shares next bar at market;
 end;
  
end;
