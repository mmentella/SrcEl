plot1(i_OpenEquity-i_ClosedEquity,"Position Profit");

if i_MarketPosition = 1 then SetPlotColor(1,cyan)
else if i_MarketPosition = -1 then SetPlotColor(1,red);
