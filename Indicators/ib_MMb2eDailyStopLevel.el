Inputs: funkl(3500),funks(3500);

vars: dru(0),plotx(0);

dru = MM.DailyRunup;

if i_MarketPosition = 1 then plotx  = c - (dru + funkl)/bigpointvalue;
if i_MarketPosition = -1 then plotx = c + (dru + funks)/bigpointvalue;

plot1(plotx,"FUNK");

if i_MarketPosition = 1 then SetPlotColor(1,lightgray);
if i_MarketPosition = -1 then SetPlotColor(1,red);
if i_MarketPosition = 0 then NoPlot(1);
