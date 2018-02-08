Inputs: NoS(2),LenL(53),KL(2),LenS(5),KS(1.96),ADXLen(14),ADXLimit(30),alfa(.2);
Inputs: StopL(800),StopS(1100),BRK(800),TL(1900),TS(800),TL1(5200),TS1(4100),TRSL(100000),TRSS(100000);

Vars: upperk(0),lowerk(0),adxval(0),mcp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen);

mcp = MM.MaxContractProfit;
 
if marketposition <> 0 then begin

//STOPLOSS
setstopshare;
value1 = iff(marketposition=1,stopl,stops);
setstoploss(value1);
 
//BREAK EVEN
if mcp > brk/bigpointvalue then begin
 if marketposition = 1 then sell("brkl") next bar at entryprice + 50/bigpointvalue stop;
 if marketposition = -1 then buytocover("brks") next bar at entryprice - 50/bigpointvalue stop;
end;

//MODAL EXIT
if currentcontracts = nos and nos > 1 then begin
 if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
 if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
end;

//TRAILING STOP
sell("trsl") next bar at entryprice + (mcp - trsl/bigpointvalue) stop;
buytocover("trss") next bar at entryprice - (mcp - trss/bigpointvalue) stop;
 
if currentcontracts = nos/2 then begin
 if marketposition = 1 then setprofittarget(tl1);
 if marketposition = - 1 then setprofittarget(ts1);
end;
  
end;

//ENGINE
if adxval < adxlimit then begin
 if marketposition < 1 and c < upperk then
  buy("long") nos shares next bar at upperk stop;
 if marketposition > -1 and c > lowerk then
  sellshort("short") nos shares next bar at lowerk stop;
end;

//Inputs: StopL(800),StopS(1100),BRK(800),TL(1900),TS(800),TL1(5200),TS1(4100),TRSL(100000),TRSS(100000);
