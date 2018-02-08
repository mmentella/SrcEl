inputs: Ratio(c / c data2), Length(10), PercentOfEquity(10);

var: AvgRatio(0), StdDevRatio(0);
var: intrabarpersist cur_pos(0);
var: Contracts_(0);

if (currentbar < Length) then #return;

Contracts_ = Portfolio_Equity * PercentOfEquity / 100;

if 1 < currentbar then begin
	if AvgRatio + StdDevRatio < Ratio then begin// short data1, long data2
		if -1 <> cur_pos then begin
			sellshort Contracts_ contracts this bar at c;
			cur_pos = -1;
		end;
	end else if AvgRatio - StdDevRatio > Ratio then begin// buy data1, short data2
		if 1 <> cur_pos then begin
			buy Contracts_ contracts this bar at c;
			cur_pos = 1;
		end;
	end else begin
		cur_pos = 0;
		sell this bar c;
		buytocover this bar c;
	end;
end;

AvgRatio = XAverage(Ratio, Length);
StdDevRatio = StdDev(Ratio, Length);

if 1 = getappinfo(aiisportfoliomode) then begin

	var: slave_idx(pmms_strategies_get_by_symbol_name(symbolname data2));
	once if 0 > slave_idx then
		raiseruntimeerror(text("specified slave trader on instrument ", doublequote, symbolname data2, doublequote, "not found"));

	value22 = absvalue(cur_pos*Contracts_) * c * bigpointvalue;
	if 0 < value22 then
		value22 = pmms_to_portfolio_currency(value22);

	pmms_set_strategy_named_num(slave_idx, "MPMoney", -cur_pos * value22);
end;
