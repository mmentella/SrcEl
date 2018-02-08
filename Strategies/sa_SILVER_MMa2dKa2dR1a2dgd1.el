
Inputs: nos(2),lenl(34),kl(1),lens(30),ks(4.76),adxlen(12),adxlimit(28),mnymngmnt(1);

Inputs: stopl(2500),stopdl(1950),brkl(750 ),modl(2500),tl(8700),tld(3150);
Inputs: stops(2300),stopds(2100),brks(1400),mods(2500),ts(6400),tsd(2750);
Inputs: DayLimits(7000), SettleTime(1930);

Inputs: OpenTime(0800), CloseTime(2250);
Inputs: EngineStart(0800), EngineStop(2200);


Variables: HugePrice(999999), Vector(BarType_ex = 2 and BarInterval <= 5);
Variables: DayLim(DayLimits/BigPointValue);
Variables: DayStop(MinList(stopdl, stopds));


Vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engineTime(true,data2),trades(0);
Vars: stopval(0),stp(false),mkt(false),mcp(0),yc(0),funk(false),dru(0),cc(nos);
Vars: settlePrice(0),minstop(-1),maxstop(999999);
Vars: upT(HugePrice), upS(HugePrice), loT(0), loS(0);

{ Process Variables }
Vars: lastT2(0, Data2), lastT1(0){, enable(true)};


if SettleTime > 0 then
	if Time >= SettleTime then
		if settlePrice = 0 then settlePrice = Close;

if Date > Date[1] then begin
	if settlePrice = 0 then settlePrice = Close[1];
	maxstop = settlePrice + DayLim;
	minstop = settlePrice - DayLim;
	settlePrice = 0;
	yc = c[1];
	trades = 0;
	funk = false;
	upS = HugePrice; loS = 0;
end;
if High > maxstop then maxstop = High;
if Low < minstop then minstop = Low;


Vars: vecEP(0{, Data3}), vecED(0{, Data3}), vecET(0{, Data3}), BI(BarInterval {of Data3});
Vars: v_EntryPrice(0), v_TargetEntry(0);

if MarketPosition <> 0 then begin

	if BarsSinceEntry = 0 then begin
		trades = trades + 1;
		v_EntryPrice = EntryPrice;
		if MarketPosition > 0 then v_TargetEntry = CeilMarketPrice(upk) else v_TargetEntry = FloorMarketPrice(lok);
	end;
	if BarStatus(1{3}) = 2 then
		if EntryDate = Date and Time {of Data3} - BI < EntryTime and EntryTime <= Time {of Data3} then begin
			if MarketPosition > 0 then vecEP = MaxList(Open {Data3}, CeilMarketPrice(upk))
			else                       vecEP = MinList(Open {Data3}, FloorMarketPrice(lok));
			vecED = Date; vecET = Time {of Data3};
		end;
	if v_EntryPrice <> vecEP then
		if vecED = EntryDate and vecET >= EntryTime then begin
			//Print(StrNow, " - v_EntryPrice ", v_EntryPrice:1:4, " ===> vecEP = ", vecEP:1:4, " (upk = ", upk:1:5, ", lok = ", lok:1:5, ")");
			v_EntryPrice = vecEP;
		end;

end;

upS = upT; loS = loT; upT = HugePrice; loT = 0;

if barstatus(2) = 2 then begin

	lastT2 = Time of Data2;

	upk = KeltnerChannel(High of Data2,lenl,kl)data2;
	lok = KeltnerChannel(Low of Data2,lens,-ks)data2;

	el = c data2 < upk;
	es = c data2 > lok;

	adxval = adx(adxlen)data2;

	engineTime = EngineStart < Time of Data2 and Time of Data2 < EngineStop;

end;

if lastT1 <> lastT2 then begin
	lastT1 = lastT2; upS = HugePrice; loS = 0; end;


//MONEY MANAGEMENT
mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

//if mnymngmnt = 1 and OpenTime < t and t < CloseTime and marketposition <> 0 then begin
if IsTime2Market(OpenTime, CloseTime, 0, 0) then begin

if mnymngmnt = 1 and marketposition <> 0 then begin
  
 setstopshare;
 
 cc = currentcontracts;
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = v_EntryPrice - (stopl - (slippage+commission))/bigpointvalue;
  if Vector then begin
	  stp     = l > stopval and stopval > minstop;
	  mkt     = l <= stopval;
  end else begin
	  stp     = c > stopval and stopval > minstop;
	  mkt     = c <= stopval;
  end;
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc - stopdl/bigpointvalue;
  if Vector then begin
	  stp     = l > stopval and stopval > minstop;
	  mkt     = l <= stopval;
  end else begin
	  stp     = c > stopval and stopval > minstop;
	  mkt     = c <= stopval;
  end;  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = v_EntryPrice + (tl + (slippage+commission))/bigpointvalue;
  if Vector then begin
	  stp     = h < stopval and stopval < maxstop;
	  mkt     = h >= stopval;
  end else begin
	  stp     = c < stopval and stopval < maxstop;
	  mkt     = c >= stopval;
  end;  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //DAILY PROFIT TARGET
  stopval = yc + tld/bigpointvalue;
  if Vector then begin
	  stp     = h < stopval and stopval < maxstop;
	  mkt     = h >= stopval;
  end else begin
	  stp     = c < stopval and stopval < maxstop;
	  mkt     = c >= stopval;
  end;
  if d > entrydate then begin
   if stp then sell("xl.trgtd") next bar at stopval limit;
   if mkt then sell("xl.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = v_EntryPrice + 100/bigpointvalue;
  if Vector then begin
	  stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < l;
	  mkt     = mcp > brkl/bigpointvalue and stopval >= l;
  end else begin
	  stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
	  mkt     = mcp > brkl/bigpointvalue and stopval >= c;
  end;
  if stp then sell("xl.brk") next bar at stopval stop;
  if mkt then sell("xl.brk.m") next bar at market;
  
  //MODAL EXIT
  stopval = v_EntryPrice + modl/bigpointvalue;
  if Vector then begin
	  stp     = currentcontracts = nos and h < stopval and stopval < maxstop;
	  mkt     = currentcontracts = nos and h >= stopval;
  end else begin
	  stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
	  mkt     = currentcontracts = nos and c >= stopval;
  end;
  if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
 end else begin
  
  //STOPLOSS
  stopval = v_EntryPrice + (stops - (slippage+commission))/bigpointvalue;
  if Vector then begin
	  stp     = h < stopval and stopval < maxstop;
	  mkt     = h >= stopval;
  end else begin
	  stp     = c < stopval and stopval < maxstop;
	  mkt     = c >= stopval;
  end;  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc + stopds/bigpointvalue;
  if Vector then begin
	  stp     = h < stopval and stopval < maxstop;
	  mkt     = h >= stopval;
  end else begin
	  stp     = c < stopval and stopval < maxstop;
	  mkt     = c >= stopval;
  end;
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = v_EntryPrice - (ts + (slippage+commission))/bigpointvalue;
  if Vector then begin
	  stp     = l > stopval and stopval > minstop;
	  mkt     = l <= stopval;
  end else begin
	  stp     = c > stopval and stopval > minstop;
	  mkt     = c <= stopval;
  end;  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
  //DAILY PROFIT TARGET
  stopval = yc - tsd/bigpointvalue;
  if Vector then begin
	  stp     = l > stopval and stopval > minstop;
	  mkt     = l <= stopval;
  end else begin
	  stp     = c > stopval and stopval > minstop;
	  mkt     = c <= stopval;
  end;
  if d > entrydate then begin
   if stp then buytocover("xs.trgtd") next bar at stopval limit;
   if mkt then buytocover("xs.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = v_EntryPrice - 100/bigpointvalue;
  if Vector then begin
	  stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > h;
	  mkt     = mcp > brks/bigpointvalue and stopval <= h;
  end else begin
	  stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
	  mkt     = mcp > brks/bigpointvalue and stopval <= c;
  end;  
  if stp then buytocover("xs.brk") next bar at stopval stop;
  if mkt then buytocover("xs.brk.m") next bar at market;
  
  //MODAL EXIT
  stopval = v_EntryPrice - mods/bigpointvalue;
  if Vector then begin
	  stp     = currentcontracts = nos and l > stopval and stopval > minstop;
	  mkt     = currentcontracts = nos and l <= stopval;
  end else begin
	  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
	  mkt     = currentcontracts = nos and c <= stopval;
  end;  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
    
 end;

end;
  
//engineTime

funk = (dru <= -DayStop * cc);

if (not funk) and engineTime and trades < 1 and adxval < adxlimit then begin
	{
	if marketposition < 1 and el and c < upk then
		buy("long") nos shares next bar at upk stop;
	if marketposition > -1 and es and c > lok then
		sellshort("short") nos shares next bar at lok stop;
	}
	if marketposition < 1 and el then
		if (Vector and High < upk) or ((not Vector) and c < upk) then
			if upk < maxstop then
				Buy("EL.s") nos shares next bar at upk stop;
	if marketposition > -1 and es then
		if (Vector and Low > lok) or ((not Vector) and c > lok) then
			if lok > minstop then
				SellShort("ES.s") nos shares next bar at lok stop;
	{
	// Should be the following, to take care of over/under daily limits:
	if marketposition < 1 and el then
		if (Vector and High >= upS) or ((not Vector) and c >= upS) then
			Buy("EL.m") nos shares next bar at Market
		else
		if (Vector and High < upk) or ((not Vector) and c < upk) then
			if upk < maxstop then
				Buy("EL.s") nos shares next bar at upk stop
			else
				upT = upk;
	if marketposition > -1 and es then
		if (Vector and Low <= loS) or ((not Vector) and c <= loS) then
			SellShort("ES.m") nos shares next bar at Market
		else
		if (Vector and Low > lok) or ((not Vector) and c > lok) then
			if lok > minstop then
				SellShort("ES.s") nos shares next bar at lok stop
			else
				loT = lok;
	}
end;

end;
