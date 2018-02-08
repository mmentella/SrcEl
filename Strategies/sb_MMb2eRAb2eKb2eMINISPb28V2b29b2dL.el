Inputs: nos(2),lenl(41),kl(2.182),lens(10),ks(4.769),alphal(.25),alphas(.306),adxlen(14),adxlimit(30),mnymngmt(true);
Inputs: stopl(2100),stopdl(2200),modl(1400),tl(3100),tld(2300);

Inputs: DayLimit("4.5%"), SettleTime(2215);


Variables: tickUnit(MinMove / PriceScale);   { MinMove Points }
Variables: dayMax(0), dayPerc(false);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),engine(true,data2),el(true,data2),es(true,data2),trade(true);
vars: stpv(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);
vars: settlePrice(0);

vars: stpw(0),reason(0),position(0),stoploss(10),daystop(11),modal(20),target(21),daytarget(22),short1(true);


if CurrentBar <= 1 then
	if DayLimit <> "" then
		if RightStr(DayLimit, 1) = "%" then begin
			dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)) / 100.0; dayPerc = true; end
		else begin
			dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
			dayMax = (IntPortion(dayMax / tickUnit) - 1) * tickUnit;
		end;


if currentbar > maxlist(lenl,lens) then begin

{ Daily Limits }
if dayMax > 0 then begin
	if Date > Date[1] then begin
		if SettleTime = 0 or settlePrice = 0 then settlePrice = Close[1];
		if dayPerc then begin
			maxstop = (IntPortion(settlePrice * (1 + dayMax) / tickUnit) - 1) * tickUnit;
			minstop = (Ceiling(settlePrice * (1 - dayMax) / tickUnit) + 1) * tickUnit;
		end else begin
			maxstop = settlePrice + dayMax;
			minstop = settlePrice - dayMax;
		end;
		settlePrice = 0;
	end else
		if Time >= SettleTime and SettleTime > 0 and settlePrice = 0 then settlePrice = Close;
	if High > maxstop then maxstop = High;
	if Low < minstop then minstop = Low;
end;

if d <> d[1] then begin yc = c[1]; trade = true; end;

//SETUP
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal)data2;
 lok = MM.Smooth(lok,alphas)data2;
 
 adxval = adx(adxlen)data2;
 
 engine = 800 < t data2 and t data2 < 2200;
 
 el = c data2 < upk;
 es = c data2 > lok;
end;

short1 = engine and trade and adxval < adxlimit and marketposition = 1 and es and c > lok;

//1 TRADE PER DAY
if marketposition <> 0 and barssinceentry = 0 then trade = false;

//MONEY MANAGEMENT
mcp = MM.MaxContractProfit;
if marketposition <> 0 and mnymngmt and 800 < t and t < 2200 then begin
 
 if marketposition = 1 then begin
  
  reason = position;
  stpw   = stpv;
  
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
  
  if d > entrydate and stpv > stpw then begin
   stpw   = stpv;
   reason = daystop;
  end;
  
  if reason > position then begin
   
   stp = c >  stpw and stpw > minstop;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpv stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else 
   if reason = daystop then begin
    if stp then sell("xl.funk") next bar stpv stop
    else if mkt then sell("xl.funk.m") this bar c;
   end;
   
  end;

  //MODAL EXIT
  if currentcontracts = nos then begin
   stpw   = entryprice + modl/bigpointvalue;
   reason = modal;
  end;
  
  //PROFIT TARGET
  if currentcontracts = .5*nos then begin
   stpw   = entryprice + (tl + (slippage+commission))/bigpointvalue;
   reason = target;
  end;

  //DAILY PROFIT TARGET
  stpv = yc + tld/bigpointvalue;
  
  if d > entrydate and stpv < stpw then begin
   stpw   = stpv;
   reason = daytarget;
  end;
  
  stp = c <  stpw and stpw < maxstop;
  mkt = c >= stpw;
  
  if reason = modal then begin
   if stp then sell("xl.mod") .5*nos shares next bar stpw limit
   else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
  end else
  if reason = daytarget then begin
   if stp then sell("xl.trgt") .5*nos shares next bar stpw limit
   else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
  end else
  if reason = target then begin
   if stp then sell("xl.trgtd") next bar stpw limit
   else if mkt then sell("xl.trgtd.m") this bar c;
  end;
  
 end;
 
end;

//ENGINE
if engine and trade and adxval < adxlimit then begin

 if marketposition < 1 and c < upk and el then
  if upk < maxstop then
   buy("el") nos shares next bar upk stop;
   
 if marketposition = 1 and c > lok and es then
  if lok > minstop then
   sell("es") nos shares next bar lok stop;
   
end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;
