inputs: lenl(17),kl(2.2),lens(50),ks(2.5);
inputs: stopl(305000),funkl(215000),brkl(237000),tl(470000);
inputs: stops(190000),funks(290000),brks(160000),ts(240000);

vars: upb(0),lob(0),el(true),es(true),engine(true);
vars: trade(0),fnkl(false),fnks(false),dru(0),mcp(0);
vars: stpv(0),stp(true),mkt(true),nos(1),bpv(1/bigpointvalue);

if d <> d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;

upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

el = c  < upb;
es = c  > lob;

engine = 300 < t  and t  < 1800;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
 
if marketposition = 1 then begin

 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c < stpv;
  
 if stp then sell("xl.stp") next bar stpv stop
 else if mkt then sell("xl.stp.m") this bar c;
  
 //DAILY STOPLOSS
 stpv = c - (dru + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c < stpv;
 
 if stp then sell("xl.funk") next bar stpv stop
 else if mkt then sell("xl.funk.m") this bar c;
 
 //BREAK EVEN
 stpv = entryprice + 16*MinMove points;
 stp  = mcp >= brkl*bpv and c > stpv;
 mkt  = mcp >= brkl*bpv and c <= stpv;
 
 if stp then sell("xl.brl") next bar stpv stop
 else if mkt then sell("xl.brk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c > stpv;
 
 if stp then sell("xl.prft") next bar stpv limit
 else if mkt then sell("xl.prft.m") this bar c;
 
 end else if marketposition = -1 then begin
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c > stpv;
 
 if stp then buy to cover("xs.stp") next bar stpv stop
 else if mkt then buy to cover("xs.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c + (dru + funks)*bpv;
 stp  = c < stpv;
 mkt  = c > stpv;
 
 if stp then buy to cover("xs.funk") next bar stpv stop
 else if mkt then buy to cover("xs.funk.m") this bar c;
 
 //BREAK EVEN
 stpv = entryprice - 16*MinMove points;
 stp  = mcp >= brks*bpv and c < stpv;
 mkt  = mcp >= brks*bpv and c >= stpv;
 
 if stp then buy to cover("xs.brl") next bar stpv stop
 else if mkt then buy to cover("xs.brk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c < stpv;
 
 if stp then buy to cover("xs.prft") next bar stpv limit
 else if mkt then buy to cover("xs.prft.m") this bar c;
 
end;
 
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;

if trade < 1 and engine then begin

 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upb stop;
  
 if not fnks and marketposition > -1 and es then
  sellshort("es") next bar lob stop;
  
end;
