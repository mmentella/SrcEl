vars: FL(0.1),FS(1.6),KLenL(31),KLenS(12),MinLen(12),MaxLen(44);
vars: stopl(100),funkl(215),tl(415);
vars: stops(230),funks(210),ts(595);

vars: UpperK(0),LowerK(0),K(0),SD(0),lenl(MinLen),lens(MinLen);
vars: trade(0),dru(0),stpv(0),stp(true),mkt(true),funk(false);

if d > d[1] then trade = 0;

sd = StdDev(h,klenl);
if sd <> 0 then k = 1 - sd[1]/sd;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(h,lenl,fl);
 
sd = StdDev(l,klens);
if sd <> 0 then k = 1 - sd[1]/sd;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lowerk = KeltnerChannel(l,lens,-fs);

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;

dru = MM.DailyRunup;

if 700 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl)/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;

funk = dru <= -minlist(funkl,funks);

if not funk and trade < 2 and 700 < t and t < 2300 then begin

 if c < upperk then
  buy("el") next bar upperk stop;
 
 if c > lowerk then
  sellshort("es") next bar lowerk stop;

end;
