{****** - MM.G1.K.GASOLINE - ********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    GASOLINE
 TimeFrame: 60 min.
 BackBars:  50
 Date:      03 Gen 2011
*************************************}
Inputs: lenl(40),kl(0.3),lens(9),ks(3.6),adxlen(14),adxlimit(30),mnymngmnt(1),hl(10),hs(10);
Inputs: stopl(3255),funkl(4095),tl(6468);
Inputs: stops(2583),funks(3759),ts(2772);

vars: upk(0),lok(0),el(true),es(true),adxval(0),engine(false);
vars: trades(0),mp(0),daylimit(9500/bigpointvalue),maxstop(0),minstop(0),settle(false),yc(0);
vars: stopval(0),stp(false),mkt(false),mcp(0),dru(0),funk(false);
vars: posh(0),posl(0);

if d <> d[1] then begin
 trades = 0;
 settle = false;
 funk = false;
 yc = c[1];
end;

if not settle and t > 2030 then begin
 maxstop = c[1] + daylimit;
 minstop = c[1] - daylimit;
 settle = true;
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

{**************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk and upk < maxstop;
es = c > lok and lok > minstop;

adxval = adx(adxlen);

engine = (800 < t and t < 2230 and trades < 1 and adxval < adxlimit);
{**************************}

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

if mnymngmnt = 1 and 800 < t and t < 2230 and marketposition <> 0 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  if not funk then funk = dru < -funkl;
  if funk then sell("xl.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
 end else begin
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  if not funk then funk = dru < -funks;
  if funk then buytocover("xs.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
 end;
  
end;

//ENGINE
if not funk and engine then begin
 if marketposition < 1 and el then
  buy("el") next bar upk stop;
 if marketposition > -1 and es then
  sellshort("es") next bar lok stop;
end;
