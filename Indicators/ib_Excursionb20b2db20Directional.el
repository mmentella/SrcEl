
Inputs: DaysBack(5), AveragePeriod(1), EUROconv(1), Conservative(true);

Variables: factor(IFF(EUROconv <= 0, 1, BigPointValue * EUROconv));
Variables: Len1(AveragePeriod - 1);

Arrays: excL[22](0), excS[22](0);

Vars: ML(0), MS(0), avgL(0), avgS(0), maxL(0), maxS(0);
Vars: nDay(0), len(0), cnt(0);

ML = gd.PositiveExcursion(High, Low, DaysBack, Conservative) * factor;
MS = gd.NegativeExcursion(High, Low, DaysBack, Conservative) * factor;

if Date > Date[1] then begin
	nDay = nDay +1; len = MinList(AveragePeriod, nDay);
	for cnt = len1 downto 1 begin
		excL[cnt] = excL[cnt - 1]; excS[cnt] = excS[cnt - 1]; end;
	excL[0] = ML; excS[0] = MS;
	avgL = AverageArray(excL, len);
	avgS = AverageArray(excS, len);
	maxL = gd.HighestArray(excL, len);
	maxS = gd.LowestArray(excS, len);
end;

Plot1(ML, "Excursion Long");
Plot2(MS, "Excursion Short");
Plot3(avgL, "Average Long");
Plot4(avgS, "Average Short");
Plot5(maxL, "Max Long");
Plot6(maxS, "Max Short");

Plot10(0, "Zero");
