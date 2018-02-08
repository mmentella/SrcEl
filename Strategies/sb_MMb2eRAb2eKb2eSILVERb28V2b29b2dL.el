Inputs: nos(2),lenl(34),kl(1),lens(30),ks(4.76),adxlen(12),adxlimit(28);
Inputs: stopl(2500),stopdl(1950),brkl(750 ),modl(2500),tl(8700),tld(3150);

Vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0),bpv(1/bigpointvalue);
vars: stpv(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),daylimit(7000/bigpointvalue),funk(false),dru(0);

vars: stpw(0),reason(0),position(0),stoploss(1),daystop(11),breakeven(2),buy1(true),short1(true);
{***************************}
{***************************}
if d <> d[1] then begin
 maxstop = c[1] + daylimit;
 minstop = c[1] - daylimit;
 yc      = c[1];
 trades  = 0;
 funk    = false;
end;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 adxval = adx(adxlen)data2;
 
 engine = t data2 > 800 and t data2 < 2200;
end;

//MONEY MANAGEMENT
mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{***************************}
{***************************}
funk = dru <= -stopdl*maxlist(1,currentcontracts);
{***************************}
{***************************}
buy1   = not funk and engine and trades < 1 and adxval < adxlimit and marketposition < 1 and el and c < upk;
short1 = not funk and engine and trades < 1 and adxval < adxlimit and marketposition = 1 and es and c > lok;
{***************************}
{***************************}
if 800 < t and t < 2200 then begin
 
 if marketposition = 1 then begin
  
  stpw   = lok;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  
  if short1 then begin
   if stpv > stpw then begin
    stpw   = stpv;
    reason = stoploss;
   end;
  end else begin
   stpw   = stpv;
   reason = stoploss;
  end;
  
  //DAILY STOPLOSS
  stpv = yc - stopdl/bigpointvalue;
  
  if stpv > stpw then begin
   stpw   = stpv;
   reason = daystop;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 4*MinMove points;
  
  if mcp > brkl*bpv and stpv > stpw then begin
   stpw   = stpv;
   reason = breakeven;
  end;
  if d = 1110429 and t = 1522 then text_new(d,t,h+range,NumToStr(reason,0));
  if reason > position then begin
  
   stp = c >  stpw and stpw > minstop;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = daystop then begin
    if d > entrydate then begin
     if stp then sell("xl.funk") next bar stpw stop
     else if mkt then sell("xl.funk.m") this bar c;
    end;
   end else
   if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
   end;
   
  end;
  
  //MODAL
  stpv = entryprice + modl*bpv;
  stp  = currentcontracts = nos and c <  stpv and stpv < maxstop;
  mkt  = currentcontracts = nos and c >= stpv;
  
  if stp then sell("xl.mod") .5*nos shares next bar stpv limit
  else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
  
  //DAYTARGET
  stpv = yc + tld*bpv;
  stp  = d > entrydate and c <  stpv and stpv < maxstop;
  mkt  = d > entrydate and c >= stpv;
  
  if stp then sell("xl.trgtd") next bar stpv limit
  else if mkt then sell("xl.trgtd.m") this bar c;
  
  //TARGET
  stpv = entryprice + tl*bpv;
  stp  = c <  stpv and stpv < maxstop;
  mkt  = c >= stpv;
  
  if stp then sell("xl.trgt") .5*nos shares next bar stpv limit
  else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
  
 end;
  
end;
{***************************}
{***************************}
if buy1   then buy("long")   nos shares next bar at upk stop;
if short1 then sell("short") nos shares next bar at lok stop;
{***************************}
{***************************}
