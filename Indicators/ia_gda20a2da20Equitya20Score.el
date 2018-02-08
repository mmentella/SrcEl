
Vars: Finalize(false);
Vars: opEq(0), maxEq(0), dayN(1), stDev(0), strDev("");
Vars: dwdt(0), dwdtMax(0), dwdq(0), dwdqMax(0);
Vars: sumYp2(0), sumXp2(0), sumXY(0);
Vars: alfa(0), pf(""), ret(""), str("");
Vars: opEq0(0), score(0);
Vars: refDate(0), maxSlope(0);
Vars: txtID(0), lastDate(0), lastTime(0), lastClose(0);


if CurrentBar <= 1 then
	refDate = CalcDate(Date, 365);

Finalize = LastBarOnChart;
if Finalize then opEq = i_OpenEquity;

if Date > Date[1] or Finalize then begin
	lastDate = Date[1]; lastTime = Time[1]; lastClose = Close[1];

	if opEq <= maxEq then begin
		dwdt = dwdt + 1;
		if opEq - maxEq < dwdq then dwdq = opEq - maxEq;
	end
	else begin
		if dwdt > dwdtMax then dwdtMax = dwdt;
		if dwdq < dwdqMax then dwdqMax = dwdq;
		maxEq = opEq;
		dwdt = 0;
		dwdq = 0;
	end;

	dayN = dayN + 1;
	sumYp2 = sumYp2 + opEq * opEq;
	sumXp2 = sumXp2 + dayN * dayN;
	sumXY = sumXY + opEq * dayN;

	if Date > refDate then begin
		alfa = opEq / dayN;
		if alfa > maxSlope then maxSlope = alfa;
	end;

end;

opEq = i_OpenEquity;

if Finalize then begin

	if dwdt > dwdtMax then dwdtMax = dwdt;
	if dwdq < dwdqMax then dwdqMax = dwdq;
	alfa = opEq / dayN;
	if alfa > 0 then begin
		stDev = SquareRoot((sumYp2 + alfa * alfa * sumXp2 - 2 * alfa * sumXY) / dayN) / opEq;
		score = 20 / (1 + Power(20, stDev));
		//score = 10 / (1 + stDev * stDev);
		alfa = score * alfa / maxSlope;
	end;

	plot1(NumToStr(alfa, 1),"Perc Slope");
	plot2(NumToStr(score, 1),"Score");
	plot3(stDev,"MSE");

end;
