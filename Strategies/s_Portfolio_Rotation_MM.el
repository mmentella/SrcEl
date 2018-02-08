once cleardebug;

inputs:
	BuyBestX(10),
	SellWorstY(10);
	
Input: use_logging(false);

variables: idx(0), strategyIdx(0), strategyValue(0);
arrays: allStrategies[10000, 1](-1);

if getappinfo(aiisportfoliomode) <> 1 then
	raiseruntimeerror("Signal can be applied (as Money Management Signal) in Portfolio only.");
	
if pmms_strategies_count < BuyBestX + SellWorstY then
	raiseruntimeerror(text("Portfolio has not enough instruments: instruments number = ", pmms_strategies_count, "; BuyBestX = ", BuyBestX, "; SellWorstY = ", SellWorstY));


pmms_strategies_deny_entries_all;

for strategyIdx = 0 to pmms_strategies_count - 1 begin
	strategyValue = pmms_get_strategy_named_num(strategyIdx, "RotationalValue");
	allStrategies[strategyIdx , 0] = strategyValue;
	allStrategies[strategyIdx , 1] = strategyIdx;
end;

Sort2DArrayByKey(allStrategies, pmms_strategies_count, 1);

variables: inLong(0), inShort(0);
arrays: strategiesLong[](-1), strategiesShort[](-1);
inLong = pmms_strategies_in_long_count(strategiesLong);
inShort = pmms_strategies_in_short_count(strategiesShort);

if use_logging then
	print( "strategies in position: long=",inLong, ", short=", inShort );

var : cur_idx(0);

for idx = 0 to BuyBestX - 1 begin
	cur_idx = allStrategies[idx, 1];
	
	if (not array_contains(strategiesLong, cur_idx)) then
		pmms_strategy_allow_long_entries(cur_idx)
	else
		strategiesLong[array_indexof(strategiesLong, cur_idx)] = -1;
		
	if use_logging then
		print( "strategy ", pmms_strategy_symbol(cur_idx), "long entry" );
		
	if UsePortfolioMoneyPcnt then
		pmms_strategy_set_entry_contracts(
			cur_idx,
			pmms_calc_contracts_for_entry( PortfolioMoneyPcntForEntry, cur_idx )
		);
end;

for idx = pmms_strategies_count - 1 downto pmms_strategies_count - SellWorstY begin
	cur_idx = allStrategies[idx, 1];

	if (not array_contains(strategiesShort, cur_idx)) then
		pmms_strategy_allow_short_entries(cur_idx)
	else
		strategiesShort[array_indexof(strategiesShort, cur_idx)] = -1;
		
	if use_logging then
		print( "strategy ", pmms_strategy_symbol(cur_idx), "short entry" );
		
	if UsePortfolioMoneyPcnt then
		pmms_strategy_set_entry_contracts(
			cur_idx,
			pmms_calc_contracts_for_entry( PortfolioMoneyPcntForEntry, cur_idx )
		);	
end;

// force positions close
for idx = 0 to inLong - 1 begin
	value1 = strategiesLong[idx];
	if value1 >= 0 then begin
		pmms_strategy_close_position(value1);		
		if use_logging then
			print( "strategy ", pmms_strategy_symbol(value1), "force position close" );
	end;
end;

for idx = 0 to inShort - 1 begin
	value1 = strategiesShort[idx];
	if value1 >= 0 then begin
		pmms_strategy_close_position(value1);
		if use_logging then
			print( "strategy ", pmms_strategy_symbol(value1), "force position close" );
	end;
end;


// money management
inputs:
	UsePortfolioMoneyPcnt(False),
	PortfolioMoneyPcntForEntry(1);

if use_logging then
	print("------------------------------------------------------------------")
