Inputs: NoS(2),LenL(32),KL(1.88),LenS(16),KS(1.99),ADXLen(14),ADXLimit(30);
Inputs: StopLoss(1000),TL(1200),TS(1700),TL1(14000),TS1(10000);

Vars: upperk(0),lowerk(0),adxval(0),mpp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

upperk = .2*upperk + .8*upperk[1];
lowerk = .2*lowerk + .8*lowerk[1];

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

if time > 800 and time < 2200 then begin
 
 if marketposition <> 0 then begin
 
  //STOPLOSS
  setstopshare;
  setstoploss(stoploss);
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
  
  if currentcontracts = nos/2 then begin
   if marketposition = 1 then begin
    setprofittarget(tl1);
    
   end;
   if marketposition = - 1 then begin
    setprofittarget(ts1);
    
   end;
  end;
   
 end;

 //ENGINE
 if adxval < adxlimit then begin
  if marketposition < 1 and c < upperk and range < AvgTrueRange(lenl) then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk and range < AvgTrueRange(lens) then
   sellshort("short") nos shares next bar at lowerk stop;
 end;

end;
