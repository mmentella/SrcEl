{******** - WriteRinaXML - ********
 RINA-export format 'strategy'
 Author: Giulio D'Urso
         Romana Acquisizioni S.r.l.
 Year: 2010
 Update: 10/03/2010
***********************************}

Input: System             ("Market-Strategy_Name"),        { file name to write results to }
       CurrencyConversion (1),                             { currency conversion factor }
       FilePath           ("C:\Portafoglio\RINAtrades"),   { path for result file }
       Intraday           (false);

Vars: TradesFile(""), FirstBar(true), Done(false), LastDate(0);
Vars: tm(0), hh(0), nd(0), dbl(0.0), cnt(0), ncg(0), ncm(0);
Vars: barOpen(0), barHigh(0), barLow(0), barClose(0), barVolume(0), barDate(0), barTime(0), lastBarTime(0);
Vars: Eline(""), Xline("");
Vars: Ntrade(0), modal(false), Nmodal(0), profit(0.0), price(0.0);

Vars: ModNum(0);
Arrays: ModEdate[1024](0), ModEtime[1024](0), ModXdate[1024](0), ModXtime[1024](0), ModXcontracts[1024](0);

//Vars: CALLS(0);

if not Done then begin

//CALLS = CALLS + 1;
//Print(StrNow, ": Call n.", NumToStr(CALLS, 0));

//
//  HEADER INFO
//
if FirstBar then begin

	TradesFile = FilePath;
	if RightStr(FilePath, 1) <> "\" then
		TradesFile = TradesFile + "\";
	TradesFile = TradesFile + System + ".xml";

	dbl = MinMove / PriceScale;
	while dbl < 1 begin
		nd = nd + 1;
		dbl = dbl * 10;
	end;

	FileDelete(TradesFile);
	FileAppend(TradesFile, "<?xml version='1.0'?>" + NewLine +
                           "<SystemMarket>" + NewLine +
	                       "<SystemInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>SystemName</Name><Value>0</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>PointValue</Name><Value>" + NumToStr(PointValue * CurrencyConversion, 3) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>PriceConversion</Name><Value>" + NumToStr(PriceScale, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Commission</Name><Value>" + NumToStr(Commission * 2 * CurrencyConversion, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Slippage</Name><Value>" + NumToStr(Slippage * 2 * CurrencyConversion, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>WorkspaceName</Name><Value>" + System + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>WindowID</Name><Value>1</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>System</Name><Value>" + System + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Commission</Name><Value>" + NumToStr(Commission * 2 * CurrencyConversion, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Slippage</Name><Value>" + NumToStr(Slippage * 2 * CurrencyConversion, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>PointValue</Name><Value>" + NumToStr(PointValue * CurrencyConversion, 3) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>PriceConversion</Name><Value>" + NumToStr(PriceScale, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Margin</Name><Value>" + NumToStr(Margin, 0) + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Symbol</Name><Value>" + GetSymbolName + "</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>Description</Name><Value>" + Description + "</Value></SysInfo>" + NewLine);
	if BarType < 2 then
		FileAppend(TradesFile, "<SysInfo><Name>Compression</Name><Value>" + NumToStr(BarInterval, 0) + " min.</Value></SysInfo>" + NewLine)
	else
	if BarType = 2 then begin
		if BarInterval = 1 then
			FileAppend(TradesFile, "<SysInfo><Name>Compression</Name><Value>daily</Value></SysInfo>" + NewLine)
		else
			FileAppend(TradesFile, "<SysInfo><Name>Compression</Name><Value>" + NumToStr(BarInterval, 0) + " days</Value></SysInfo>" + NewLine);
	end else
	if BarType = 3 then
		FileAppend(TradesFile, "<SysInfo><Name>Compression</Name><Value>" + NumToStr(BarInterval, 0) + " weeks</Value></SysInfo>" + NewLine)
	else
	if BarType = 4 then
		FileAppend(TradesFile, "<SysInfo><Name>Compression</Name><Value>" + NumToStr(BarInterval, 0) + " months</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>VersionType</Name><Value>I</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>PerUnitCommission</Name><Value>Y</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>PerUnitSlippage</Name><Value>Y</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>InitialCapital</Name><Value>0</Value></SysInfo>" + NewLine);
	FileAppend(TradesFile, "<SysInfo><Name>InterestRate</Name><Value>5</Value></SysInfo>" + NewLine);

	// Strategy Inputs (???)
	//FileAppend(TradesFile, "<SysInfo><Name>Input1</Name><Value>gdStoch16CAC_NoS(2)</Value></SysInfo>" + NewLine);
	//FileAppend(TradesFile, "<SysInfo><Name>Input2</Name><Value>gdStoch16CAC_FKmaxDomain(180)</Value></SysInfo>" + NewLine);
	//FileAppend(TradesFile, "<SysInfo><Name>Input3</Name><Value>gdStoch16CAC_FKdeltaDomain(100)</Value></SysInfo>" + NewLine);

	FileAppend(TradesFile, "</SystemInfo>" + NewLine);
	FileAppend(TradesFile, "<Prices>" + NewLine);
	
	tm = TimeToMinutes(Time);
	hh = IntPortion(tm / 60);
	FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(Date), 0) +
	                       "</Year><Month>" + NumToStr(Month(Date), 0) + "</Month><Day>" + NumToStr(DayOfMonth(Date), 0) +
	                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
	                       "</Minute></Date><Open>" + NumToStr(Open, nd) +
	                       "</Open><High>" + NumToStr(High, nd) +
	                       "</High><Low>" + NumToStr(Low, nd) +
	                       "</Low><Close>" + NumToStr(Close, nd) +
	                       "</Close><Volume>" + NumToStr(Volume, 0) + "</Volume></Bar>" + NewLine);
	lastBarTime = Time;
	FirstBar = false;

end;

//
//  LIST OF BARS (too many, limited to "variable" ones
//
//<Bar><Date><Year>2009</Year><Month>7</Month><Day>15</Day><Hour>9</Hour><Minute>0</Minute></Date>
//     <Open>3100.5</Open><High>3101</High><Low>3095</Low><Close>3095.5</Close><Volume>105</Volume></Bar>
{
tm = TimeToMinutes(Time);
hh = IntPortion(tm / 60);
FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900+Year(Date), 0) + "</Year><Month>" + NumToStr(Month(Date), 0) + "</Month><Day>" + NumToStr(DayOfMonth(Date), 0) +
                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
                       "</Minute></Date><Open>" + NumToStr(O, nd) + "</Open><High>" + NumToStr(H, nd) + "</High><Low>" + NumToStr(L, nd) + "</Low><Close>" + NumToStr(C, nd) +
                       "</Close><Volume>" + NumToStr(Volume, 0) + "</Volume></Bar>" + NewLine);
}
// Date changed "closing" bar
//
if Date > LastDate then begin

	if barOpen > 0 then begin
		if Sess1EndTime > lastBarTime then begin
			tm = TimeToMinutes(Sess1EndTime);
			hh = IntPortion(tm / 60);
			if Intraday then
				FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(barDate), 0) +
				                       "</Year><Month>" + NumToStr(Month(barDate), 0) + "</Month><Day>" + NumToStr(DayOfMonth(barDate), 0) +
				                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
				                       "</Minute></Date><Open>" + NumToStr(barOpen, nd) +
				                       "</Open><High>" + NumToStr(barHigh, nd) +
				                       "</High><Low>" + NumToStr(barLow, nd) +
				                       "</Low><Close>" + NumToStr(barClose, nd) +
				                       "</Close><Volume>" + NumToStr(0, 0) + "</Volume></Bar>" + NewLine)
            else
				FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(barDate), 0) +
				                       "</Year><Month>" + NumToStr(Month(barDate), 0) + "</Month><Day>" + NumToStr(DayOfMonth(barDate), 0) +
				                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
				                       "</Minute></Date><Open>" + NumToStr(barClose, nd) +
				                       "</Open><High>" + NumToStr(barClose, nd) +
				                       "</High><Low>" + NumToStr(barClose, nd) +
				                       "</Low><Close>" + NumToStr(barClose, nd) +
				                       "</Close><Volume>" + NumToStr(0, 0) + "</Volume></Bar>" + NewLine);
			//Print(StrNow, ") New Date: ", Date:7:0, " - ", barDate:7:0, "-Bar@", Sess1EndTime:4:0);
		end;
		barOpen = 0;
	end;
	lastBarTime = 0;
{
	tm = TimeToMinutes(Time);
	hh = IntPortion(tm / 60);
	FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(Date), 0) +
	                       "</Year><Month>" + NumToStr(Month(Date), 0) + "</Month><Day>" + NumToStr(DayOfMonth(Date), 0) +
	                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
	                       "</Minute></Date><Open>" + NumToStr(Open, nd) +
	                       "</Open><High>" + NumToStr(High, nd) +
	                       "</High><Low>" + NumToStr(Low, nd) +
	                       "</Low><Close>" + NumToStr(Close, nd) +
	                       "</Close><Volume>" + NumToStr(Volume, 0) + "</Volume></Bar>" + NewLine);
	lastBarTime = Time;
	//Print(StrNow, ") New Date: ", Date:7:0, " - ", Date:7:0, "-Bar@", Time:4:0);
	barOpen = -1;
}
	LastDate = Date;
end;

// Check Market order-status changes: global entry / global-partial exits
//
if (EntryDate = Date and EntryTime = Time)                                // if just entered
or (ExitDate(1) = Date and ExitTime(1) = Time)                            // or just exited
or (MarketPosition <> 0 and CurrentContracts < MaxContracts) then begin   // or changed contracts number while at market

	if Intraday then begin

		if barOpen > 0 then begin
			if barTime > lastBarTime then begin
				tm = TimeToMinutes(barTime);
				hh = IntPortion(tm / 60);
				FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(barDate), 0) +
				                       "</Year><Month>" + NumToStr(Month(barDate), 0) + "</Month><Day>" + NumToStr(DayOfMonth(barDate), 0) +
				                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
				                       "</Minute></Date><Open>" + NumToStr(barOpen, nd) +
				                       "</Open><High>" + NumToStr(barHigh, nd) +
				                       "</High><Low>" + NumToStr(barLow, nd) +
				                       "</Low><Close>" + NumToStr(barClose, nd) +
				                       "</Close><Volume>" + NumToStr(0, 0) + "</Volume></Bar>" + NewLine);
				lastBarTime = barTime;
			end;
			barOpen = 0;
			//Print(StrNow, ") Before Entry/Change/Exit Trade - ", barDate:7:0, "-Bar@", barTime:4:0);
		end;

		if Time > lastBarTime and barOpen >= 0 then begin
			tm = TimeToMinutes(Time);
			hh = IntPortion(tm / 60);
			FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(Date), 0) +
			                       "</Year><Month>" + NumToStr(Month(Date), 0) + "</Month><Day>" + NumToStr(DayOfMonth(Date), 0) +
			                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
			                       "</Minute></Date><Open>" + NumToStr(Open, nd) +
			                       "</Open><High>" + NumToStr(High, nd) +
			                       "</High><Low>" + NumToStr(Low, nd) +
			                       "</Low><Close>" + NumToStr(Close, nd) +
			                       "</Close><Volume>" + NumToStr(0, 0) + "</Volume></Bar>" + NewLine);
			lastBarTime = Time;
			//Print(StrNow, ") AT Entry/Change/Exit Trade - ", Date:7:0, "-Bar@", Time:4:0);
	    end;
		barOpen = -1;

	end;

	// Manage Modal Exits
	//
	if MarketPosition <> 0 then begin
		if CurrentContracts < MaxContracts
		and (ModNum = 0 or EntryDate > ModEdate[ModNum - 1] or EntryTime > ModEtime[ModNum - 1]) then begin
			ModEdate[ModNum] = EntryDate;
			ModEtime[ModNum] = EntryTime;
			ModXdate[ModNum] = Date;
			ModXtime[ModNum] = Time;
			ModXcontracts[ModNum] = MaxContracts - CurrentContracts;
			//Print("Modal n.", NumToStr(ModNum + 1, 0), " (wide, ", NumToStr(ModXcontracts[ModNum], 0), ") @ ", ModEdate[ModNum]:7:0, " ", ModEtime[ModNum]:4:0, "  -  ", ModXdate[ModNum]:7:0, " ", ModXtime[ModNum]:4:0);
			ModNum = ModNum + 1;
		end;
	end;
	//
	if (ExitDate(1) = Date and ExitTime(1) = Time)
	and (ModNum = 0 or EntryDate(1) > ModEdate[ModNum - 1] or EntryTime(1) > ModEtime[ModNum - 1]) then begin
		if MarketPosition(1) > 0 then
			price = EntryPrice(1) + (PositionProfit(1) / MaxContracts(1) + 2 * (Commission + Slippage)) / BigPointValue
		else
			price = EntryPrice(1) - (PositionProfit(1) / MaxContracts(1) + 2 * (Commission + Slippage)) / BigPointValue;
		if ExitPrice(1) <> price then begin
			ModEdate[ModNum] = EntryDate(1);
			ModEtime[ModNum] = EntryTime(1);
			ModXdate[ModNum] = ExitDate(1);
			ModXtime[ModNum] = ExitTime(1);
			ModXcontracts[ModNum] = Ceiling(MaxContracts(1) / 2);
			//Print("Modal n.", NumToStr(ModNum + 1, 0), " (exit, ", NumToStr(ModXcontracts[ModNum], 0), ") @ ", ModEdate[ModNum]:7:0, " ", ModEtime[ModNum]:4:0, "  -  ", ModXdate[ModNum]:7:0, " ", ModXtime[ModNum]:4:0, ": ", price, " vs. ", ExitPrice(1));
			ModNum = ModNum + 1;
		end;
	end;

end;

// Populate current growing bar values
//
if barOpen < 0 then
	barOpen = barOpen + 1
else
if barOpen = 0 then begin
	barOpen = Open;
	barHigh = High;
	barLow = Low;
	barClose = Close;
	barDate = Date;
	barTime = Time;
end
else begin
	if Low < barLow then barLow = Low;
	if High > barHigh then barHigh = High;
	barClose = Close;
	barTime = Time;
end;

Ntrade = TotalTrades;

//
//  LIST OF TRADES
//
if LastBarOnChart then begin

//<Trades>
//<Trade><Date><Year>2009</Year><Month>7</Month><Day>23</Day><Hour>13</Hour><Minute>45</Minute></Date><Type>Buy</Type><Quantity>2</Quantity><Price>3294</Price><Signal>EL</Signal></Trade>
//<Trade><Date><Year>2009</Year><Month>7</Month><Day>28</Day><Hour>17</Hour><Minute>30</Minute></Date><Type>LExit</Type><Quantity>2</Quantity><Price>3328.5</Price><Signal>ES</Signal><Profit>638</Profit></Trade>
//<Trade><Date><Year>2009</Year><Month>7</Month><Day>28</Day><Hour>17</Hour><Minute>30</Minute></Date><Type>Sell</Type><Quantity>2</Quantity><Price>3328.5</Price><Signal>ES</Signal></Trade>
//<Trade><Date><Year>2009</Year><Month>8</Month><Day>11</Day><Hour>18</Hour><Minute>30</Minute></Date><Type>SExit</Type><Quantity>2</Quantity><Price>3458</Price><Signal>EL</Signal><Profit>-2642</Profit></Trade>
//<Trade><Date><Year>2009</Year><Month>8</Month><Day>11</Day><Hour>18</Hour><Minute>30</Minute></Date><Type>Buy</Type><Quantity>2</Quantity><Price>3458</Price><Signal>EL</Signal></Trade>
//</Trades>

	// Last bar
	//
	if barOpen > 0 and barTime > lastBarTime then begin
		tm = TimeToMinutes(barTime);
		hh = IntPortion(tm / 60);
		FileAppend(TradesFile, "<Bar><Date><Year>" + NumToStr(1900 + Year(barDate), 0) +
		                       "</Year><Month>" + NumToStr(Month(barDate), 0) + "</Month><Day>" + NumToStr(DayOfMonth(barDate), 0) +
		                       "</Day><Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) +
		                       "</Minute></Date><Open>" + NumToStr(barOpen, nd) +
		                       "</Open><High>" + NumToStr(barHigh, nd) +
		                       "</High><Low>" + NumToStr(barLow, nd) +
		                       "</Low><Close>" + NumToStr(barClose, nd) +
		                       "</Close><Volume>" + NumToStr(0, 0) + "</Volume></Bar>" + NewLine);
	end;

	FileAppend(TradesFile, "</Prices>" + NewLine);
	FileAppend(TradesFile, "<Trades>" + NewLine);

	for cnt = TotalTrades downto 1 begin
		tm = EntryDate(cnt);
		if tm > 0 then begin
			if tm = ModEdate[Nmodal] and EntryTime(cnt) = ModEtime[Nmodal] then ncm = ModXcontracts[Nmodal] else ncm = 0;
	        ncg = MaxContracts(cnt) - ncm;

			Eline = "<Trade>";
			Eline = Eline + "<Date><Year>" + NumToStr(1900 + Year(tm), 0) + "</Year><Month>" + NumToStr(Month(tm), 0) + "</Month><Day>" + NumToStr(DayOfMonth(tm), 0) + "</Day>";
			tm = TimeToMinutes(EntryTime(cnt)); hh = IntPortion(tm / 60);
			Eline = Eline + "<Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) + "</Minute></Date>";
			if MarketPosition(cnt) > 0 then
				Eline = Eline + "<Type>Buy</Type><Signal>EL</Signal>"
			else
				Eline = Eline + "<Type>Sell</Type><Signal>ES</Signal>";
			Eline = Eline + "<Price>" + NumToStr(EntryPrice(cnt), nd) + "</Price>";

			profit = PositionProfit(cnt);
			if ncm > 0 then begin
				profit = ExitPrice(cnt) - EntryPrice(cnt);
				if MarketPosition(cnt) < 0 then
					profit = -profit;
				profit = (profit * BigPointValue - 2 * (Commission + Slippage)) * ncg;

				tm = ModXdate[Nmodal];
				Xline = "<Trade>";
				XLine = Xline + "<Date><Year>" + NumToStr(1900 + Year(tm), 0) + "</Year><Month>" + NumToStr(Month(tm), 0) + "</Month><Day>" + NumToStr(DayOfMonth(tm), 0) + "</Day>";
				tm = TimeToMinutes(ModXtime[Nmodal]);
				hh = IntPortion(tm / 60);
				XLine = Xline + "<Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) + "</Minute></Date>";
				if MarketPosition(cnt) > 0 then begin
					Xline = Xline + "<Type>LExit</Type><Signal>XL</Signal>";
					price = EntryPrice(cnt) + ((PositionProfit(cnt) - profit) / ncm + 2 * (Commission + Slippage)) / BigPointValue;
				end else begin
					Xline = Xline + "<Type>SExit</Type><Signal>XS</Signal>";
					price = EntryPrice(cnt) - ((PositionProfit(cnt) - profit) / ncm + 2 * (Commission + Slippage)) / BigPointValue;
				end;
				Xline = Xline + "<Price>" + NumToStr(price, nd) + "</Price>";

				FileAppend(TradesFile, Eline + "<Quantity>" + NumToStr(ncm, 0) + "</Quantity></Trade>" + NewLine);
				FileAppend(TradesFile, Xline + "<Quantity>" + NumToStr(ncm, 0) + "</Quantity>" +
				                               "<Profit>" + NumtoStr((PositionProfit(cnt) - profit) * CurrencyConversion, 2) + "</Profit></Trade>" + NewLine);

				Nmodal = Nmodal + 1;
			end;

			tm = ExitDate(cnt);
			Xline = "<Trade>";
			XLine = Xline + "<Date><Year>" + NumToStr(1900 + Year(tm), 0) + "</Year><Month>" + NumToStr(Month(tm), 0) + "</Month><Day>" + NumToStr(DayOfMonth(tm), 0) + "</Day>";
			tm = TimeToMinutes(ExitTime(cnt));
			hh = IntPortion(tm / 60);
			XLine = Xline + "<Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) + "</Minute></Date>";
			if MarketPosition(cnt) > 0 then begin
				Xline = Xline + "<Type>LExit</Type><Signal>XL</Signal>";
				price = EntryPrice(cnt) + (profit / ncg + 2 * (Commission + Slippage)) / BigPointValue;
			end else begin
				Xline = Xline + "<Type>SExit</Type><Signal>XS</Signal>";
				price = EntryPrice(cnt) - (profit / ncg + 2 * (Commission + Slippage)) / BigPointValue;
			end;
			//if price <> ExitPrice(cnt) and ncg > 1 then
			//	Print(EntryDate(cnt):7:0, " ", EntryTime(cnt):4:0, "  -  ", ExitDate(cnt):7:0, " ", ExitTime(cnt):4:0, ": ", price, " vs. ", ExitPrice(cnt));
			Xline = Xline + "<Price>" + NumToStr(price, nd) + "</Price>";

			FileAppend(TradesFile, Eline + "<Quantity>" + NumToStr(ncg, 0) + "</Quantity></Trade>" + NewLine);
			FileAppend(TradesFile, Xline + "<Quantity>" + NumToStr(ncg, 0) + "</Quantity>" +
			                               "<Profit>" + NumtoStr(profit * CurrencyConversion, 2) + "</Profit></Trade>" + NewLine);
		end;
	end;

	if MarketPosition <> 0 then begin
		tm = EntryDate;
		FileAppend(TradesFile, "<Trade><Date><Year>" + NumToStr(1900 + Year(tm), 0)
		                     + "</Year><Month>" + NumToStr(Month(tm), 0)
		                     + "</Month><Day>" + NumToStr(DayOfMonth(tm), 0) + "</Day>");
		tm = TimeToMinutes(EntryTime);
		hh = IntPortion(tm / 60);
		FileAppend(TradesFile, "<Hour>" + NumToStr(hh, 0) + "</Hour><Minute>" + NumToStr(tm - hh * 60, 0) + "</Minute></Date>");
		if MarketPosition > 0 then
			FileAppend(TradesFile, "<Type>Buy</Type>")
		else
			FileAppend(TradesFile, "<Type>Sell</Type>");
        ncg = MaxContracts;
		FileAppend(TradesFile, "<Quantity>" + NumToStr(ncg, 0) + "</Quantity><Price>" + NumToStr(EntryPrice, nd) + "</Price>");
		if MarketPosition > 0 then
			FileAppend(TradesFile, "<Signal>EL</Signal></Trade>" + NewLine)
		else
			FileAppend(TradesFile, "<Signal>ES</Signal></Trade>" + NewLine);
	end;

	FileAppend(TradesFile, "</Trades>" + NewLine);
	FileAppend(TradesFile, "</SystemMarket>" + NewLine);
	//Print("Numero Modali: ", Nmodal);
	Done = true;

end;

end;
