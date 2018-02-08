
Inputs: nos(4),lenl(22),kl(2.61),lens(23),ks(2.05),alpha(.21),adxlen(19),adxlimit(26),sod(800),eod(1930);
Inputs: stopl(1500),stops(1300),brkl(1700),brks(1500),modl(1600),mods(1000),tl(7600),ts(4000);

Inputs: DailyMaxLoss(0);
Inputs: DayLimit("2850"), SettleTime(2015);


Variables: lblNone(-1), lblEnter(0), lblStopLoss(10), lblStopBreak(15),
           lblProfit(20), lblModal(25), lblBreakEven(30), lblTimeOut(35), lblTrailing(40),
           hugePrice(999999);
Vars: stopOne(0), stopLbl(lblNone);

vars: upk(0,data2),lok(0,data2),bsetup(false,data2),ssetup(false,data2),adxv(0,data2),mcp(0);

Vars: tradecost((commission + slippage) * 2);
Vars: eqTotal(0), eqYestClose(0), eqDay(0);
Vars: dayMaxLoss(0), dayTrade(true), dayStop(0);
Vars: dayMax(0), dayPerc(false);
Vars: stopVal(0), stopMin(0.0), stopMax(999999.0), settlePrice(0.0);    { Points }


{ INIT }
if currentbar <= 1 then begin
 if DailyMaxLoss > 0 then
  dayMaxLoss = (DailyMaxLoss - .5 * tradecost * nos) / BigPointValue;
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
  end;
end;


if currentbar > 10 then begin

{ Day Position }
eqTotal = NetProfit + PositionProfit;
if date > date[1] then begin
 if DailyMaxLoss <> 0 then begin
  eqYestClose = eqTotal[1]; dayTrade = true;
 end;
end;

{ Daily Limits }
if dayMax > 0 then begin
 if Date > Date[1] then begin
  if settlePrice = 0 then settlePrice = Close[1];
  if dayPerc then begin
   stopMax = settlePrice * (1 + dayMax);
   stopMin = settlePrice * (1 - dayMax);
  end else begin
   stopMax = settlePrice + dayMax;
   stopMin = settlePrice - dayMax;
  end;
  settlePrice = 0;
 end else
  if SettleTime > 0 then
   if Time >= SettleTime and settlePrice = 0 then settlePrice = Close;
 if High > stopMax then stopMax = High;
 if Low < stopMin then stopMin = Low;
end;

mcp = MM.MaxContractProfit;

if barstatus(2) = 2 then begin

 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;

 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);

 bsetup = c data2 < upk;
 ssetup = c data2 > lok;

 adxv = adx(adxlen)data2;

end;


if t > sod and t < eod then begin

 //Daily Equity
 if DailyMaxLoss > 0 then begin
  eqDay = eqTotal - eqYestClose;
  if eqDay < -DailyMaxLoss then dayTrade = false;
 end;

  stopLbl = lblNone;
  if marketposition > 0 then stopOne = 0 else stopOne = hugePrice;

 // ENGINE
 if adxv < adxlimit then begin
  if marketposition < 1 and bsetup then begin
   stopLbl = lblEnter;
   if c >= upk then begin
    buy("EL.m") nos shares next bar at market; stopOne = 0; end
   else
   if StopMin < upk and upk < StopMax then begin
    buy("EL.s") nos shares next bar at upk stop; stopOne = upk; end;
  end;
  if marketposition > -1 and ssetup then begin
   stopLbl = lblEnter;
   if c <= lok then begin
    sellshort("ES.m") nos shares next bar at market; stopOne = hugePrice; end
   else
   if StopMin < lok and lok < StopMax then begin
    sellshort("ES.s") nos shares next bar at lok stop; stopOne = lok; end;
  end;
 end;

 if marketposition <> 0 then begin
  
  setstopshare;

  //Day Position Check
  if DailyMaxLoss > 0 then begin
   if not dayTrade then begin
    if MarketPosition > 0 then Sell ("XL-DayAbort.m") next bar at Market;
    if MarketPosition < 0 then BuyToCover ("XS-DayAbort.m") next bar at Market;
   end
   else
    if MarketPosition > 0 then begin
     dayStop = Close - (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     if c <= dayStop then Sell ("XL-DayStop.m") next bar at Market
     else Sell ("XL-DayStop.s") next bar at dayStop Stop;
    end else begin
     dayStop = Close + (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     if c >= dayStop then BuyToCover ("XS-DayStop.m") next bar at Market
     else BuyToCover ("XS-DayStop.s") next bar at dayStop Stop;
    end;
  end;

  //STOPLOSS
  if marketposition = 1 and stopl > 0 then begin
   stopVal = EntryPrice-MM.StopLoss(stopl)/bigpointvalue;
//   if c <= stopVal then
//    sell("xl.stop.m") next bar at market
//   else
//   if StopMin < StopVal and StopVal < StopMax then
     //setstoploss(stopl);
   if stopVal > stopOne then begin
    stopOne = stopVal; stopLbl = lblStopLoss; end;
  end else
  if marketposition = -1 and stops > 0 then begin
   stopVal = EntryPrice+MM.StopLoss(stops)/bigpointvalue;
//   if c >= stopVal then
//    buytocover("xs.stop.m") next bar at market
//   else
//   if StopMin < StopVal and StopVal < StopMax then
     //setstoploss(stops);
   if stopVal < stopOne then begin
    stopOne = stopVal; stopLbl = lblStopLoss; end;
  end;

  //PROFIT TARGET
  if marketposition = 1 and tl > 0 then begin
   stopVal = entryprice+MM.ProfitTarget(tl)/bigpointvalue;
   if h >= stopVal then
    sell("xl.prof.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    setprofittarget(tl);
  end
  else
  if marketposition = -1 and ts > 0 then begin
   stopVal = entryprice-MM.ProfitTarget(ts)/bigpointvalue;
   if l <= stopVal then
    buytocover("xs.prof.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    setprofittarget(ts);
  end;

  //BREAK EVEN
  stopVal = MM.BreakEven(100);
  if marketposition = 1 and mcp > brkl/bigpointvalue and brkl > 0 then begin
//   if c <= stopVal then
//    sell("xl.brk.m") next bar at market
//   else
//   if StopMin < StopVal and StopVal < StopMax then
    //sell("xl.brk.s") next bar at stopVal stop;
   if stopVal > stopOne then begin
    stopOne = stopVal; stopLbl = lblBreakEven; end;
  end
  else
  if marketposition = -1 and mcp > brks/bigpointvalue and brks > 0 then begin
//   if c >= stopVal then
//    buytocover("xs.brk.m") next bar at market
//   else
//    if StopMin < StopVal and StopVal < StopMax then
     //buytocover("xs.brk.s") next bar at stopVal stop;
   if stopVal < stopOne then begin
    stopOne = stopVal; stopLbl = lblBreakEven; end;
  end;

  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 and modl > 0 then begin
    stopVal = MM.ModalExit(modl);
    if h >= stopVal then
     sell("xl.mod.m") nos/2 shares next bar at market
    else
    if StopMin < StopVal and StopVal < StopMax then
     sell("xl.mod.s") nos/2 shares next bar at stopVal limit;
   end
   else
   if marketposition = -1 and mods > 0 then begin
    stopVal = MM.ModalExit(mods);
    if l <= stopVal then
     buytocover("xs.mod.m") nos/2 shares next bar at market
    else
    if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.mod.s") nos/2 shares next bar at stopVal limit;
   end;
  end;

  if marketposition > 0 and stopOne > 0 then begin
	{ Put highest STOP order at Market }
	if Close <= stopOne then begin
		switch stopLbl begin
			case lblEnter:     ;
			case lblStopLoss:  Sell ("XL-Stop.m") next bar at Market;
			case lblStopBreak: Sell ("XL-StBr.m") next bar at Market;
			case lblTrailing:  Sell ("XL-Trl.m") next bar at Market;
			case lblBreakEven: Sell ("XL-Brk.m") next bar at Market;
			case lblTimeOut:   Sell ("XL-Tout.m") next bar at Market;
			case lblNone:      ;
			default:           Abort;
		end;
	end else
	if stopMin < stopOne and stopOne < stopMax then begin
		switch stopLbl begin
			case lblEnter:     ;
			case lblStopLoss:  SetStopLoss(stopl);
			case lblStopBreak: Sell ("XL-StBr.s") next bar at stopOne Stop;
			case lblTrailing:  Sell ("XL-Trl.s") next bar at stopOne Stop;
			case lblBreakEven: Sell ("XL-Brk.s") next bar at stopOne Stop;
			case lblNone:      ;
			default:           Abort;
		end;
	end;
  end
  else
  if marketposition < 0 and stopOne < hugePrice then begin
	{ Put lowest STOP order at Market }
	if Close >= stopOne then begin
		switch stopLbl begin
			case lblEnter:     ;
			case lblStopLoss:  BuyToCover ("XS-Stop.m") next bar at Market;
			case lblStopBreak: BuyToCover ("XS-StBr.m") next bar at Market;
			case lblTrailing:  BuyToCover ("XS-Trl.m") next bar at Market;
			case lblBreakEven: BuyToCover ("XS-Brk.m") next bar at Market;
			case lblTimeOut:   BuyToCover ("XS-Tout.m") next bar at Market;
			case lblNone:      ;
			default:           Abort;
		end;
	end else
	if stopMin < stopOne and stopOne < stopMax then begin
		switch stopLbl begin
			case lblEnter:     ;
			case lblStopLoss:  SetStopLoss(stops);
			case lblStopBreak: BuyToCover ("XS-StBr.s") next bar at stopOne Stop;
			case lblTrailing:  BuyToCover ("XS-Trl.s") next bar at stopOne Stop;
			case lblBreakEven: BuyToCover ("XS-Brk.s") next bar at stopOne Stop;
			case lblNone:      ;
			default:           Abort;
		end;
	end;
  end;
  
 end; // of current position management

end; // of operating hours

end else begin
 if barstatus(2) = 2 then begin
  upk = KeltnerChannel(h,lenl,kl)data2;
  lok = KeltnerChannel(l,lens,-ks)data2;
 end;

end; 
