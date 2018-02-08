Inputs: lenl(5),kl(0.07),lens(49),ks(1.8),sod(700),mnymngmnt(1);
Inputs: stopl(1700),tl(5900);
Inputs: stops(1700),ts(5400);

vars: upk(0),lok(0),el(true),es(true),adxval(0),engine(false);
vars: trades(0),mp(0),yc(0),stopval(0),stp(false),mkt(false),mcp(0),dru(0);
vars: maxsell(0),mincover(0);

{**************************}
if d <> d[1] then begin
 trades = 0;
 yc     = c[1];
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

mincover = 9999999;
maxsell  = 0;
{**************************}

{**************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el  = c < upk;
es  = c > lok;

engine = (700 < t and t < 1900 and trades < 1);
{**************************}

{**************************}
if mnymngmnt = 1 and 700 < t and t < 2230 then begin
 mcp = MM.MaxContractProfit;
 dru = MM.DailyRunup;

 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - stopl/bigpointvalue;
  if stopval > maxsell then maxsell = stopval;
  
  stp = c > maxsell;
  mkt = c <= maxsell;
  
  if stp then sell("xl") next bar maxsell stop;
  if mkt then sell("xl.m") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice + tl/bigpointvalue;
  stp     = c < stopval;
  mkt     = c >= stopval;
  
  if stp then sell("xl.prft") next bar stopval limit;
  if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stopval = entryprice + stops/bigpointvalue;
  if stopval < mincover then mincover = stopval;
  
  stp = c < mincover;
  mkt = c >= mincover;
  
  if stp then buytocover("xs") next bar mincover stop;
  if mkt then buytocover("xs.m") this bar c;
  
  stopval = entryprice - ts/bigpointvalue;
  stp     = c > stopval;
  mkt     = c <= stopval;
  
  if stp then buytocover("xs.prft") next bar stopval limit;
  if mkt then buytocover("xs.prft.m") this bar c;
  
 end;
 
end;
{**************************}

{**************************}
if engine then begin
 if marketposition < 1 and el then
  buy("el") next bar upk stop;
 if marketposition > -1 and es then
  sellshort("es") next bar lok stop;
end;
{**************************}
