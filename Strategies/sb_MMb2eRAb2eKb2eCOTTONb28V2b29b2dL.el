Inputs: nos(2),lenl(8),kl(3),lens(26),ks(3.7),adxlen(14),adxlimit(30),mnymngmnt(1);
Inputs: stopl(1500),modl(850),tl(4600),brk(1150),trsl(2700);
Inputs: OpenTime(0800), CloseTime(2026), StartEnter(0800), StopEnter(2030);
Inputs: SettleTime(2015),DayLimit(1400);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0),bpv(1/bigpointvalue);
Vars: mcp(0),bounce(false),daymax(DayLimit/bigpointvalue),settlePrice(0),minstop(0),maxstop(0),stpv(0),stpw(0),stp(false),mkt(false);
Vars: eltgt(0), estgt(0),reason(0),position(0),stoploss(10),breakeven(11),trailing(12),modal(20),target(21),buy1(true),short1(true);

if d > d[1] then begin
 trades = 0;
end;

if daymax > 0 then begin
	if Date > Date[1] then begin
		if SettleTime = 0 or settlePrice = 0 then settlePrice = Close[1];
		maxstop = settlePrice + daymax;
		minstop = settlePrice - daymax;
		settlePrice = 0; 
	end else
		if Time >= SettleTime and SettleTime > 0 and settlePrice = 0 then settlePrice = Close;
	if High > maxstop then maxstop = High;
	if Low < minstop then minstop = Low;
end;


if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upperk;
 es = c data2 > lowerk;
 
 engine = StartEnter < t data2 and t data2 < StopEnter;
 
 adxval = adx(adxlen)data2;
end;
bounce = false;

mcp = MM.MaxContractProfit;
if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if IsMarketTime(OpenTime, CloseTime, 0, 0) then begin  // Market and ourselves are open

short1 = engine and trades < 1 and adxval < adxlimit and es and c > lowerk;

if mnymngmnt = 1 then begin

 if marketposition <> 0 then begin

  stpw   = lowerk;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  
  if short1 then begin
   if stpv > stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 20*MinMove points;
  
  if mcp > brk*bpv and stpv > stpw then begin
   reason = breakeven;
   stpw   = stpv;
  end;
  
  //TRAILING
  stpv = entryprice + mcp - trsl*bpv;
  
  if currentcontracts = .5*nos and stpv > stpw then begin
   reason = trailing;
   stpw   = stpv;
  end;
  
  //HIGHEST STOP
  if reason > position then begin
   
   stp = c >  stpw and stpw > minstop;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
   end else
   if reason = trailing then begin
    if stp then sell("xl.trl") next bar stpw stop
    else if mkt then sell("xl.trl.m") this bar c;
   end;
   
  end;
  
  //MODAL EXIT
  if marketposition = 1 then begin
   stpv = entryprice + modl/bigpointvalue;
   stp     = currentcontracts = nos and c < stpv and stpv < maxstop;
   mkt     = currentcontracts = nos and h >= stpv;
   
   if mkt then sell("xl.modl.m") .5*nos shares next bar at market
   else
   if stp then sell("xl.modl") .5*nos shares next bar at stpv limit;
  end;
  
  //TARGET
  if marketposition = 1 then begin
   stpv = entryprice + (tl + (slippage+commission))*bpv;
   stp  = c < stpv and stpv < maxstop;
   mkt  = h >= stpv;
   
   if mkt then sell("xl.trgt.m") .5*nos shares next bar at market
   else
   if stp then sell("xl.trgt") .5*nos shares next bar at stpv limit;
  end;  
 end;
 
end;

if engine and trades < 1 then begin
 if marketposition < 1 then
 
  if eltgt > 0 and h >= eltgt then begin
   buy("el.m") nos shares next bar at market; eltgt = 0; end
  else begin
   eltgt = 0;
   if adxval < adxlimit and el and c < upperk then
    if upperk < maxstop then
     buy("el.s") nos shares next bar at upperk stop
    else
     eltgt = upperk;
  end;
 if marketposition = 1 then
  if estgt > 0 and l <= estgt then begin
   sell("es.m") nos shares next bar at market; estgt = 0; end
  else begin
   estgt = 0;
   if adxval < adxlimit and es and c > lowerk then
    if lowerk > minstop then
     sell("es.s") nos shares next bar at lowerk stop
    else
     estgt = lowerk;
  end;
   
end;

end;  // of ALL daily operations

//********ROLLOVER*******
if Date = 1100226 and time >= 2000 then begin
 if marketposition = 1 then sell next bar at market;
end;
