Inputs: nos(4),lenl(22),lens(15),kl(1.13),ks(3.19),stochlen(14),os(34),ob(74),alpha(.2);
Inputs: stopl(500),stops(500),brkl(700),brks(500),modl(2000),mods(1200),tl(4300),ts(2400),trsl(1700),trss(1200);

vars: uppk(0),lowk(0),stochval(0),mcp(0);

uppk = KeltnerChannel(h,lenl,kl);
lowk = KeltnerChannel(l,lens,-ks);

uppk = alpha*uppk + (1-alpha)*uppk[1];
lowk = alpha*lowk + (1-alpha)*lowk[1];

stochval = SlowK(stochlen);

mcp = MM.MaxContractProfit;

if marketposition <> 0 then begin
 
 setstopshare;
 
 //STOPLOSS
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
 if marketposition = 1 then sell("xl.trl.s") next bar at entryprice + (mcp - trsl/bigpointvalue) stop;
 if marketposition = -1 then buytocover("xs.trl.s") next bar at entryprice - (mcp - trss/bigpointvalue) stop;
 
end;

//ENGINE
if stochval > os and stochval < ob then begin
 if marketposition < 1 and c < uppk then
  buy("el.s") nos shares next bar at uppk stop;
 if marketposition > -1 and c > lowk then
  sellshort("es.s") nos shares next bar at lowk stop;
end;
