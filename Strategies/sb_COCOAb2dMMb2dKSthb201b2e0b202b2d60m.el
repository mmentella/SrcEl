Inputs: nos(2),lenl(27),lens(12),kl(.72),ks(4.14),alpha(.21);
Inputs: stopl(600),stops(700),brkl(800),brks(500),modl(2000),mods(2200),tl(4500),ts(4400),trsl(1200),trss(1300);

vars: uppk(0,data2),lowk(0,data2),adxval(0,data2),mcp(0);

uppk = KeltnerChannel(h,lenl,kl)data2;
lowk = KeltnerChannel(l,lens,-ks)data2;

uppk = alpha*uppk + (1-alpha)*uppk[1];
lowk = alpha*lowk + (1-alpha)*lowk[1];

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
if marketposition < 1 and c data2 < uppk and c < uppk then
 buy("el.s") nos shares next bar at uppk stop;
if marketposition > -1 and c data2 > lowk and c > lowk then
 sellshort("es.s") nos shares next bar at lowk stop;
