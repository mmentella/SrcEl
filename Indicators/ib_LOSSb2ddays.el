
Inputs: EUROconv(1);


Vars: loss(0), shift(0), n(0), cl(0);
Vars: c1(0), c2(0);
Vars: opEq(0), lastEq(0);
Vars: sumWin(0), sumLoss(0);
Vars: txtID(0), txtDate(0), txtTime(0), txtPos(0);

Vars: listNum(16), listLast(listNum - 1);
Arrays: losses[16](0);


opEq = i_OpenEquity;


if Date > Date[1] then begin

	txtDate = Date[1]; txtTime = Time[1]; txtPos = 0.5 * (High[1] + Low[1]);

	loss = (opEq[1] - lastEq) * EUROconv;
	if loss >= 0 then begin
		cl = Green; sumWin = sumWin + loss;
	end else begin
		cl = Red; sumLoss = sumLoss + loss;
	end;
	plot1[shift](loss, "DayGain", White);
	for n = shift - 1 downto 1 begin plot1[n](loss, "DayGain", cl); end;
	if loss = 0 then cl = White;
	Plot20[shift](0, "MinLevel", cl);
	shift = 1;

	if loss < 0 then begin
		for c1 = 0 to listLast begin
			if loss <= losses[c1] then begin
				for c2 = listLast - 1 downto c1 begin
					losses[c2 + 1] = losses[c2];
				end;
				losses[c1] = loss;
				c1 = listLast;
			end;
		end;
	end;
	
	lastEq = opEq[1];

end
else
	shift = shift + 1;

if LastBarOnChart then begin

	loss = (opEq - lastEq) * EUROconv;
	if loss >= 0 then begin
		cl = Green; sumWin = sumWin + loss;
	end else begin
		cl = Red; sumLoss = sumLoss + loss;
	end;
	for n = 1 to shift begin plot1[n](loss, "DayGain", cl); end;
	if loss = 0 then cl = White;
	Plot20[shift](0, "MinLevel", cl);
	Plot20(0, "MinLevel", cl);

	for c1 = 0 to listLast begin
		if loss <= losses[c1] then begin
			for c2 = listLast - 1 downto c1 begin
				losses[c2 + 1] = losses[c2];
			end;
			losses[c1] = loss;
			c1 = listLast;
		end;
	end;

	plot2(losses[0], "MAX loss 1");
	plot3(losses[1], "MAX loss 2");
	plot4(losses[2], "MAX loss 3");
	plot5(losses[3], "MAX loss 4");
	plot6(losses[4], "MAX loss 5");
	plot7(losses[5], "MAX loss 6");
	plot8(losses[6], "MAX loss 7");
	plot9(losses[7], "MAX loss 8");
	plot10(losses[8], "MAX loss 9");
	plot11(losses[9], "MAX loss 10");
	plot12(losses[10], "MAX loss 11");
	plot13(losses[11], "MAX loss 12");
	plot14(losses[12], "MAX loss 12");
	plot15(losses[13], "MAX loss 13");
	plot16(losses[14], "MAX loss 14");
	plot17(losses[15], "MAX loss 15");

	if sumLoss < 0 then begin
		txtID = Text_New(txtDate, txtTime, txtPos, " Daily Profit Factor: " + NumToStr(sumWin / -sumLoss, 2) + " "
		      + "( " + NumToStr(sumWin, 0) + " / " + NumToStr(-sumLoss, 0) + " ) ");
		Text_SetBGColor(txtID, White); Text_SetColor(txtID, Black);
	end;

end;
