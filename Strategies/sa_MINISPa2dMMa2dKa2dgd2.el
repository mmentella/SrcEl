
Inputs: nos(2),lenl(41),kl(2.182),lens(10),ks(4.769),alphal(.25),alphas(.306),adxlen(14),adxlimit(30),mnymngmt(true);
Inputs: stopl(2100),stopdl(2200),modl(1400),tl(3100),tld(2300);
Inputs: stops(1900),stopds(3000),mods(1650),ts(1800),tsd(1500);

Inputs: DayLimit("4.5%"), SettleTime(2215);


Variables: tickUnit(MinMove / PriceScale);   { MinMove Points }
Variables: dayMax(0), dayPerc(false);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),engine(true,data2),el(true,data2),es(true,data2),trade(true);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);
vars: settlePrice(0);


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
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);
 
 adxval = adx(adxlen)data2;
 
 engine = 800 < t data2 and t data2 < 2200;
 
 el = c data2 < upk;
 es = c data2 > lok;
end;

//1 TRADE PER DAY
if marketposition <> 0 and barssinceentry = 0 then trade = false;

//MONEY MANAGEMENT
mcp = MM.MaxContractProfit;
//condition1 = mnymngmt and 800 < t and t < 2200; 
//if condition1 and marketposition <> 0 then begin
if marketposition <> 0 and mnymngmt and 800 < t and t < 2200 then begin
 
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc - stopdl/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;

  //DAILY PROFIT TARGET
  stopval = yc + tld/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.trgtd") next bar at stopval limit;
   if mkt then sell("xl.trgtd.m") next bar at market;
  end;

  //MODAL EXIT
  stopval = entryprice + modl/bigpointvalue;
  stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
  mkt     = currentcontracts = nos and c >= stopval;
  
  if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
 end else begin
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc + stopds/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
  //DAILY PROFIT TARGET
  stopval = yc - tsd/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.trgtd") next bar at stopval limit;
   if mkt then buytocover("xs.trgtd.m") next bar at market;
  end;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;
 
end;

//ENGINE
if engine and trade and adxval < adxlimit then begin
 if marketposition < 1 and c < upk and el then
  if upk < maxstop then
   buy("el") nos shares next bar upk stop;
 if marketposition > -1 and c > lok and es then
  if lok > minstop then
   sellshort("es") nos shares next bar lok stop;
end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;
