[intrabarordergeneration = true];

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

// Existing issues - inaccurately sync order's prices:
// 1) entry prices - only in pyramiding mode
// 2) exit prices - always (used close price as close position price)

Input :
	TimeOutMS(250),	// time spent since BrokerMarketPosition changed and we start correct position
	LatencyMS(500);	// time spent since we start correct StrategyMarketPosition and return to monitoring mode

variables:
   textID( text_new_s(d, time_s, c,"CurrentState") ),
   intrabarpersist sync_state("MP is synchronized!"),
   intrabarpersist diff_state("MP syncronization. Wait "),

   _rightest(0),
   _highest(0),

   inner_mp(0),
   broker_mp(0),

   intrabarpersist mp_diff(false),
   intrabarpersist mp_diff_time_start(0),

   intrabarpersist mp_corrected(false),
   intrabarpersist mp_corrected_time_start(0),

   intrabarpersist place_correction_marketorder(false),

   intrabarpersist _get_tick_count(0),
   intrabarpersist _exit_price(0),

   correct_contracts(0),
   is_buy(false),
   is_entry(true);


if getappinfo(airealtimecalc) = 1 and getappinfo(aistrategyauto) = 1 then begin

once begin
   print( text_setstyle(textID, 1, 0) );
   diff_state += text(TimeOutMS*.001, " seconds.");
end;

   inner_mp = currentcontracts*marketposition;
   broker_mp = MarketPosition_at_Broker;

   _rightest = getappinfo(airightdispdatetime);
   _highest = getappinfo(aihighestdispvalue);

   text_setlocation_s(
      textID,
      juliantodate(_rightest),
      datetime2eltime_s(_rightest),
      _highest
   );

   if broker_mp <> inner_mp then begin


      _get_tick_count = GetTickCount ;

// market position differs state
      if not mp_diff and not mp_corrected then begin
         mp_diff = true;
         mp_diff_time_start = _get_tick_count ;
         text_setstring(textID, diff_state);
      end;

// enter correction state after TimeOut
      if mp_diff and not mp_corrected then begin
      		_exit_price = c; // assume that position can closed at close price
      		if  _get_tick_count - mp_diff_time_start > TimeOutMS then begin
		         place_correction_marketorder = true ;
		         mp_corrected = true ;
		         mp_corrected_time_start = _get_tick_count ;
		end;
      end;

// correction state
      if mp_corrected then begin         
         if _get_tick_count - mp_corrected_time_start > LatencyMS then begin
            mp_corrected_time_start = _get_tick_count ;
            mp_diff = false;
            mp_corrected = false;
         end;
      end;

// place correction order
      if place_correction_marketorder then begin
         place_correction_marketorder = false ;
         if 0 <> broker_mp then _exit_price = AvgEntryPrice_at_Broker;
         ChangeMarketPosition(broker_mp - inner_mp, _exit_price, "Sync Order");
      end;

   end
   else begin
      text_setstring(textID, sync_state);
      mp_corrected = false ;
      mp_diff = false;
   end;

end; // is real time and strategy auto
