Inputs: nos(2),sod(800),eod(2258);
Inputs: stoploss(900),brk(10000),target(4900),mod1(500),trs(3900);

vars: mcp(0);

mcp = MM.MaxContractProfit;

if marketposition = 0 and t = sod then buy("start") nos shares this bar on close;

if t = eod then begin
 if marketposition > 0 then sell this bar on close;
 buy("re-open") nos shares this bar on close;
end;

if marketposition <> 0 and t > sod and t < eod then begin
 setstopshare;
 
 setstoploss(stoploss);
 setprofittarget(target);
 
 if currentcontracts = nos and nos > 1 then sell("xl.modl") nos/2 shares next bar at entryprice + mod1 limit;
 
 if mcp > brk then sell("xl.brk") next bar at entryprice + 100 stop;
 
 if currentcontracts = nos/2 then sell("xl.trs") next bar at entryprice + mcp - trs stop;
end;
