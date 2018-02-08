Inputs: nos(2),len(20),kl(1.21),ks(1.2),diffper(20),alpha(.2);
Inputs: stopl(500),stops(900),brkl(800),brks(100),modl(2000),mods(1500),tl(4500),ts(4500),trsl(100000),trss(100000);

vars: uppk(0),lowk(0),adxval(0),mcp(0),bounce(false);

uppk = KeltnerChannel(h,len,kl);
lowk = KeltnerChannel(l,len,-ks);

uppk = alpha*uppk + (1-alpha)*uppk[1];
lowk = alpha*lowk + (1-alpha)*lowk[1];

mcp = MM.MaxContractProfit;

if marketposition <> 0 then begin
 
 //STOPLOSS
 setstopshare;
 setstoploss(iff(marketposition=1,stopl,stops)); 
 
 //PROFIT TARGET
 setprofittarget(iff(marketposition=1,tl,ts));
 
 //BREAKEVEN
 if marketposition = 1 and mcp > brkl/bigpointvalue then
  sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
 if marketposition = -1 and mcp > brks/bigpointvalue then
  buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 then sell("xl.mod.s") nos/2 shares next bar at entryprice + modl/bigpointvalue limit;
  if marketposition = -1 then buytocover("xs.mod.s") nos/2 shares next bar at entryprice - mods/bigpointvalue limit;
 end;
 
 //TRAILING STOP
 sell("xl.trl.s") next bar at entryprice + (mcp - trsl/bigpointvalue) stop;
 buytocover("xs.trl.s") next bar at entryprice - (mcp - trss/bigpointvalue) stop;
 
end;

//ENGINE
if absvalue(len-MM.DominantCyclePeriod(medianprice)) < diffper and TradesToday(d) = 0 then begin
 if marketposition < 1 and c < uppk then
  buy("el.s") nos shares next bar at uppk stop;
 if marketposition > -1 and c > lowk then
  sellshort("es.s") nos shares next bar at lowk stop;
end;

//Inputs: stopl(500),stops(900),brkl(800),brks(100),modl(2000),tl(4500),ts(4500),trsl(100000),trss(100000);TUTTO
//Inputs: stopl(700),stops(300),brkl(200),brks(700),modl(1100),mods(400),tl(2200),ts(1800),trsl(100000),trss(100000);2003-2007
//Inputs: stopl(900),stops(900),brkl(800),brks(500),modl(2200),mods(1500),tl(2900),ts(2100),trsl(100000),trss(100000);2009-2010
//Inputs: stopl(400),stops(300),brkl(400),brks(500),modl(1500),mods(2300),tl(2000),ts(3500),trsl(100000),trss(100000);2003-2007
