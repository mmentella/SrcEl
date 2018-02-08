
Vars: ContractValue(0);
Vars: maxEq(0), dwdt(0);
Vars: lastDate(0), c1(0), c2(0);
Vars: winDays(0), lossDays(0), flatDays(0), opEq(0), lastEq(0), lastClose(0);
Vars: txtID(0), txtDate(0), txtTime(0), txtMax(0), txtMin(0);
Vars: winPerc(0), lossPerc(0), NetPerc(0);

Arrays: dwdts[12](0);

opEq = i_OpenEquity;

if CurrentBar <= 1 then
	ContractValue = BigPointValue * Close;

if Date > lastDate then begin

	txtDate = lastDate; txtTime = Time[1]; txtMax = High[1]; txtMin = Low[1];

	if opEq < maxEq then
		dwdt = dwdt + 1
	else begin
		for c1 = 0 to 11 begin
			if dwdt >= dwdts[c1] then begin
				for c2 = 10 downto c1 begin
					dwdts[c2 + 1] = dwdts[c2];
				end;
				dwdts[c1] = dwdt;
				c1 = 11;
			end;
		end;
		dwdt = 0;
		maxEq = opEq;
	end;

	if lastDate > 0 then begin
		if opEq[1] > lastEq then winDays = winDays + 1
		else if opEq[1] < lastEq then lossDays = lossDays + 1
		else flatDays = flatDays + 1;
		if lastEq <> 0 then
			if opEq[1] > lastEq then winPerc = winPerc + (opEq[1] - lastEq) / (BigPointValue * lastClose)
			else if opEq[1] < lastEq then lossPerc = lossPerc + (lastEq - opEq[1]) / (BigPointValue * lastClose);
	end;
	
	lastEq = opEq[1];
	lastClose = Close[1];
	lastDate = Date;

end;

plot1(dwdt, "DWD-time");

if LastBarOnChart then begin
	for c1 = 0 to 11 begin
		if dwdt >= dwdts[c1] then begin
			for c2 = 10 downto c1 begin
				dwdts[c2 + 1] = dwdts[c2];
			end;
			dwdts[c1] = dwdt;
			c1 = 11;
		end;
	end;
	plot2(dwdts[0], "MAX DWDT 1");
	plot3(dwdts[1], "MAX DWDT 2");
	plot4(dwdts[2], "MAX DWDT 3");
	plot5(dwdts[3], "MAX DWDT 4");
	plot6(dwdts[4], "MAX DWDT 5");
	plot7(dwdts[5], "MAX DWDT 6");
	plot8(dwdts[6], "MAX DWDT 7");
	plot9(dwdts[7], "MAX DWDT 8");
	plot10(dwdts[8], "MAX DWDT 9");
	plot11(dwdts[9], "MAX DWDT 10");
	plot12(dwdts[10], "MAX DWDT 11");
	plot13(dwdts[11], "MAX DWDT 12");

	if opEq > lastEq then winDays = winDays + 1
	else if opEq < lastEq then lossDays = lossDays + 1
	else flatDays = flatDays + 1;
	if lastEq <> 0 then
		if opEq > lastEq then winPerc = winPerc + (opEq - lastEq) / (BigPointValue * lastClose)
		else if opEq < lastEq then lossPerc = lossPerc + (lastEq - opEq) / (BigPointValue * lastClose);
//	Print("Days Profit.: " + NumToStr(winDays / (lossDays + winDays) * 100, 2) + "%");
	if lossDays + winDays > 0 then begin
		txtID = Text_New(txtDate, txtTime, txtMax,
		                 "Traded days: " + NumToStr(lossDays + winDays, 0) + "/" + NumToStr(lossDays + winDays + flatDays, 0) +
		                 " (" + NumToStr((lossDays + winDays) / (lossDays + winDays + flatDays) * 100, 2) + "%)");
		Text_SetBGColor(txtID, White); Text_SetColor(txtID, Black);
		txtID = Text_New(txtDate, txtTime, txtMin,
		                 "Days Profit: " + NumToStr(winDays, 0) + "/" + NumToStr(lossDays + winDays, 0) +
		                 " (" + NumToStr(winDays / (lossDays + winDays) * 100, 2) + "%)");
		Text_SetBGColor(txtID, White); Text_SetColor(txtID, Black);
		txtID = Text_New(txtDate, txtTime, (txtMin + txtMax) / 2,
		                 "Daily Win%: " + NumToStr(winPerc / winDays * 100, 2) + "%, " +
		                 "Daily Loss%: " + NumToStr(lossPerc / lossDays * 100, 2) + "%, " +
		                 "Return%: " + NumToStr(opEq / ContractValue * 100, 2) + "%");
		Text_SetBGColor(txtID, White); Text_SetColor(txtID, Black);
	end;

end;
