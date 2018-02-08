Inputs: nos(2),lenl(3),kl(0.15),lens(6),ks(3.46),adxlen(22),adxlimit(30),alfa(.2);
Inputs: stoploss(1400),tl(3400),ts(2200),tl1(8600),ts1(17600);

Vars: upperk(0),lowerk(0),adxval(0),mpp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen);

mpp = MM.MaxContractProfit;

if t > 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  setstopshare;
  
  //STOPLOSS
  setstoploss(stoploss);
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
  
  //PROFIT TARGET
  if currentcontracts = nos/2 then begin
   if marketposition = 1 then begin
    setprofittarget(tl1);
    sell("xl") next bar at entryprice + 100/bigpointvalue stop;
   end;
   if marketposition = -1 then begin
    setprofittarget(ts1);
    buytocover("xs") next bar at entryprice - 100/bigpointvalue stop;
   end;
  end;
 
 end;
 
  
 //ENGINE
 if adxval < adxlimit{ and TradesToday(d) = 0 }then begin
  if marketposition < 1 and c < upperk and range < AvgTrueRange(lenl) then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk and range < AvgTrueRange(lens) then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
 
end;
