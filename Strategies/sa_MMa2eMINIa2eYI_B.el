vars: lenl(20),kl(0.7),lens(50),ks(3.7);
vars: stopl(2100),funkl(1100),tl(1980);
vars: stops(800),funks(1620),ts(1070);

vars: upk(0),lok(0),el(true),es(true),engine(true),trade(0);
vars: stpv(0),stp(true),mkt(false),dru(0),fnkl(false),fnks(false);
vars: nos(1),bpv(1/bigpointvalue);

if d > d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;

upk = BollingerBand(h,lenl,kl);
lok = BollingerBand(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = time < 2100;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;

if marketposition = 1 then begin
 
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar stpv stop
 else if mkt then sell("xl.stp.m") this bar c;
 
 stpv = c - (dru + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.fnk") next bar stpv stop
 else if mkt then sell("xl.fnk.m") this bar c;
 
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.tp") next bar stpv limit
 else if mkt then sell("xl.tp.m") this bar c;
 
end else if marketposition = -1 then begin
 
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stp") next bar stpv stop
 else if mkt then buy to cover("xs.stp.m") this bar c;
 
 stpv = c + (dru + funks)*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.fnk") next bar stpv stop
 else if mkt then buy to cover("xs.fnk.m") this bar c;
 
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.tp") next bar stpv limit
 else if mkt then buy to cover("xs.tp.m") this bar c;
 
end;

fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;

if trade = 0 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy next bar upk stop;
 
 if not fnks and marketposition > -1 and es then
  sell short next bar lok stop;
 
end;
