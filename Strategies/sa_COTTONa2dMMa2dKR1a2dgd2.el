
Inputs: NoS(2),LenL(8),KL(3),LenS(26),KS(3.7),ADXLen(14),ADXLimit(30),mnymngmnt(1);
Inputs: StopLoss(1500),modl(850),mods(260),tl(4600),ts(2300),BRK(1150),TRSL(2700),TRSS(1175);
Inputs: OpenTime(0800), CloseTime(2026), StartEnter(0800), StopEnter(2030);
Inputs: SettleTime(2015),DayLimit(1400);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0){,settlement(false)};
Vars: mcp(0),bounce(false),daymax(DayLimit/bigpointvalue),settlePrice(0),minstop(0),maxstop(0),stopval(0),stp(false),mkt(false);
Vars: eltgt(0), estgt(0);

//Vars: str("");

if d > d[1] then begin
// settlement = false;
 trades = 0;
end;
{
if not settlement and t > 2015 then begin
 maxstop = c[1] + daymax;
 minstop = c[1] - daymax;
 settlement = true;
end;
}
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
 
 //engine = 800 < t data2 and t data2 < 2030;
 engine = StartEnter < t data2 and t data2 < StopEnter;
 
 adxval = adx(adxlen)data2;
end;
bounce = false;

mcp = MM.MaxContractProfit;
if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

//if mnymngmnt = 1 and time > 800 and time < 2026 then begin
//if OpenTime < time and time < CloseTime then begin
if IsMarketTime(OpenTime, CloseTime, 0, 0) then begin  // Market and ourselves are open

if mnymngmnt = 1 then begin

 if marketposition <> 0 then begin

  setstopshare;
//str = "Close = " + NumToStr(close,2) + ", StopLimits = [" + NumToStr(minstop,2) + "]-[" + NumToStr(maxstop,2) + "]";
  
  //STOPLOSS
  if marketposition = 1 then begin
   stopval = entryprice - (StopLoss - (slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setstoploss(StopLoss);
   if mkt then sell("xl.stpls") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice + (StopLoss - (slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setstoploss(StopLoss);
   if mkt then buytocover("xs.stpls") next bar at market;
  end;
  
  //BREAKEVEN
  if marketposition = 1 then begin
   stopval = entryprice + 100/bigpointvalue;
   stp     = mcp > brk/bigpointvalue and minstop < stopval and stopval < c;
   mkt     = mcp > brk/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - 100/bigpointvalue;
   stp     = mcp > brk/bigpointvalue and maxstop > stopval and stopval > c;
   mkt     = mcp > brk/bigpointvalue and stopval <= c;
   
   if stp then buytocover("xs.brk") next bar at stopval stop;
   if mkt then buytocover("xs.brk.m") next bar at market;
  end;
  
  //TRAILING STOP
  if marketposition = 1 then begin
   stopval = entryprice + (mcp - trsl/bigpointvalue);
   stp     = currentcontracts = nos/2 and minstop < stopval and stopval < c;
   mkt     = currentcontracts = nos/2 and c <= stopval;
   
   if stp then sell("xl.trs") next bar at stopval stop;
   if mkt then sell("xl.trs.m") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - (mcp - trss/bigpointvalue);
   stp     = currentcontracts = nos/2 and maxstop > stopval and stopval > c;
   mkt     = currentcontracts = nos/2 and c >= stopval;
   
   if stp then buytocover("xs.trs") next bar at stopval stop;
   if mkt then buytocover("xs.trs.m") next bar at market;
  end;
  
  //MODAL EXIT
  if marketposition = 1 then begin
   stopval = entryprice + modl/bigpointvalue;
   stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
   //mkt     = currentcontracts = nos and c >= stopval;
   mkt     = currentcontracts = nos and h >= stopval;
//if stp then str = str + ", ModalExit = " + NumToStr(stopval,2);
   
   if mkt then sell("xl.modl.m") nos/2 shares next bar at market
   else
   if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  end else if marketposition = -1 then begin
   stopval = entryprice - mods/bigpointvalue;
   stp     = currentcontracts = nos and c > stopval and stopval > minstop;
   //mkt     = currentcontracts = nos and c <= stopval;
   mkt     = currentcontracts = nos and l <= stopval;
//if stp then str = str + "ModalExit = " + NumToStr(stopval,2);
   
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market
   else
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  end;
  
  if marketposition = 1 then begin
   stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   //mkt     = c >= stopval;
   mkt     = h >= stopval;
//if stp then str = str + ", ProfitTarget = " + NumToStr(stopval,2);
   
   if mkt then sell("xl.prftrgt") next bar at market
   else
   if stp then setprofittarget(tl);
  end else if marketposition = -1 then begin
   stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   //mkt     = c <= stopval;
   mkt     = l <= stopval;
//if stp then str = str + ", ProfitTarget = " + NumToStr(stopval,2);
   
   if mkt then buytocover("xs.prftrgt") next bar at market
   else
   if stp then setprofittarget(ts);
  end;
//if 1101005 <= Date and Date <= 1101011 then Print(StrNow, ": ", str);  
 end;
 
end;

//Engine
//if engine and adxval < adxlimit and trades < 1 then begin
// if marketposition < 1 and el and c < upperk then
//  buy("el.s") nos shares next bar at upperk stop;
// if marketposition > -1 and es and c > lowerk then
//  sellshort("es.s") nos shares next bar at lowerk stop;
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
 if marketposition > -1 then
  if estgt > 0 and l <= estgt then begin
   sellshort("es.m") nos shares next bar at market; estgt = 0; end
  else begin
   estgt = 0;
   if adxval < adxlimit and es and c > lowerk then
    if lowerk > minstop then
     sellshort("es.s") nos shares next bar at lowerk stop
    else
     estgt = lowerk;
  end;
   
end;

end;  // of ALL daily operations

//********ROLLOVER*******
if Date = 1100226 and time >= 2000 then begin
 if marketposition = 1 then sell next bar at market;
 if marketposition = -1 then buytocover next bar at market;
end;
