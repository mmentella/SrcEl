
inputs:
	ContractsNumber(200),

	IgnoreContractsNumberUsePcnt(false),
	PortfolioBalancePercent(1),

	StdDevLength(14),

	BuyBestN(10),
	SellWorseN(10),

	TraceOutput(false);


variables: AvgReturn(0), SDev(0), portfolioStrategies(0), idx(0), strIdx(0), lots(0);
array: BaseR[](0), ContractsForEntry[](0), Value_Idx[2, 10000](0);


// *** restrictions
once if 1 <> getappinfo(aiisportfoliomode) then raiseruntimeerror("Portfolio Rank Money Management Signal can be applied for MCPortfolio application only.");
//once if "true" <> pmm_get_global_named_str("RankStrategyApplied") then raiseruntimeerror("Portfolio Rank Monem Management Signal can be applied in pair with Portfolio Rank Signal Base only.");
once if pmms_strategies_count() > 10000 then raiseruntimeerror("Portfolio Rank Money Management Signal too much intruments, max value = " + numtostr(100000, 0));
once if pmms_strategies_count() < BuyBestN + SellWorseN then raiseruntimeerror("Portfolio Rank Monem Management Signal, please check inputs, BuyBestN + SellWorseN should be less or equal to tradable Instruments number");
// ****************


once begin
	portfolioStrategies = pmms_strategies_count();
	array_setmaxindex(BaseR, portfolioStrategies);
	array_setmaxindex(ContractsForEntry, portfolioStrategies);
end;

pmms_strategies_deny_entries_all;

AvgReturn = 0;

for idx = 0 to portfolioStrategies - 1 begin
	BaseR[idx] = pmms_get_strategy_named_num(idx, "RankStrategyR");
	AvgReturn += BaseR[idx];
end;

AvgReturn /= portfolioStrategies;
SDev = StandardDev(AvgReturn, StdDevLength, 1);
if (SDev = 0) then SDev = 1;

for idx = 0 to portfolioStrategies - 1 begin
	Value_Idx[1, idx + 1] = ( BaseR[idx] - AvgReturn ) / SDev;
	Value_Idx[2, idx + 1] = idx;

	if IgnoreContractsNumberUsePcnt then begin
		ContractsForEntry[idx] = pmms_calc_contracts_for_entry(PortfolioBalancePercent, idx);
	end
	else
		ContractsForEntry[idx] = ContractsNumber;
end;

Sort2DArray(Value_Idx, 2, portfolioStrategies, -1 {from low to high});

variables: inLong(0), inShort(0);
array: strategyIndexes[](0);

inLong = pmms_strategies_in_long_count(strategyIndexes);
for idx = 1 to BuyBestN - inLong begin
	strIdx = Value_Idx[2, idx];
	pmms_strategy_set_entry_contracts(strIdx, ContractsForEntry[strIdx]);
	pmms_strategy_allow_long_entries(strIdx);
	if TraceOutput then
		print("CurrentBar = ", currentbar:0:0, ". Allow LONG for symbol ", pmms_strategy_symbol(strIdx), ", Contracts = ", ContractsForEntry[strIdx]);
end;

inShort = pmms_strategies_in_short_count(strategyIndexes);
for idx = portfolioStrategies downto portfolioStrategies - SellWorseN + inShort + 1 begin
	strIdx = Value_Idx[2, idx];
	pmms_strategy_set_entry_contracts(strIdx, ContractsForEntry[strIdx]);
	pmms_strategy_allow_short_entries(strIdx);
	if TraceOutput then
		print("CurrentBar = ", currentbar:0:0, ". Allow SHORT for symbol ", pmms_strategy_symbol(strIdx), ", Contracts = ", ContractsForEntry[strIdx]);
end;

