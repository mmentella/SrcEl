
inputs:
	BasedOnData(2),
	Formula( (close - close[1]) / close ),

	TraceOutput(false);


Vars: BarN(0), R(0);


// *** restrictions
once if barstatus(BasedOnData) < 0 then raiseruntimeerror("Portfolio Rank Signal Base needs datastream " + numtostr(BasedOnData, 0));
once if 1 <> getappinfo(aiisportfoliomode) then raiseruntimeerror("Portfolio Rank Signal Base can be applied to MCPortfolio application only.");
// ****************


once pmm_set_global_named_str("RankStrategyApplied", "true");


BarN = BarNumber of data(BasedOnData);

if BarN > BarN[1] then begin
	R = Formula of data(BasedOnData);
	pmm_set_my_named_num("RankStrategyR", R);
end;

if (TraceOutput) then begin
	print("CurrentBar = ", currentbar:0:0, ". Put MyIndicator value = ", R:0:5, " for symbol ", symbolname, ".");
end;


// *** Money management
begin
	var: MoneyCostForInvestPerCtrct(0), potential_entry_price(close);
	MoneyCostForInvestPerCtrct =
		pmms_calc_money_cost_for_entry_per_cntrct(potential_entry_price, Portfolio_GetMarginPerContract)
		+
		pmms_calc_money_cost_for_entry_per_cntrct(potential_entry_price, Portfolio_GetMaxPotentialLossPerContract);
		
	if 0 > MoneyCostForInvestPerCtrct then
		raiseruntimeerror( text("Error! Price = ", potential_entry_price:0:6, "PMargin = ", Portfolio_GetMarginPerContract, "PMaxPLoss = ",  Portfolio_GetMarginPerContract) );
		
	// MoneyCostForInvestPerCtrct in currency of the symbol. Convert it to portfolio currency ...
	pmm_set_my_named_num("MoneyCostForInvestPerCtrct", pmms_to_portfolio_currency(MoneyCostForInvestPerCtrct));
end;
// ********************

buy next bar market;
sellshort next bar market;

