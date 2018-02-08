{******************************************************
 Strumento    : miini Russell 2000
 Time Frame   : 15h con sessione 8-23 nominata "romana"
 Vettore      : 2 min con sessione 8-23 nominata "romana"
              
 Data Consegna: 03/08/2010
*******************************************************}
Inputs: nos(2),alphtl(.583),alphcl(.502),rngpctl(.739),alphts(.097),alphcs(.343),rngpcts(.452);
Inputs: stopl(2000),stopdl(1800),modl(2750),tl(5400),trsl(3500);
Inputs: stopperc(4.5),settletime(2215);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),trends(0,data2),triggers(0,data2),cycles(0,data2),el(true,data2),es(true,data2);
vars: entrylong(0,data2),entryshort(0,data2),stpv(0),minstop(-1),maxstop(999999),mkt(true),stp(true),mcp(0),trade(true),yc(0),mp(0),ys(0);

vars: buy1(true),short1(true),stpw(0),reason(0),position(0),stoploss(10),daystop(11),trailing(13),modal(20),target(21);
{***************************}
{***************************}
if d <> d[1] then begin
 yc    = c[1]; 
 trade = true;
end;
{***************************}
{***************************}
if stopperc > 0 then begin
 if Date > Date[1] then begin
  if ys = 0 then ys = c[1];
  maxstop = ys*(1+stopperc/100);
  minstop = ys*(1-stopperc/100);
  ys = 0;
 end;
 if settletime > 0 and Time >= settletime then
 	if ys = 0 then ys = c;
 if High > maxstop then maxstop = High;
 if Low < minstop then minstop = Low;
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphtl,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice,alphcl)data2;
 
 MM.ITrend(medianprice,alphts,trends,triggers)data2;
 cycles = MM.Cycle(medianprice,alphcs)data2;
 
 el = triggerl > trendl and cyclel > cyclel[1];
 es = triggers > trends and cycles > cycles[1];
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end;

mcp = MM.MaxContractProfit;
{***************************}
{***************************}
buy1   = trade and marketposition < 1 and el;
short1 = trade and marketposition = 1 and es;
{***************************}
{***************************}
if marketposition = 1 then begin
 
 //STOPLOSS
 stpw   = entryprice - (stopl - (slippage+commission))/bigpointvalue;
 reason = stoploss;
 
 //DAILY STOPLOSS
 stpv = yc - stopdl/bigpointvalue;
 
 if d > entrydate then begin
  if stpv > stpw then begin
   stpw   = stpv;
   reason = daystop;
  end;
 end;
 
 //TRAILING STOP
 stpv = entryprice + (mcp - trsl/bigpointvalue);
 
 if currentcontracts = .5*nos and stpv > stpw then begin
  stpw   = stpv;
  reason = trailing;
 end;
 
 stp = c >  stpw and stpw > minstop;
 mkt = c <= stpw;
 
 if reason = stoploss then begin
  if stp then sell("xl.stp") next bar stpw stop
  else if mkt then sell("xl.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then sell("xl.funk") next bar stpw stop
  else if mkt then sell("xl.funk.m") this bar c;  
 end else
 if reason = trailing then begin
  if stp then sell("xl.trl") next bar stpw stop
  else if mkt then sell("xl.trl.m") this bar c;  
 end;
 
 stpw   = entryshort;
 reason = position;
 
 //MODAL EXIT
 stpv = entryprice + modl/bigpointvalue;
 stp  = currentcontracts = nos and stpv < stpw and c < stpv and stpv < maxstop;
 mkt  = currentcontracts = nos and c >= stpv;
 
 if stp then sell("xl.mod") .5*nos shares next bar stpv limit
 else if mkt then sell("xl.mod.m") .5*nos shares this bar c;

 //PROFIT TARGET
 stpv = entryprice + (tl + (slippage+commission))/bigpointvalue;
 stp  = stpv < stpw and c < stpv and stpv < maxstop;
 mkt  = stpv < stpw and c >= stpv;
 
 if stp then sell("xl.trgt") .5*nos shares next bar stpv limit
 else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
 
end;
{***************************}
{***************************}
if buy1   then buy  nos shares next bar at entrylong limit; 
if short1 then sell nos shares next bar at entryshort limit;
