
inputs: 
	Formula(PercentChange(close, 14));

variables: formulaValue(0);

formulaValue = Formula;

if getappinfo(aiisportfoliomode) <> 1 then
	raiseruntimeerror("Signal can be used in Portfolio only.");

pmm_set_my_named_num("RotationalValue", formulaValue);

buy("LE") next bar market;
sellshort("SE") next bar market;

pmm_set_my_status(
	iffstring(marketposition = 0, "Flat",
		iffstring(marketposition = 1, "Long", "Short")
	)
);

// money management
var: PotentialEntryPrice(close), MoneyCostForInvestPerCtrct(0);

if (entryprice > 0) then PotentialEntryPrice = entryprice;

MoneyCostForInvestPerCtrct =
	pmms_calc_money_cost_for_entry_per_cntrct(PotentialEntryPrice, Portfolio_GetMarginPerContract)
	+
	pmms_calc_money_cost_for_entry_per_cntrct(PotentialEntryPrice, Portfolio_GetMaxPotentialLossPerContract);
	
if 0 > MoneyCostForInvestPerCtrct then
	raiseruntimeerror( text("Error! Price = ", PotentialEntryPrice:0:6, ", PMargin = ", Portfolio_GetMarginPerContract, ", PMaxPLoss = ", Portfolio_GetMaxPotentialLossPerContract));
	
// MoneyCostForInvestPerCtrct in currency of the symbol. Convert it to portfolio currency ...
pmm_set_my_named_num("MoneyCostForInvestPerCtrct", pmms_to_portfolio_currency(MoneyCostForInvestPerCtrct));

// exits
inputs: StopLossPcntsOfPortfolio(0.1),
	ProfitTargetPcntsOfPortfolio(0.1);
variable: value(0);

setstopposition;
value = StopLossPcntsOfPortfolio * 0.01 * Portfolio_Equity;
setstoploss(convert_currency(datetime[0], portfolio_CurrencyCode, SymbolCurrencyCode, value));
value = ProfitTargetPcntsOfPortfolio * 0.01 * Portfolio_Equity;
setprofittarget(convert_currency(datetime[0], portfolio_CurrencyCode, SymbolCurrencyCode, value));

