vars: lenl(35),kl(2.8),lens(50),ks(3.9);
vars: stopl(1660),funkl(1992),tl(1361.2);
vars: stops(996 ),funks(1494),ts(697.2);

vars: upk(0),lok(0),el(true),es(true),trade(0);
vars: dru(0),fnkl(false),fnks(false),stpv(0),stp(true),mkt(false),bpv(1/bigpointvalue),nos(1);

if d > d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;

upk = BollingerBand(h,lenl,kl);
lok = BollingerBand(l,lens,-ks);

el = c < upk;
es = c > lok;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;

if marketposition = 1 then begin
 
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stpl") next bar stpv stop
 else if mkt then sell("xl.stpl.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.fnk") next bar stpv stop
 else if mkt then sell("xl.fnk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.tp") next bar stpv limit
 else if mkt then sell("xl.tp.m") this bar c;
 
end else if marketposition = -1 then begin
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stpl") next bar stpv stop
 else if mkt then buy to cover("xs.stpl.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c + (dru + funks)*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.fnk") next bar stpv stop
 else if mkt then buy to cover("xs.fnk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.tp") next bar stpv limit
 else if mkt then buy to cover("xs.tp.m") this bar c;
 
end;

fnkl = dru <= - funkl*nos;
fnks = dru <= - funks*nos;

if trade = 0 and 1000 < t then begin
 
 if not fnkl and marketposition < 1 and el then
  buy next bar upk stop;
 
 if not fnks and marketposition > -1 and es then
  sellshort next bar lok stop;
 
end;
