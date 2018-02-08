input: Period(0); {0=monthly, 1=daily}

if LastBarOnChart_s then begin
	value1 = SharpeRatio(Period, InterestRate, LastBarOnChart_s, InitialCapital);
	SetCustomFitnessValue(value1);
end;
