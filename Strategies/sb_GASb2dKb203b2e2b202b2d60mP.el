
Inputs: NoS(2);

Inputs: LenL(25),KL(1.5),LenS(35),KS(1.5);

Inputs: TL(280),TS(360),TRS(800),STEPL(900),STEPS(1400),StopL(1900),StopS(1900);


Vars: lowerk(0,data2),upperk(0,data2),adxval(0,data2),ADXLen(21),ADXLimit(30),bounce(false),el(true),es(true);

{
lowerk = KeltnerChannel(l,lens,-ks)data2;
upperk = KeltnerChannel(h,lenl,kl)data2;
adxval = adx(adxlen)data2;
}
if barstatus(2) = 2 then begin
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 upperk = KeltnerChannel(h,lenl,kl)data2;
 adxval = adx(adxlen)data2;
end;

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
 
 if maxpositionprofit/nos > trs then begin
  if marketposition = 1 then begin
   sell("trsl") next bar at entryprice + (maxpositionprofit/nos - stepl)/bigpointvalue stop;
   bounce = lowerk < entryprice + (maxpositionprofit/nos - stepl)/bigpointvalue;
  end;
  if marketposition = -1 then begin
   buytocover("trss") next bar at entryprice - (maxpositionprofit/nos - steps)/bigpointvalue stop;
   bounce = upperk > entryprice - (maxpositionprofit/nos - steps)/bigpointvalue;
  end;
 end;
 
 if currentcontracts = nos and nos >= 2 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl point limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts point limit;
 end;
 
 if adxval < adxlimit and bounce = false and TradesToday(d) < 1 then begin
  if el then buy nos shares next bar at upperk stop;
  if es then sellshort nos shares next bar at lowerk stop;
 end;
  
end;
