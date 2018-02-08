
Inputs: LoopBackDays(5), AvgLength(22), EUROconv(1);


Variables: Factor$(IFF(EUROconv > 0, EUROconv * BigPointValue, 1));


Vars: exc$(0), avg$(0);


if CurrentBar <= 1 then begin
	if BarType_ex < 2 then
		RaiseRunTimeError(NewLine + "Time Frame not fixed")
	else
	if BarType_ex > 4 then
		RaiseRunTimeError(NewLine + "Time Frame too large");
end;

exc$ = ExcursionAverage(LoopBackDays, 1) * Factor$;
avg$ = ExcursionAverage(LoopBackDays, AvgLength) * Factor$;

Plot1(0, "Zero");
Plot2(exc$, "Excursion");
Plot3(avg$, "Average");
