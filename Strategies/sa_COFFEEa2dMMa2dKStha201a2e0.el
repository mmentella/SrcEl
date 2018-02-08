Inputs: NoS(4),LenL(53),KL(1.92),LenS(5),KS(1.96),ADXLen(14),ADXLimit(30),alfa(.2);
Inputs: StopL(800),StopS(1000),MinMCP(30),BRK(800),TL(1900),TS(800),TL1(5200),TS1(4100);

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

//TIME STOPLOSS
if d >= entrydate + 1 and mcp < minmcp/bigpointvalue then begin
 if marketposition = 1 then sell("xl.tout.s") this bar on close;
 if marketposition = -1 then buytocover("xs.tout.s") this bar on close;
end;
 
//BREAK EVEN
if mcp > brk/bigpointvalue then begin
 if marketposition = 1 then sell("xl.brk.s") next bar at entryprice + 100/bigpointvalue stop;
 if marketposition = -1 then buytocover("xs.brk.s") next bar at entryprice - 100/bigpointvalue stop;
end;

//MODAL EXIT
if currentcontracts = nos and nos > 1 then begin
 if marketposition = 1 then sell("xl.mod1.s") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
 if marketposition = -1 then buytocover("xs.mod1.s") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
end;

if currentcontracts = nos/2 then begin
 if marketposition = 1 then setprofittarget(tl1);
 if marketposition = - 1 then setprofittarget(ts1);
end;
  
end;

//ENGINE
if adxval < adxlimit and t < 2000 then begin
 if marketposition < 1 and c < upperk then
  buy("el.s") nos shares next bar at upperk stop;
 if marketposition > -1 and c > lowerk then
  sellshort("es.s") nos shares next bar at lowerk stop;
end;
