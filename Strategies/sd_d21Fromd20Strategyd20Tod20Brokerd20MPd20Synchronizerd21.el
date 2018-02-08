[intrabarordergeneration = true];

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

Input : TimeOutMS(1000), LatencyMS(1000);

variables:
	textID( text_new_s(d, time_s, c,"CurrentState") ),
	intrabarpersist sync_state("MP is synchronized!"),
	intrabarpersist diff_state("MP syncronization. Wait "),
	intrabarpersist correction_state("MP correction order sent. Wait "),

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

	correct_contracts(0),
	is_buy(false),
	is_entry(true);


if getappinfo(airealtimecalc) = 1 and getappinfo(aistrategyauto) = 1 then begin

once begin
	print( text_setstyle(textID, 1, 0) );
	diff_state += text(TimeOutMS*.001, " seconds."); 
	correction_state += text(LatencyMS*.001, " seconds."); 
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
		if mp_diff and not mp_corrected and _get_tick_count - mp_diff_time_start > TimeOutMS then begin
			place_correction_marketorder = true ;
			mp_corrected = true ;
			mp_corrected_time_start = _get_tick_count ;
		end;

// correction state
		if mp_corrected then begin
			text_setstring(textID, correction_state);
			if _get_tick_count - mp_corrected_time_start > LatencyMS then begin
				mp_corrected_time_start = _get_tick_count ;
				mp_diff = false;
				mp_corrected = false;
			end;
		end;

// place correction order
		if place_correction_marketorder then begin
			correct_contracts = absvalue(broker_mp - inner_mp);
			place_correction_marketorder = false ;

			is_buy = ifflogic( broker_mp > inner_mp, false, true);

			PlaceMarketOrder(is_buy, true, correct_contracts);
		end;

	end
	else begin
		text_setstring(textID, sync_state);
		mp_corrected = false ;
		mp_diff = false;
	end;

end; // is real time and strategy auto
