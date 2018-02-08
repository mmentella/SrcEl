{******** - MM.LUG.K1.NQK - **********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: LUGA
 Market:    eMini Nasdaq
 TimeFrame: 60 min.
 BackBars:  50
 Date:      11 Mar 2011
*************************************} 
inputs: lenl(1),kl(2.92),lens(4),ks(4.52);
inputs: stopl(100000),funkl(100000),tl(100000);
inputs: stops(100000),funks(100000),ts(100000);
 
vars: upk(0),lok(0),el(true),es(true),engine(true);
vars: trade(0),fnkl(false),fnks(false),dru(0),stpv(0),stp(true),mkt(false);
vars: bpv(1/bigpointvalue),nos(1);
 
if d > d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;
 
upk = BollingerBand(h,lenl,kl);
lok = BollingerBand(l,lens,-ks);
 
el = c < upk;
es = c > lok;
 
engine = 700 < t and t < 2300;
 
if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;
 
dru = MM.DailyRunup;

if marketposition <> 0 and 700 < t and t < 2300 then begin
  
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*nos)*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.pt") next bar stpv limit
  else if mkt then sell("xl.pt.m") this bar c;
    
 end else begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks*nos)*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.pt") next bar stpv limit
  else if mkt then buy to cover("xs.pt.m") this bar c;
  
 end;
 
end;

fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;

if trade = 0 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upk stop;
 
 if not fnks and marketposition > -1 and es then
  sellshort("es") next bar lok stop;

end;
