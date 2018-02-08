Inputs: NoS(2),LenL(22),KL(1.5),LenS(35),KS(1.5);
Inputs: TL(280),TS(360),TRS(800),STEPL(1400),STEPS(1400),StopL(1900),StopS(1900);

Vars: lowerk(0,data2),upperk(0,data2),adxval(0,data2),ADXLen(21),ADXLimit(30),
      bounce(false),el(true),es(true);

lowerk = KeltnerChannel(l,lens,-ks)data2;
upperk = KeltnerChannel(h,lenl,kl)data2;
adxval = adx(adxlen)data2;

bounce = false;
es = false;
el = false;

es = marketposition > -1;
el = marketposition < 1;

if time > 800 and time < 2230 then begin
 
 if marketposition <> 0 then begin
  setstopshare;
  if marketposition = 1 then setstoploss(stopl);
  if marketposition = -1 then setstoploss(stops);
  
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
  
 end;
 
 if currentcontracts = nos and nos >= 2 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl point limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts point limit;
 end;
 
 if marketposition = 1 then
  if bounce = false then bounce = lowerk < entryprice - (1/bigpointvalue)*stopl;
 if marketposition = -1 then
  if bounce = false then bounce = upperk > entryprice + (1/bigpointvalue)*stops;
 
 if adxval < adxlimit then begin
  if el and bounce = false then buy nos shares next bar at upperk stop;
  if es and bounce = false then sellshort nos shares next bar at lowerk stop;
 end;
  
end;
